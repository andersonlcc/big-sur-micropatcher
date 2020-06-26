#!/bin/bash
VERSIONNUM="0.0.3pre"
VERSION="BarryKN Big Sur Micropatcher Unpatcher v$VERSIONNUM"

echo $VERSION
# Add a blank line of output to make things easier on the eyes.
echo

# Add disclaimer
echo "It's really best to recreate the USB stick using createinstallmedia,"
echo "but this takes much less time and is useful for patcher development."
echo

# Hardcoded for now. (The assumptions are that the recovery USB stick was
# created using createinstallmedia and was not renamed afterward -- and that
# there is only one Big Sur recovery USB stick plugged into this Mac.)
VOLUME='/Volumes/Install macOS Beta'

# A quick sanity check before we begin.
if [ ! -d "$VOLUME/Install macOS Beta.app" ]
then
    echo "Failed to properly locate Big Sur recovery USB stick for unpatching."
    echo
    echo "Patcher cannot continue and will now exit."
    exit 1
fi


# Undo the boot-time compatibility check patch, if present
echo 'Checking for boot-time compatibility check patch (v0.0.1/v0.0.2).'
if [ -e "$VOLUME/System/Library/CoreServices/PlatformSupport.plist.inactive" ]
then
    echo 'Removing boot-time compatibility check patch.'
    mv "$VOLUME/System/Library/CoreServices/PlatformSupport.plist.inactive" \
       "$VOLUME/System/Library/CoreServices/PlatformSupport.plist"
else
    echo 'Boot-time compatibility check not present; continuing.'
fi

echo

# Undo the com.apple.Boot.plist patch, if present
echo 'Checking for com.apple.Boot.plist patch (v0.0.3+).'
if [ -e "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist.original" ]
then
    echo 'Removing com.apple.Boot.plist patch.'
    mv -f "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist.original" "$VOLUME/Library/Preferences/SystemConfiguration/com.apple.Boot.plist"
else
    echo 'com.apple.Boot.plist patch not present; continuing.'
fi

echo
echo 'Removing shell scripts and patcher version info.'
# Delete the shell scripts and patcher version info.
rm "$VOLUME"/*.sh "$VOLUME/Patch-Version.txt"

echo
echo 'Unpatcher finished.'
echo 'Remember to manually delete Hax2.app or any Hax dylibs from your'
echo 'USB stick, if you are not immediately repatching.'