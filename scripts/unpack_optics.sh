#!/bin/bash

source "$(dirname "$0")/lib_img.sh"

echo "          "
echo "Specify the path to optics.img, or the folder containing it"
read -p "PATH: " optics_img_path
echo ""

if resolve_img_src "$optics_img_path" optics.img; then

    sudo umount ./Projects/$PROJECT/Build/optics/ > /dev/null 2>&1
    rm -rf ./Projects/$PROJECT/Output/optics.img

    mkdir -p ./Projects/$PROJECT/Build/optics/

    echo "optics.img located!"
    echo "Copying to Lunar Kitchen..."
    cp -f "$IMG_SRC" ./Projects/$PROJECT/Input/optics.img

    FILE_TYPE=$(file ./Projects/$PROJECT/Input/optics.img)

    # Check if the file is sparse
    if echo "$FILE_TYPE" | grep -q "Android sparse image"; then

        echo "Android sparse image detected! Converting to raw image..."
        echo ""

        simg2img ./Projects/$PROJECT/Input/optics.img ./Projects/$PROJECT/Output/optics.img

        echo "Extracting filesystem..."
        sudo mount -t ext4 -o loop ./Projects/$PROJECT/Output/optics.img ./Projects/$PROJECT/Build/optics/

        echo "Done, any changed made to the optics filesystem will be reflected in the optics.img file,
        located at ./Projects/$PROJECT/Output/optics.img"
        sleep 1.5

    else
        echo "Raw image detected! Moving to Lunar Kitchen..."
        mv ./Projects/$PROJECT/Input/optics.img ./Projects/$PROJECT/Output/optics.img
        
        echo "Extracting filesystem..."
        sudo mount -t ext4 -o loop ./Projects/$PROJECT/Output/optics.img ./Projects/$PROJECT/Build/optics/

        echo "Done, any changed made to the optics filesystem will be reflected in the optics.img file,
        located at ./Projects/$PROJECT/Output/optics.img"
        sleep 1.5

    fi
else
    echo -e "${BOLD_RED}[Error 1] optics.img not found at specified path!${RESET}"
    sleep 1
fi