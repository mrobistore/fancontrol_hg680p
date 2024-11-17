wget -O - https://raw.githubusercontent.com/mrobistore/fancontrol_hg680p/main/install_fan_control.sh | sh


mkdir -p /tmp/fan_control/CONTROL
mkdir -p /tmp/fan_control/etc/config
mkdir -p /tmp/fan_control/root
mkdir -p /tmp/fan_control/usr/lib/lua/luci/controller
mkdir -p /tmp/fan_control/usr/lib/lua/luci/model/cbi/fan
mkdir -p /tmp/fan_control/etc/init.d