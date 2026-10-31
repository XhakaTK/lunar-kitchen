#!/bin/bash
# Script to un/repack a boot.img file

source "$(dirname "$0")/lib_img.sh"

echo ""
echo "Specify the path to boot.img, or the folder containing it"
read -p "PATH: " boot_img_path
echo ""

if resolve_img_src "$boot_img_path" boot.img; then

    if [ -e ./Projects/$PROJECT/Build/boot/ ]; then
        sudo rm -rf ./Projects/$PROJECT/Build/boot/
    fi

	echo "Copying to Lunar Kitchen..."

    mkdir -p ./Projects/$PROJECT/Build/boot/
    cp -f ./tools/AIK-Linux/* -r ./Projects/$PROJECT/Build/boot/
    cp -f "$IMG_SRC" ./Projects/$PROJECT/Build/boot/boot.img
    ./Projects/$PROJECT/Build/boot/unpackimg.sh ./Projects/$PROJECT/Build/boot/boot.img

	echo ""
    echo "Make any changes you want at: Projects/$PROJECT/Build/boot/"
	echo "Then run the repack option to rebuild image"
    sleep 1.5

else

    echo -e "${BOLD_RED}[Error 1] Incorrect path specified!"
    echo -e "Give the path to boot.img or to the folder containing it.${RESET}"
    sleep 2
    exit 0

fi

sleep 1