# The Last Label

**A trilingual third-person heritage horror game where museum labels become evidence.**

The Last Label is a playable Windows chapter built with Godot 4.7.1 during OpenAI Build Week. The player arrives at the fictional Leong House museum in Tanjong Serai as an ordinary tourist. As the tour empties around her, exhibition labels begin to change and expose the erased story of Leong Yuecheng, the family's 1919 bookkeeper.

The location, family, characters, and crime are fictional. The architecture and domestic details are inspired by Peranakan ancestral-house culture from the Straits Settlements period; the game does not reproduce a real house, museum, or historical person.

## Play

### Windows build

1. Download the latest Windows release.
2. Extract the ZIP.
3. Run `TheLastLabel.exe`.

The title screen supports Chinese, English, and Bahasa Melayu. The selected language is saved locally.

### Controls

- `WASD`: move
- Mouse: over-the-shoulder camera
- `Shift`: run
- `E`: inspect or interact
- `Esc`: release the mouse; click the game view to recapture it

Headphones are recommended. The story contains references to death, drugging, and a short chase.

## Current Chapter

1. **Tourist arrival:** Xu Anning reaches the Leong House museum in the rain.
2. **Front hall:** scan five exhibits while the tour group and people in a family photograph disappear.
3. **Beadwork room:** decode phoenix, peony, butterfly, and pomegranate motifs, then hide from Leong Kai Wen's shadow.
4. **Kitchen:** read the Ayam Pongteh recipe twice and restore the 1919 banquet seating order.
5. **Counting room:** cross-check household, cargo, and pharmacy ledgers until the abacus reveals 1919.
6. **Ancestor hall:** place five pieces of evidence and choose truth, a beautiful lie, or destruction.

## Run From Source

Requirements:

- Godot 4.7.1 or a compatible Godot 4.x build
- Windows 10/11 for the packaged release

Open `project.godot` in Godot and press `F6` or `F5`, or run:

```powershell
godot --path .
```

## Verification

The repository includes headless smoke tests for story progression, localization, collision coverage, environment construction, and physical navigation:

```powershell
godot --headless --path . --script res://tests/story_smoke.gd
godot --headless --path . --script res://tests/localization_smoke.gd
godot --headless --path . --script res://tests/collision_smoke.gd
godot --headless --path . --script res://tests/environment_v3_smoke.gd
godot --headless --path . --script res://tests/navigation_v3_smoke.gd
```

The v0.3.1 release passes all five suites. The navigation test moves the real player controller up the staircase and verifies that furniture blocks movement.

## Built With Codex and GPT-5.6

This project was developed collaboratively in Codex with GPT-5.6. Codex accelerated the work by:

- turning the narrative outline into a complete state-driven chapter with five evidence items and three endings;
- implementing the third-person controller, over-the-shoulder camera, interaction system, multilingual UI, and saved language preference;
- generating the Godot scene-building code and project-specific visual textures, then profiling and changing room construction to load on demand for an older Intel GPU;
- diagnosing reported playtest failures such as falling through portals, missing collision, a non-walkable staircase, inaccessible rooms, and a wallpaper panel covering the family photograph;
- writing automated tests that exercise story branches, localization, physical collision, stairs, furniture, and the packaged Windows build.

The human creator made the core narrative, cultural-safety, product, and visual-direction decisions, including the fictional setting, the evidence structure, the non-exploitative endings, the third-person horror presentation, and the requirement for Chinese, English, and Malay play.

Core Codex Session ID: `019f83e1-ed0d-7e03-894b-1cdf9775c7b8`

## Technical Notes

- Engine: Godot 4.7.1, Compatibility renderer
- Language: GDScript
- Platform: Windows x64
- Performance: rooms are built lazily when first entered; rain uses CPU particles for compatibility with Intel HD 530-class hardware
- Visuals: custom Peranakan-inspired floor tile, aged lime plaster, dark teak, fictional family portrait, and wallpaper textures
- Audio: rain, room tone, record crackle, and sparse night music are synthesized at runtime

## License

Project code is released under the MIT License. See [LICENSE](LICENSE). Third-party and generated-asset provenance is documented in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

---

## 中文简介

《最后的展签》是一款 Godot 4.7.1 制作的第三人称叙事恐怖游戏。玩家许安宁在虚构海峡小城香兰港参观梁宅博物馆，并通过合照、珠绣、食谱、药房账与货运单，还原一位被家族记录抹去的少女。

标题画面可选择中文、English 或 Bahasa Melayu。地点、家族、人物与阴谋均为虚构；作品只从海峡殖民地时期的峇峇娘惹祖屋文化中获取灵感，不复刻任何真实宅邸或人物。
