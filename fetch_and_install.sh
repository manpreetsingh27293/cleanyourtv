#!/bin/bash

# 1. Ask for TV IP if not provided
if [ -z "$1" ]; then
    read -p "Enter TV IP Address (e.g. 192.168.1.50): " TV_IP
else
    TV_IP="$1"
fi

# 2. Setup temporary folder in Termux
TMP_DIR="/tmp/github_apk_build"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "📥 Fetching latest compiled APK directly from GitHub Actions..."

# 3. Download the latest artifact directly into Termux temp folder
gh run download --name CleanYourTV-Glass-Launcher --dir "$TMP_DIR"

# Check if APK downloaded successfully
APK_FILE=$(find "$TMP_DIR" -name "*.apk" | head -n 1)

if [ -z "$APK_FILE" ]; then
    echo "❌ Failed to fetch APK from GitHub! Make sure your GitHub Action run completed successfully."
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "📦 Found APK in Termux temp memory: $APK_FILE"
echo "📡 Connecting to TV at $TV_IP:5555..."

# 4. Connect over ADB Wi-Fi
adb disconnect
adb connect "$TV_IP:5555"

echo "⏳ Installing directly to TV..."

# 5. Install APK to TV
adb install -r -g "$APK_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Success! Installed on TV directly from GitHub."
else
    echo "❌ Installation failed. Ensure ADB Network Debugging is enabled on your TV."
fi

# 6. Clean up temp files from Termux
rm -rf "$TMP_DIR"
echo "🧹 Temporary build files cleared from phone memory."
