# OpenAI Build Week Submission Draft

## Basics

- **Project name:** The Last Label
- **Tagline:** A trilingual third-person heritage horror game where museum labels become evidence.
- **Category:** Apps for Your Life
- **Platform:** Windows x64
- **Built with:** Codex with GPT-5.6, Godot 4.7.1, GDScript
- **Codex Session ID:** `019f83e1-ed0d-7e03-894b-1cdf9775c7b8`
- **Repository URL:** https://github.com/everly1721-create/the-last-label
- **Public demo video:** Pending
- **Test build:** https://github.com/everly1721-create/the-last-label/releases/download/v0.3.1/TheLastLabel-Windows-x64-v0.3.1.zip

## Inspiration

Museum labels often look definitive even when the archive behind them is incomplete, selective, or shaped by power. The Last Label turns that tension into a horror mechanic. I wanted to build a culturally grounded mystery that feels specific without copying a real heritage house or exploiting a real family history, so Tanjong Serai, Leong House, and every character are fictional.

## What It Does

The player controls Xu Anning, a present-day tourist visiting a Peranakan ancestral-house museum. A normal guided visit becomes impossible as other visitors vanish and labels rewrite themselves. Across a front hall, beadwork room, kitchen, counting room, and ancestor hall, the player collects five pieces of evidence about Leong Yuecheng, a young woman erased from the family record in 1919.

The playable chapter combines third-person exploration, an over-the-shoulder horror camera, environmental inspection, a beadwork pattern puzzle, a banquet seating puzzle encoded in an Ayam Pongteh recipe, ledger comparison, a short stealth sequence, and three evidence-dependent endings. The complete interface and story are playable in Chinese, English, and Bahasa Melayu.

## How I Built It

I built the game in Godot 4.7.1 with GDScript and the Compatibility renderer. The house is assembled from modular geometry and project-specific materials at runtime. Rooms are generated only when first entered to keep startup responsive on Intel HD 530-class hardware. A CharacterBody3D controller provides WASD movement, running, gravity, collision, camera-relative steering, and an over-the-shoulder camera.

The narrative is implemented as a deterministic state machine so every clue, puzzle, chase, and ending can be tested. Five headless suites verify full story completion, all three endings, English and Malay flows, portal and wall collision, fall recovery, six doors, furniture collision, and physically walking the player up the staircase.

## How I Used Codex and GPT-5.6

Codex with GPT-5.6 was the engineering collaborator throughout the core build. It translated my narrative and cultural-safety brief into a working Godot architecture, implemented the controller and interaction systems, created the multilingual content pipeline, generated and integrated visual materials, and repeatedly diagnosed issues from my screenshots and playtest reports.

The collaboration was especially useful when moving from a simple prototype to a third-person game. Codex profiled the startup freeze, changed the environment to lazy room construction, replaced a GPU-sensitive rain effect, added missing collision and usable doors, rebuilt the staircase as a walkable ramp with visible steps, and added automated physical navigation tests. I retained control of the story, fictionalization policy, puzzle meaning, visual direction, and final product decisions.

## Challenges

The largest challenge was creating a coherent 3D house quickly while keeping it playable on older integrated graphics. A visually richer scene initially caused long startup stalls, and early modular geometry allowed the player to pass through incomplete portals or become trapped by props. I addressed these failures with on-demand construction, compatibility-focused effects, explicit collision ownership, fall recovery, and tests that use the actual player controller instead of only checking whether nodes exist.

Another challenge was cultural specificity without presenting fiction as history. The solution was to make every proper noun, family event, and conspiracy fictional, document the inspiration clearly, avoid copying a real museum layout, and frame the horror around archival erasure rather than exoticizing the culture.

## Accomplishments

- A complete playable Windows chapter with five evidence items and three endings
- Chinese, English, and Bahasa Melayu localization with saved language selection
- A third-person camera, real collisions, functional doors, and a walkable upper gallery
- Project-specific textures and a fictional 1919 family photograph
- Runtime-synthesized ambience with no sampled archival or traditional recording
- Automated story, localization, collision, environment, and navigation tests
- A tested Windows x64 release that launches responsively on Intel HD 530 hardware

## What I Learned

The most important lesson was that environment art and gameplay collision cannot be treated as separate finishing passes in a traversal-heavy horror game. Small visual changes affect route readability, camera behavior, and puzzle interpretation. Screenshot-driven iteration with Codex was most effective when paired with executable tests for the invisible parts of the scene.

## What's Next

Next I would replace more modular props with authored environment meshes, add animation and facial performance, deepen the stealth encounter, improve controller support and accessibility, and complete native builds for more desktop platforms. The narrative can grow into a larger investigation while keeping this chapter's evidence-first structure and fictional setting.

## Testing Instructions

1. Download and extract `TheLastLabel-Windows-x64-v0.3.1.zip` from the repository release.
2. Run `TheLastLabel.exe` on Windows 10 or 11.
3. Choose English on the title screen.
4. Use WASD and the mouse to move; hold Shift to run; press E to inspect.
5. Follow the objective panel through all five evidence items and the ancestor-hall choice.

No account, network connection, paid service, or external hardware is required.
