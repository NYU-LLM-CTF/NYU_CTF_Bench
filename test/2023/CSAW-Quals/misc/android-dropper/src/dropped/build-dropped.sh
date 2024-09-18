#!/bin/sh

rm Dropped.class
rm Dropped.jar
rm classes.dex

javac -source 8 -target 8 Dropped.java 
jar cvf Dropped.jar Dropped.class
d8 --lib /Users/g/Library/Android/sdk/platforms/android-33/android.jar Dropped.jar

base64 -i classes.dex
