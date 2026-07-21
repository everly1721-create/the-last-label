"""Fetch only the Windows x64 files from Godot's large export template archive."""

from __future__ import annotations

import binascii
import pathlib
import struct
import sys
import urllib.request
import zlib


EOCD_SIGNATURE = b"PK\x05\x06"
CENTRAL_SIGNATURE = b"PK\x01\x02"
LOCAL_SIGNATURE = b"PK\x03\x04"
CENTRAL_HEADER = struct.Struct("<4s6H3I5H2I")
LOCAL_HEADER = struct.Struct("<4s5H3I2H")


def fetch_range(url: str, start: int, end: int) -> bytes:
    request = urllib.request.Request(url, headers={"Range": f"bytes={start}-{end}"})
    with urllib.request.urlopen(request, timeout=120) as response:
        data = response.read()
    expected = end - start + 1
    if len(data) != expected:
        raise RuntimeError(f"Range {start}-{end} returned {len(data)} bytes, expected {expected}")
    return data


def read_directory(url: str, archive_size: int) -> list[dict[str, int | str]]:
    tail_size = min(131_072, archive_size)
    tail_start = archive_size - tail_size
    tail = fetch_range(url, tail_start, archive_size - 1)
    eocd_at = tail.rfind(EOCD_SIGNATURE)
    if eocd_at < 0:
        raise RuntimeError("ZIP end-of-directory record was not found")
    eocd = struct.unpack_from("<4s4H2IH", tail, eocd_at)
    entry_count = eocd[4]
    directory_size = eocd[5]
    directory_offset = eocd[6]
    directory = fetch_range(url, directory_offset, directory_offset + directory_size - 1)

    entries: list[dict[str, int | str]] = []
    offset = 0
    for _ in range(entry_count):
        fields = CENTRAL_HEADER.unpack_from(directory, offset)
        if fields[0] != CENTRAL_SIGNATURE:
            raise RuntimeError(f"Invalid central directory entry at byte {offset}")
        flags = fields[3]
        name_length, extra_length, comment_length = fields[10:13]
        name_start = offset + CENTRAL_HEADER.size
        name_bytes = directory[name_start : name_start + name_length]
        encoding = "utf-8" if flags & 0x800 else "cp437"
        entries.append(
            {
                "name": name_bytes.decode(encoding),
                "compression": fields[4],
                "crc32": fields[7],
                "compressed_size": fields[8],
                "size": fields[9],
                "local_offset": fields[16],
            }
        )
        offset += CENTRAL_HEADER.size + name_length + extra_length + comment_length
    return entries


def extract_entry(url: str, entry: dict[str, int | str], output: pathlib.Path) -> None:
    local_offset = int(entry["local_offset"])
    local = fetch_range(url, local_offset, local_offset + LOCAL_HEADER.size - 1)
    fields = LOCAL_HEADER.unpack(local)
    if fields[0] != LOCAL_SIGNATURE:
        raise RuntimeError(f"Invalid local header for {entry['name']}")
    data_start = local_offset + LOCAL_HEADER.size + fields[9] + fields[10]
    compressed_size = int(entry["compressed_size"])
    print(f"Fetching {entry['name']} ({compressed_size / 1_048_576:.1f} MiB compressed)", flush=True)
    compressed = fetch_range(url, data_start, data_start + compressed_size - 1)
    method = int(entry["compression"])
    if method == 0:
        payload = compressed
    elif method == 8:
        payload = zlib.decompress(compressed, -zlib.MAX_WBITS)
    else:
        raise RuntimeError(f"Unsupported ZIP compression method {method}")
    if len(payload) != int(entry["size"]):
        raise RuntimeError(f"Size check failed for {entry['name']}")
    if binascii.crc32(payload) & 0xFFFFFFFF != int(entry["crc32"]):
        raise RuntimeError(f"CRC check failed for {entry['name']}")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(payload)
    print(f"Wrote {output} ({len(payload) / 1_048_576:.1f} MiB)", flush=True)


def main() -> None:
    if len(sys.argv) != 4:
        raise SystemExit("Usage: fetch_windows_templates.py URL ARCHIVE_SIZE OUTPUT_DIRECTORY")
    url = sys.argv[1]
    archive_size = int(sys.argv[2])
    output_directory = pathlib.Path(sys.argv[3])
    wanted = {
        "windows_debug_x86_64.exe",
        "windows_release_x86_64.exe",
        "version.txt",
    }
    matches = [entry for entry in read_directory(url, archive_size) if pathlib.PurePosixPath(str(entry["name"])).name in wanted]
    found_names = {pathlib.PurePosixPath(str(entry["name"])).name for entry in matches}
    missing = wanted - found_names
    if missing:
        raise RuntimeError(f"Template files missing from archive: {sorted(missing)}")
    for entry in matches:
        output_name = pathlib.PurePosixPath(str(entry["name"])).name
        extract_entry(url, entry, output_directory / output_name)


if __name__ == "__main__":
    main()
