#!/bin/bash

source '../utils/basic_ops.sh'

id=91630c96 # my op6 (adb devices)

view_profile() {
    # sleep 1;
    # ref: https://stackoverflow.com/questions/18924968/using-adb-to-access-a-particular-ui-control-on-the-screen
    # get the profile_image coords on the screen and pick the first to view (click)
    coords=$(adb shell -x uiautomator dump /dev/fd/1 | perl -ne 'printf "%d %d\n", ($1+$3)/2, ($2+$4)/2 if /resource-id="com.twitter.android:id\/tweet_profile_image"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"/' | head -n 1)
    coords=($coords)
    # do not click when the y axis is too small ( may click on the status bar )
    echo "coords: ${coords[*]}";
    # no coords found, no click
    if [ ${#coords} -ne 2 ] || [ ${coords[1]} -lt 150 ];
    then
        return 1;
    fi
    click "${coords[@]}"
}

browse_tweets() {
    launch_activity com.twitter.android/.StartActivity;
    for k in {1..20};
    do
        echo "---------loop ${k}-----------";
        sleep 1;
        scroll_down;
        sleep .3;
        scroll_down;
        sleep .3;
        view_profile;
        # if did not click in, next round
        if [ $? -ne 0 ]; then
            continue;
        fi
        sleep 1;
        scroll_down;
        sleep .3;
        scroll_down;
        sleep .3;
        # back
        adb -s $id shell input keyevent 4;
    done;
}

browse_tweets;
