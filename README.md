# paly with adb

## intro

this repo is my notes on testing android (I use op6) with adb...

* [x] capture traffic with tcpdump & wireshark
* [x] twitter
  * [x] scroll tweets and visit people's profile
  * [x] send a tweet
* [ ] facebook

## setup your env

* get [SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools)
* enable developer mode, then
  * enable use debugging / wireless ADB debugging
  * enable pointer locations (touch data) to get the (x, y) coordinates
* (optional) root your device if you want to run tcpdump directly on your phone

## Basic Operations

### tap

To click (tap) at (300, 400): `adb shell input touchscreen tap 300 400`

### scroll

`adb shell input swipe <start_x> <start_y> <end_x> <end_y> duration_ms>`

swipe the screen to scroll, swipe from `start` to `end` and use `duration` to control the speed, the smaller the `duration`, the faster you scroll.

* scroll up: `adb shell input swipe 250 400 250 800 100` (==swipe down, swipe from (250, 400) to (250, 800) with duration of 100ms)

* scroll down: `adb shell input swipe 250 800 250 400 100` (==swipe up, swipe from (250, 800) to (250, 400) with duration of 100ms)

### text input

you can use `input` command to input text or keyevents: `adb shell input [text|keyevent]` (some keyevents are for text input, some are for special operations like turning up the volume, see [android doc: KeyEvent Code Ref](http://developer.android.com/reference/android/view/KeyEvent.html) for more details)

but we can only input ascii texts, so `adb shell input text "你好"` will fail.

to solve this issue, you can use [senzhk](https://github.com/senzhk)'s [ADBKeyBoard](https://github.com/senzhk/ADBKeyBoard).

#### use ADBKeyBoard to input texts

1. grab apk from https://github.com/senzhk/ADBKeyBoard/raw/master/ADBKeyboard.apk, use `adb install ADBKeyboard.apk` to install it.
2. enable 'ADBKeyBoard' in the settings
3. `adb shell ime list -a` to get available input methods, use `adb shell ime set com.android.adbkeyboard/.AdbIME` to set current input method to adbkeyboard
4. send Broadcast intent via adb: `adb shell am broadcast -a ADB_INPUT_TEXT --es msg '你好嗎? Hello?'` or `` adb shell am broadcast -a ADB_INPUT_B64 --es msg `echo -n '你好嗎? Hello?' | base64` ``.
   or if you still have any problem, try something like this:

    ```shell
    send_text() {
      echo "sending text: $1";
      for ((i=0;i<${#1};i+=50));
      do
          adb shell am broadcast -a ADB_INPUT_B64 --es msg "$(echo -n "${1:$i:50}" | base64)" >> /dev/null;
      done;
    }
    send_text "$(fortune)";
    ```

#### some keyevents code

```txt
3 -> KEYCODE_HOME
4 -> KEYCODE_BACK
26 -> KEYCODE_POWER
82 -> KEYCODE_MENU

24 -> KEYCODE_VOLUME_UP
25 -> KEYCODE_VOLUME_DOWN
220 -> KEYCODE_BRIGHTNESS_DOWN
221 -> KEYCODE_BRIGHTNESS_UP

66 -> KEYCODE_ENTER
67 -> KEYCODE_DEL
```

e.g. `adb shell input keyevent 24` will turn up the volume

## refs

* [SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools)
* [github: ADBKeyBoard](https://github.com/senzhk/ADBKeyBoard)
* [android doc: KeyEvent Code Ref](http://developer.android.com/reference/android/view/KeyEvent.html)
* [Analyzing Android Network Traffic](https://code.tutsplus.com/tutorials/analyzing-android-network-traffic--mobile-10663)
* [Calls, scripts and more, playing with ADB](https://hacklabos.org/en/project/calls-scripts-and-more-playing-with-adb/)
* [tcpdump man page](https://www.tcpdump.org/tcpdump_man.html)
* [ADB and tcpdump on Android for Live Wireshark Tracing](https://blog.wirelessmoves.com/2017/02/adb-and-tcpdump-on-android-for-live-wireshark-tracing.html)
