#!/bin/bash

# 1. Ask for TV IP Address if not passed as an argument
if [ -z "$1" ]; then
    read -p "Enter your TV's IP Address (e.g. 192.168.1.50): " TV_IP
else
    TV_IP="$1"
fi

# 2. Locate the newest APK in your Downloads folder or project folder
APK_PATH=$(ls -t /sdcard/Download/*.apk /sdcard/Download/*/*.apk 2>/dev/null | head -n 1)

if [ -z "$APK_PATH" ]; then
    echo "❌ Error: No APK found in /sdcard/Download! Please download your GitHub artifact APK first."
    exit 1
fi

echo "📦 Found APK: $APK_PATH"
echo "📡 Connecting to TV at $TV_IP:5555..."

# 3. Connect over ADB
adb disconnect
adb connect "$TV_IP:5555"

echo "⏳ Installing APK to TV..."

# 4. Install APK (-r replaces existing app, -g grants all permissions)
adb install -r -g "$APK_PATH"

if [ $? -eq 0 ]; then
    echo "✅ Successfully installed on your TV!"
else
    echo "❌ Installation failed. Ensure 'Network Debugging' is enabled in TV Developer Options."
fi
