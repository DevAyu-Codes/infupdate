# Sync Rom
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 17 -g default,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# Setting GitHub Config
git config --global user.email "ayushkumar274549@gmail.com"
git config --global user.name "DevAyu-Codes"

# Syncing Repo
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 17 -g default,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# Cloning Android 17 Repos
git clone https://github.com/DevAyu-Codes/android_device_xiaomi_sunny -b seventeen device/xiaomi/sunny
git clone https://github.com/DevAyu-Codes/android_device_xiaomi_sunny-kernel -b seventeen device/xiaomi/sunny-kernel
git clone https://gitlab.com/NoPrincessHere/proprietary_vendor_xiaomi_sunny -b seventeen vendor/xiaomi/sunny
git clone https://github.com/PixelOS-AOSP/android_hardware_xiaomi -b seventeen hardware/xiaomi
git clone https://github.com/KProfiles/android_packages_apps_KProfiles packages/apps/KProfiles
git clone https://github.com/cyberknight777/android_packages_apps_DisplayFeatures packages/apps/DisplayFeatures

# Adding Keys
mkdir -p vendor/infinity-priv/keys
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1R2M24lHjLXC-cOLuCv_uHe2asbUkH2IA' -O vendor/infinity-priv/keys/keys.zip && unzip vendor/infinity-priv/keys/keys.zip -d vendor/infinity-priv/keys/
rm vendor/infinity-priv/keys/keys.zip
mv vendor/infinity-priv/keys/keys-InfinityX/* vendor/infinity-priv/keys/
rm -rf vendor/infinity-priv/keys/keys-InfinityX

# Fixing Update Path
rm -rf system/memory/libmeminfo
git clone https://github.com/PixelOS-AOSP/android_system_memory_libmeminfo -b seventeen system/memory/libmeminfo

# Custom Updater For GApps
rm -rf packages/apps/Updater
git clone https://github.com/DevAyu-Codes/packages_apps_Updater -b 17 packages/apps/Updater

# Start GApps Build
. build/envsetup.sh
lunch infinity_sunny-user
m bacon -j$(nproc --all)
