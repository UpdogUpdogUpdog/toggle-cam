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
IS_NIXOS=${IS_NIXOS:-false}
if [ "$IS_NIXOS" = false ] && grep -q '^ID=nixos' /etc/os-release 2>/dev/null; then
    IS_NIXOS=true
fi

if [ "$IS_NIXOS" = true ]; then
    echo "🛠  Detected NixOS – doing per‑user install in ~/.local/"
    PREFIX="${PREFIX:-$HOME/.local}"
    DOTCONFIG="${DOTCONFIG:-$HOME/.config}"

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

    echo "Installing systemd user unit…"
    echo "DEBUG: Install -Dm755 quote $SRC_DIR/bin/cam-status.shquote slash newline quote $PREFIX/bin/cam-status quote"
    # Service installation
    install -Dm755 "$SRC_DIR/bin/cam-status.sh" \
        "$PREFIX/bin/cam-status"

    echo "DEBUG: Install -Dm644 quote $SRC_DIR/share/systemd/user/cam-status.service quote slash newline quote $DOTCONFIG/systemd/user/cam-status.service quote"
    install -Dm644 "$SRC_DIR/share/systemd/user/cam-status.service" \
        "$DOTCONFIG/systemd/user/cam-status.service"

    # reload user‐units, enable & start
    echo "now run the following"
    echo "systemctl --user daemon-reload"
    echo "systemctl --user enable --now cam-status"
 

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

    echo "Installing systemd user unit…" 
    # Service installation
    sudo install -Dm755 "$SRC_DIR/bin/cam-status.sh" \
        /usr/local/bin/cam-status

    sudo install -Dm644 "$SRC_DIR/share/systemd/system/cam-status.service" \
        /etc/systemd/system/cam-status.service
    # reload systemd, enable & start
    sudo systemctl daemon-reload
    sudo systemctl enable --now cam-status
    
fi





chmod +x "$SRC_DIR/uninstall.sh"

notify "Installation complete."
