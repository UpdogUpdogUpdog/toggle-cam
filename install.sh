#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TITLE="Webcam Toggle"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low -i toggle-cam "$TITLE" "$1"
    else
        echo "$1"
    fi
}

# -----------------------------------------------------------------------------
# Detect NixOS vs. “regular” Linux
# -----------------------------------------------------------------------------
IS_NIXOS=false
if grep -q '^ID=nixos' /etc/os-release 2>/dev/null; then
    IS_NIXOS=true
fi

if [ "$IS_NIXOS" = true ]; then
    echo "🛠  Detected NixOS – doing per‑user install in ~/.local/"
    PREFIX="$HOME/.local"

    # 1) script
    install -Dm755 "$SRC_DIR/bin/toggle-cam.sh" \
        "$PREFIX/bin/toggle-cam"

    # 2) desktop file
    install -Dm755 "$SRC_DIR/share/applications/toggle-cam.desktop" \
        "$PREFIX/share/applications/toggle-cam.desktop"

    # 3) launcher icon
    install -Dm644 "$SRC_DIR/share/icons/hicolor/48x48/apps/toggle-cam.png" \
        "$PREFIX/share/icons/hicolor/48x48/apps/toggle-cam.png"

    # 4) state icons
    install -Dm644 "$SRC_DIR/share/icons/on_toggle-cam.png" \
        "$PREFIX/share/icons/on_toggle-cam.png"
    install -Dm644 "$SRC_DIR/share/icons/off_toggle-cam.png" \
        "$PREFIX/share/icons/off_toggle-cam.png"

    # no sudo needed
    echo "✅ Installed under $PREFIX. You may need to log out/in or run:"
    echo "   export PATH=\$HOME/.local/bin:\$PATH"

else
    echo "🔧 Doing system‑wide install under /usr/local/"
    # 1) script
    sudo install -Dm755 "$SRC_DIR/bin/toggle-cam.sh" \
        /usr/local/bin/toggle-cam

    # 2) desktop file
    sudo install -Dm755 "$SRC_DIR/share/applications/toggle-cam.desktop" \
        /usr/local/share/applications/toggle-cam.desktop

    # 3) launcher icon
    sudo install -Dm644 "$SRC_DIR/share/icons/hicolor/48x48/apps/toggle-cam.png" \
        /usr/local/share/icons/hicolor/48x48/apps/toggle-cam.png

    # 4) state icons
    sudo install -Dm644 "$SRC_DIR/share/icons/on_toggle-cam.png" \
        /usr/local/share/icons/on_toggle-cam.png
    sudo install -Dm644 "$SRC_DIR/share/icons/off_toggle-cam.png" \
        /usr/local/share/icons/off_toggle-cam.png

    # 5) cache updates
    sudo gtk-update-icon-cache /usr/local/share/icons/hicolor &>/dev/null || true

    echo "✅ Installed system‑wide. Launch “Toggle Cam” from your app menu."

    # 6) service install
    install -Dm644 \
        "$SRC_DIR/share/systemd/user/toggle-cam.service" \
        "$HOME/.config/systemd/user/toggle-cam.service"

fi

notify "Installation complete. Now reload & enable the service:"
echo "  systemctl --user daemon-reload"
echo "  systemctl --user enable --now toggle-cam.service"
