#!/bin/bash

echo "          "
echo "Specify path to where the vendor img is located"
read -p "PATH: " vendor_img_path
echo ""

if [ ! -e "$vendor_img_path/vendor.img" ]; then
    echo -e "${BOLD_RED}[Error 1] vendor.img not found at specified path!${RESET}"
    sleep 1
    exit 0
fi

sudo umount ./Projects/$PROJECT/Build/vendor/ > /dev/null 2>&1
rm -rf ./Projects/$PROJECT/Output/vendor.img
mkdir -p ./Projects/$PROJECT/Build/vendor/

echo "vendor.img located!"
echo "Copying to Lunar Kitchen..."
cp -f $vendor_img_path/vendor.img ./Projects/$PROJECT/Input/

INPUT_IMG=./Projects/$PROJECT/Input/vendor.img
OUTPUT_IMG=./Projects/$PROJECT/Output/vendor.img
BUILD_DIR=./Projects/$PROJECT/Build/vendor/

if file "$INPUT_IMG" | grep -q "Android sparse image"; then
    echo "Android sparse image detected! Converting to raw image..."
    echo ""
    simg2img "$INPUT_IMG" "$OUTPUT_IMG"
else
    echo "Raw image detected! Moving to Lunar Kitchen..."
    mv "$INPUT_IMG" "$OUTPUT_IMG"
fi

# file(1) has no EROFS support on older releases, so read the superblock magic
if [ "$(od -A n -j 1024 -N 4 -t x1 "$OUTPUT_IMG" | tr -d ' ')" = "e2e1f5e0" ]; then
    FS_TYPE=erofs
    MOUNT_OPTS=ro,loop
else
    FS_TYPE=ext4
    MOUNT_OPTS=loop
fi

echo "Extracting filesystem..."
if sudo mount -t $FS_TYPE -o $MOUNT_OPTS "$OUTPUT_IMG" "$BUILD_DIR"; then
    if [ "$FS_TYPE" = "erofs" ]; then
        echo "Done. EROFS is mounted read-only, so the vendor filesystem can be read
        but not modified."
    else
        echo "Done, any changed made to the vendor filesystem will be reflected in the vendor.img file,
        located at ./Projects/$PROJECT/Output/vendor.img"
    fi
else
    echo -e "${BOLD_RED}[Error 1] Failed to mount vendor.img ($FS_TYPE)!${RESET}"
    echo -e "Check that you are allowed to run sudo mount, and that the image is not corrupted."
fi

sleep 1.5
