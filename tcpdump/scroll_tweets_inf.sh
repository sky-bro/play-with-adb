#!/bin/bash

source '../utils/basic_ops.sh'

id=${1:-91630c96} # my op6 (adb devices)
# https://apps.evozi.com/apk-downloader/?id=com.twitter.android
scroll_tweet_inf() {
    launch_activity com.twitter.android/.StartActivity;
    sleep 6;
    k=0;
    while true
    do
        echo "---------loop $((++k))-----------";
        sleep 3;
        scroll_down;
        sleep .3;
        # scroll_down;
        # sleep .3;
    done;
}

scroll_tweet_inf;
