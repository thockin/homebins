#!/bin/bash
#
# Install the following as /etc/udev/rules.d/99-thockin.rules
# ----
# SUBSYSTEM=="hid", ACTION=="bind", RUN+="/home/thockin/bin/usb-hotplug.sh"


# NOTE: systemd somehow still captures the output of this script, so use
# journalctl to see the output.
exec >> /tmp/thockin-usb.log 2>&1
chown thockin /tmp/thockin-usb.log

echo "-------------------------------"
date
echo "$0 $@"

export DISPLAY=:1

function set_mouse_buttons() {
  # Change the thumb button (8) to be middle-click (2)
  local id
  xinput list | grep "MX Vertical.*pointer" \
      | awk -F'	' '{print $2}' \
      | sed 's/id=//' \
      | while read -r id; do 
        if [ -n "$id" ]; then
            local map=($(xinput get-button-map "$id" | sed 's/ 8 / 2 /'))
            echo "  setting button map for ID $id to ${map[@]}"
            xinput set-button-map "$id" "${map[@]}"
        fi
      done
}
# FIXME: this is broken under Wayland. Replaced by:
# $ sudo cat /etc/udev/hwdb.d/70-mouse-remap.hwdb
# # remap buttons on Logitech MX Vertical
# evdev:name:Logitech MX Vertical:*
#  ID_INPUT_KEY=1
#  KEYBOARD_KEY_90004=btn_middle
#  KEYBOARD_KEY_90005=btn_middle
set_mouse_buttons

function set_webcam_zoom() {
    local devs=$(v4l2-ctl --list-devices -z "HD Pro Webcam C920" | grep /dev/)
    if [ -z "$devs" ]; then
      return
    fi
    for d in $devs; do
      v4l2-ctl -d $d --set-ctrl=zoom_absolute=180 2>/dev/null
  done
}
set_webcam_zoom
