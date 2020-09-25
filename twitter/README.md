# control twitter with adb

## Send Tweet

This is a very simple example, feel free to check the source code here: [send_tweet.sh](./send_tweet.sh)

* description: send a tweet (contents from `fortune`)
* steps
  1. launch tweet composer activity
  2. input text from `fortune -sn 140` (short fortune text, shorter than 140 characters)
  3. click tweet button to send the tweet (enable `pointer locations` / `touch data` in developer settings)

## Browse Tweet

* description: browse tweets, click in people's profile image
* steps
  1. launch activity
  2. scroll down 2 times
  3. click first profile image on the screen
  4. scroll down 2 times
  5. back
  6. goto step 2

This one is a little different from the previous one, the key here is to get the coords of people's profile image, but as we scroll down, unlike the tweet button, people's profile image position could be very random, after some searching, I got my solution [browse_tweets.sh](./browse_tweets.sh) from [this answer](https://stackoverflow.com/a/50027374/14335187):

The [view.xml](./view.xml) is an example of ui layout in twitter I dumped (with command `adb pull $(adb shell uiautomator dump | grep -oP '[^ ]+.xml') ./view.xml` ) as I scroll down and stopped at some random place, to get the profile image position, I used this line:

```shell
coords=$(adb shell -x uiautomator dump /dev/fd/1 | perl -ne 'printf "%d %d\n", ($1+$3)/2, ($2+$4)/2 if /resource-id="com.twitter.android:id\/tweet_profile_image"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"/' | head -n 1)
```

The `bounds` attribute gievs us the top-left and bottom-right coords of our element, and I use them to get the center of
the element and click into people's profile image.

