#!/bin/sh

notify() {
    local title="Webcam Toggle"
    on_icon = "/usr/share/icons/on_toggle-cam.png"
    off_icon = "/usr/share/icons/off_toggle-cam.png"

    if command -v kdialog >/dev/null 2>&1; then
            if [ $1 = "Camera enabled." ]; then
                icon=$on_icon
            else
                icon=$off_icon
            fi
        kdialog --title "$title" --icon $icon --passivepopup "$1" 3
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send -u low "$title" "$1"
    else
        echo "$1"
    fi
}

unbound=0
found=0

for vdev in /sys/class/video4linux/video*; do
    device_path=$(readlink "$vdev/device" 2>/dev/null)
    [ -z "$device_path" ] && continue

    device_id=$(basename "$device_path")
    driver_path="/sys/bus/usb/drivers/uvcvideo/$device_id"
    found=1

    if [ -e "$driver_path" ]; then
        echo "Attempting to unbind $device_id from uvcvideo..."

        retries=5
        success=0

        for i in $(seq 1 $retries); do
            echo "$device_id" | sudo tee /sys/bus/usb/drivers/uvcvideo/unbind >/dev/null
            sleep 1

            if [ ! -e "$driver_path" ]; then
                echo "$device_id successfully unbound after $i attempt(s)."
                success=1
                break
            else
                echo "Unbind attempt $i failed... retrying in 5s."
                sleep 5
            fi
        done

        if [ "$success" -eq 1 ]; then
            unbound=1
        else
            echo "Failed to unbind $device_id after $retries attempts. Skipping."
        fi
    fi
done

if [ "$unbound" -eq 1 ]; then
    echo "Unbinding done, trying to unload uvcvideo..."
    sudo modprobe -r uvcvideo
    notify "Camera disabled."
else
    echo "Reloading uvcvideo and re-binding all cameras..."
    sudo modprobe -r uvcvideo 2>/dev/null
    sleep 3
    sudo modprobe uvcvideo
    sleep 3

    for vdev in /sys/class/video4linux/video*; do
        device_path=$(readlink "$vdev/device" 2>/dev/null)
        [ -z "$device_path" ] && continue

        # Optional rebind, currently commented:
        # device_id=$(basename "$device_path")
        # echo "$device_id" | sudo tee /sys/bus/usb/drivers/uvcvideo/bind >/dev/null
    done

    notify "Camera enabled." 
fi
