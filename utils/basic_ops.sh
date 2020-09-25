#!/bin/bash

# id=91630c96

switch_ime_adbkeyboard() {
    # use `adb shell ime list -a` to see all ime's
    adb -s $id shell ime set com.android.adbkeyboard/.AdbIME;
}

adb_clear() {
  adb shell am broadcast -a ADB_CLEAR_TEXT;
}

scroll_down() {
    # swipe from (250, 800) to (250, 400) with duration of 100ms
    adb -s $id shell input swipe 250 800 250 400 100;
}

scroll_up() {
    # swipe from (250, 400) to (250, 800) with duration of 100ms
    adb shell input swipe 250 400 250 800 100;
}

launch_activity() {
    # adb shell dumpsys package | grep -i 'twitter' | grep Activity
    adb -s $id shell am start -n $1;
    sleep 1;
}

send_text() {
    echo "sending text: $1";
    for ((i=0;i<${#1};i+=50));
    do
        # adb -s $id shell am broadcast -a ADB_INPUT_TEXT --es msg "$1";
        adb shell am broadcast -a ADB_INPUT_B64 --es msg "$(echo -n "${1:$i:50}" | base64)" >> /dev/null;
        # sleep .1;
    done;
}

click() {
    echo "clicking: ($1, $2)";
    adb -s $id shell input touchscreen tap $1 $2;
}
