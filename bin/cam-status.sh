# ~/.local/bin/cam-status.sh
#!/usr/bin/env bash
last=""

# 1) initial state detection
bound=0
for vdev in /sys/class/video4linux/video*; do
  dev=$(basename "$(readlink "$vdev/device" 2>/dev/null)" || continue)
  [ -e "/sys/bus/usb/drivers/uvcvideo/$dev" ] && { bound=1; break; }
done
lsmod | grep -q '^uvcvideo' && loaded=1 || loaded=0

if (( bound || loaded )); then
  echo "Camera enabled"
  last="add"
else
  echo "Camera disabled"
  last="remove"
fi

# 2) watch for changes
udevadm monitor --udev --subsystem-match=video4linux \
  | while read -r _ _ action _; do
      if [ "$action" != "$last" ]; then
        last="$action"
        case "$action" in
          add)    echo "Camera enabled" ;;
          remove) echo "Camera disabled" ;;
        esac
      fi
    done
