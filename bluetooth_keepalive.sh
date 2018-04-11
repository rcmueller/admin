#!/bin/bash

## script for the Generic Monitor goody (XFWM)
## http://goodies.xfce.org/projects/panel-plugins/xfce4-genmon-plugin
## refresh panel plugin: xfce4-panel --plugin-event=genmon-X:refresh:bool:true

# set bluetooth supervision timeout to max (0 is infinite)
hcitool -i hci0 lst 90:7F:61:00:59:5C 65535
#hcitool -i hci0 lst 90:7F:61:00:59:5C 0

# icon for the panel item
echo "<img>/usr/share/icons/elementary-xfce-dark/panel/24/bluetooth-paired.png</img>"

# tooltip label; show device name and current link quality (not sure if it really reflects link quality)
echo -e "<tool>$(hcitool -i hci0 name 90:7F:61:00:59:5C)\n \
				$(hcitool -i hci0 tpl 90:7F:61:00:59:5C)\n \
				$(hcitool -i hci0 rssi 90:7F:61:00:59:5C)\n \
				$(hcitool -i hci0 clkoff 90:7F:61:00:59:5C)\n \
				$(hcitool -i hci0 lq 90:7F:61:00:59:5C | awk '{print $1" "$2" "$3/255*100" %"}')</tool>"

# panel item bar with current link quality; max quality seems to be 255
echo "<bar>"$(hcitool -i hci0 lq 90:7F:61:00:59:5C | awk '{print $3/255*100}')"</bar>"

# command to be exectued by generic monitor; keep connection alive
#hcitool -i hci0 cc 90:7F:61:00:59:5C && hcitool -i hci0 auth 90:7F:61:00:59:5C

# if link quality drops 10%, send notification and reconnect
if [ `hcitool -i hci0 lq 90:7F:61:00:59:5C | awk 'percent=sprintf("%d", $3/255*100) {print percent}'` -lt 10 ]; then
	hcitool -i hci0 dc 90:7F:61:00:59:5C
	hciconfig reset
	hcitool -i hci0 cc 90:7F:61:00:59:5C && hcitool -i hci0 auth 90:7F:61:00:59:5C
	notify-send -u critical -t 3000 -i /usr/share/icons/hicolor/scalable/apps/bluetooth.svg Bluetooth "connection reset" 
  ## beware: -t <milliseconds> parameter ignored by Ubuntu's Notify OSD and GNOME Shell
fi

# debug
date >> /tmp/bluetooth.stat
hcitool dev >> /tmp/bluetooth.stat
hcitool -i hci0 tpl 90:7F:61:00:59:5C >> /tmp/bluetooth.stat
hciconfig commands >> /tmp/bluetooth.stat
#hcitool -i hci0 info 90:7F:61:00:59:5C >> /tmp/bluetooth.stat
