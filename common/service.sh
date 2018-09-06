#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread
#boot detection
until [ $(getprop init.svc.bootanim) = "stopped" ]
do
sleep 2
done
#start wifi adb
setprop service.adb.tcp.port 5555
stop adbd
start adbd
#waiting for brevent_server start
until [ ! -z "$(ps | grep brevent_server | grep -v grep)" ]
do
#open brevent to autostart BrevenServer via wifi adb
am start --user 0 -n me.piebridge.brevent/.ui.BreventActivity
sleep 5
done
#exit brevent
am force-stop me.piebridge.brevent
#stop wifi adb
setprop service.adb.tcp.port -1
stop adbd
start adbd
