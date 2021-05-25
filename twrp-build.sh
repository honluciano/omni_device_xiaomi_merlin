#!bin/bash

# Go to the working directory
mkdir ~/TWRP-10 && cd ~/TWRP-10

# Configure git
git config --global user.email "pajhonludev@gmail.com"
git config --global user.name "jhonludev"
git config --global color.ui false

# Sync the source
repo init --depth=1 -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-10.0
repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)

# Clone device tree and common tree
git clone --depth=1 https://github.com/Jebaitedneko/omni_device_xiaomi_merlin.git -b android-10 device/xiaomi/merlin
git clone https://github.com/SparXFusion/android_kernel_redmi_mt6768.git -b lancelot-q-oss   kernel/xiaomi/merlin 

# Build recovery image
export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch omni_merlin-eng; make -j$(nproc --all) recoveryimage
# Rename and copy the files
twrp_version=$(cat ~/TWRP-10/bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d '"' -f2)
date_time=$(date +"%d%m%Y%H%M")
mkdir ~/final
cp out/target/product/guamp/recovery.img ~/final/twrp-$twrp_version-merlin-"$date_time"-unofficial.img
# Upload to oshi.at
curl -T ~/final/*.img transfer.sh
