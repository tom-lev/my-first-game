# Coin Dash

A small 2D platformer for Android, built with **Godot 4.3** and developed fully in the cloud (GitHub Codespaces + Claude Code).

Collect all 10 coins. Keyboard: arrows / WASD + Space. Touch: on-screen buttons.

## Working in a Codespace
1. **Code → Codespaces → Create codespace on main.** The first start installs Godot 4.3, its export templates and Claude Code automatically (takes a few minutes).
2. In the terminal run `claude` and log in.
3. Quick browser preview:
   ```bash
   mkdir -p build/web
   godot --headless --export-release "Web" build/web/index.html
   cd build/web && python3 -m http.server 8000
   ```
   Open port 8000 from the **Ports** tab.

## Getting the APK
Every push to `main` runs **Actions → Build APK and Web**. Download `android-apk` from the run's Artifacts, unzip, and install the `.apk` on your phone (allow installs from unknown sources).
