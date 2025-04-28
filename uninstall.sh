#!/usr/bin/env bash
set -euo pipefail

echo "🧹 Uninstalling toggle‑cam completely…"

# 1) Stop & disable the user‑service
systemctl --user stop  toggle-cam.service 2>/dev/null || true
systemctl --user disable toggle-cam.service 2>/dev/null || true

# 2) Remove the user service unit
rm -f ~/.config/systemd/user/toggle-cam.service

# 3) Remove user‑installed files
rm -f ~/.local/bin/toggle-cam
rm -f ~/.local/share/applications/toggle-cam.desktop
rm -f ~/.local/share/icons/hicolor/48x48/apps/toggle-cam.png
rm -f ~/.local/share/icons/on_toggle-cam.png
rm -f ~/.local/share/icons/off_toggle-cam.png

# 4) Reload the user daemon
systemctl --user daemon-reload

# 5) Stop & disable the root helper (if present)
sudo systemctl stop  toggle-cam-root@"$USER".service 2>/dev/null || true
sudo systemctl disable toggle-cam-root@"$USER".service 2>/dev/null || true

# 6) Remove root helper unit & polkit rule
sudo rm -f /etc/systemd/system/toggle-cam-root@.service
sudo rm -f /etc/polkit-1/rules.d/50-toggle-cam.rules

# 7) Remove system‑wide installs (if any)
sudo rm -f /usr/local/bin/toggle-cam
sudo rm -f /usr/local/share/applications/toggle-cam.desktop
sudo rm -f /usr/local/share/icons/hicolor/48x48/apps/toggle-cam.png
sudo rm -f /usr/local/share/icons/on_toggle-cam.png
sudo rm -f /usr/local/share/icons/off_toggle-cam.png
sudo gtk-update-icon-cache /usr/local/share/icons/hicolor &>/dev/null || true

# 8) Reload the systemd system daemon
sudo systemctl daemon-reload

#9 ) Remove the unzipped repo and install media in home
rm -rf ~/toggle-cam*

systemctl --user disable --now cam-status || true
rm -f "~/.config/systemd/user/cam-status.service"


echo "✅ toggle‑cam has been fully uninstalled."
