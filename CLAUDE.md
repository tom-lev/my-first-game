# Project rules

This is a 2D mobile game built with **Godot 4.3** and **GDScript**, developed entirely in the cloud (GitHub Codespaces). There is no Godot editor GUI — scenes and scripts are edited as text.

## Environment
- Godot is installed as `godot` (Linux editor binary, used with `--headless`).
- Do not change the Godot version (4.3). The GitHub Actions workflow depends on it.

## After every change
1. Run `godot --headless --path . --quit` and make sure there are no script or scene errors.
2. If you changed anything visual or gameplay-related, export the web build and tell the user to check it:
   `mkdir -p build/web && godot --headless --export-release "Web" build/web/index.html`
   then serve it with `cd build/web && python3 -m http.server 8000`.

## Conventions
- The game is landscape, 1280x720 base resolution, `gl_compatibility` renderer (required for Web export).
- It must work with both keyboard (arrows/WASD + Space) and touch (on-screen zones).
- No external image/audio assets unless asked; draw with `Polygon2D` / `ColorRect`.
- On-screen text must be in English (the default font has no Hebrew glyphs).
- Keep commits small and frequent.

## Build / release
- Pushing to `main` triggers `.github/workflows/build-apk.yml`, which builds a debug APK and uploads it as an artifact.
- Export presets live in `export_presets.cfg` ("Web" and "Android"). Don't rename them.
