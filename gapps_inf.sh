#!/usr/bin/env bash
set -e

# Syncing Repo
rm -rf .repo/local_manifests
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 17 -g default,-mips,-darwin,-notdefault
if [ -f /opt/crave/resync.sh ]; then
    /opt/crave/resync.sh
else
    repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
fi

# Cloning Android 17 Repos
git clone --depth 1  https://github.com/DevAyu-Codes/android_device_xiaomi_sunny -b seventeen device/xiaomi/sunny
git clone --depth 1  https://github.com/DevAyu-Codes/android_device_xiaomi_sunny-kernel -b seventeen device/xiaomi/sunny-kernel
git clone --depth 1  https://gitlab.com/NoPrincessHere/proprietary_vendor_xiaomi_sunny -b seventeen vendor/xiaomi/sunny
git clone --depth 1  https://github.com/PixelOS-AOSP/android_hardware_xiaomi -b seventeen hardware/xiaomi
git clone --depth 1  https://github.com/KProfiles/android_packages_apps_KProfiles packages/apps/KProfiles
git clone --depth 1  https://github.com/cyberknight777/android_packages_apps_DisplayFeatures packages/apps/DisplayFeatures

# Adding Keys
mkdir -p vendor/infinity-priv/keys
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1R2M24lHjLXC-cOLuCv_uHe2asbUkH2IA' -O vendor/infinity-priv/keys/keys.zip && unzip vendor/infinity-priv/keys/keys.zip -d vendor/infinity-priv/keys/
rm vendor/infinity-priv/keys/keys.zip
mv vendor/infinity-priv/keys/keys-InfinityX/* vendor/infinity-priv/keys/
rm -rf vendor/infinity-priv/keys/keys-InfinityX

# Custom Updater For GApps
rm -rf packages/apps/Updater
git clone --depth 1  https://github.com/DevAyu-Codes/packages_apps_Updater -b 17 packages/apps/Updater

# Start GApps Build
. build/envsetup.sh
lunch infinity_sunny-user
m bacon -j$(nproc --all)

# Upload Rom
ROM_ZIP=$(find out/target/product/sunny -maxdepth 1 -name "*.zip" ! -name "*ota*" ! -name "*target_files*" 2>/dev/null | head -n 1)
[ -z "$ROM_ZIP" ] && ROM_ZIP=$(ls out/target/product/cancunf/*.zip 2>/dev/null | head -n 1)

echo "========================================================"
echo "Uploading artifact to temp.sh..."
TEMP_URL=$(curl --fail --silent --show-error --max-time 1800 \
    -F "file=@${ROM_ZIP}" https://temp.sh/upload 2>&1) || {
    echo "ERROR: temp.sh upload failed"
    echo "$TEMP_URL"
    exit 1
}
echo "$TEMP_URL"
echo "$TEMP_URL" > "${ROM_ZIP}.temp.sh.url"
echo "========================================================"
echo "=== InfinityX GApps Build Finished Successfully! ==="

