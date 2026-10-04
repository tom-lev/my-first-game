#!/usr/bin/env bash
# Runs once when the Codespace is created. Installs Godot 4.3, its export
# templates (needed for the Web export), and Claude Code.
set -euo pipefail

GODOT_VERSION="4.3"
BASE_URL="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable"
TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"

sudo apt-get update -y
sudo apt-get install -y unzip wget

echo "==> Installing Godot ${GODOT_VERSION}"
wget -q "${BASE_URL}/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip"
unzip -q "Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip"
sudo mv "Godot_v${GODOT_VERSION}-stable_linux.x86_64" /usr/local/bin/godot
sudo chmod +x /usr/local/bin/godot

echo "==> Installing export templates"
wget -q "${BASE_URL}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz"
unzip -q "Godot_v${GODOT_VERSION}-stable_export_templates.tpz"
TEMPLATE_DIR="$HOME/.local/share/godot/export_templates/${GODOT_VERSION}.stable"
mkdir -p "$TEMPLATE_DIR"
mv templates/* "$TEMPLATE_DIR/"

echo "==> Installing Claude Code"
npm install -g @anthropic-ai/claude-code

cd /
rm -rf "$TMP_DIR"

echo "==> Done"
godot --version
claude --version || true
