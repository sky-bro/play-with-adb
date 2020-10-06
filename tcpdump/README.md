# capture traffic on android

## prerequisites

* an andoird with root
* tcpdump
* wireshrk

## get tcpdump

* check if your phone already has tcpdump

```shell
adb shell
type tcpdump
```

* if not, download one and adb push to your device, and make it executable. (do not push it to your sdcard, it cannot be executed from there)

```shell
adb push tcpdump /data/local/tcpdump
adb shell "su -c 'chmod 555 /data/local/tcpdump'"
# adb shell "su -c 'ls -al /data/local/tcpdump'"
```

## run tcpdump

* you can run tcpdump on your android and write the captured traffic also on your android
```shell
adb shell "su -c '/data/local/tcpdump -i wlan0 -U -w path_on_your_phone.pcap'"
```
* you can also run tcpdump on your android, and pipe the traffic to the wireshark on your computer
```shell
adb shell "su -c '/data/local/tcpdump -i wlan0 -U -w - 2>/dev/null'" | wireshark -k -S -i -
```
* or you can download the traffic to your computer
```shell
adb shell "su -c '/data/local/tcpdump -i wlan0 -U -w - 2>/dev/null'" >> path_on_your_computer.pcap
```

## refs

* [ADB and tcpdump on Android for Live Wireshark Tracing](https://blog.wirelessmoves.com/2017/02/adb-and-tcpdump-on-android-for-live-wireshark-tracing.html)
