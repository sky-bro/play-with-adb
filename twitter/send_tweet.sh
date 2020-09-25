#!/bin/bash

source '../utils/basic_ops.sh';

id=91630c96 # my op6 (adb devices)

send_tweet() {
    launch_activity com.twitter.android/com.twitter.composer.ComposerActivity;
    sleep 1;
    echo "tweeting: $1";
    send_text "$1";
    sleep .2;
    click 968 152; # the tweet button position
}

switch_ime_adbkeyboard;
send_tweet "$(fortune -sn 140)";
