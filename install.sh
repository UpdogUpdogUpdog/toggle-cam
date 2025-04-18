#!/usr/bin/env bash
set -euo pipefail

# directory containing this script
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Installing Toggle‑Cam…"

# 1. Script → /usr/bin/toggle-cam
sudo install -Dm755 "$SRC_DIR/bin/toggle-cam.sh" /usr/bin/toggle-cam

# 2. Desktop file → /usr/share/applications/
sudo install -Dm644 \
    "$SRC_DIR/share/applications/toggle-cam.desktop" \
    /usr/share/applications/toggle-cam.desktop

# 3. Icon → /usr/share/icons/hicolor/48x48/
sudo install -Dm644 \
    "$SRC_DIR/share/icons/hicolor/48x48/toggle-cam.png" \
    /usr/share/icons/hicolor/48x48/toggle-cam.png

# 4. Refresh icon cache (quietly)
sudo gtk-update-icon-cache /usr/share/icons/hicolor &>/dev/null || true

echo "✅ Installed!"
echo "   • Run ‘toggle-cam’ in a terminal, or find “Toggle‑Cam” in your app launcher."
