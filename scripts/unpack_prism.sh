#!/bin/bash

source "$(dirname "$0")/lib_img.sh"

echo "          "
echo "Specify the path to prism.img, or the folder containing it"
read -p "PATH: " prism_img_path
echo ""

if resolve_img_src "$prism_img_path" prism.img; then

    sudo umount ./Projects/$PROJECT/Build/prism/ > /dev/null 2>&1
    rm -rf ./Projects/$PROJECT/Output/prism.img

    mkdir -p ./Projects/$PROJECT/Build/prism/

    echo "prism.img located!"
    echo "Copying to Lunar Kitchen..."
    cp -f "$IMG_SRC" ./Projects/$PROJECT/Input/prism.img

    FILE_TYPE=$(file ./Projects/$PROJECT/Input/prism.img)

    # Check if the file is sparse
    if echo "$FILE_TYPE" | grep -q "Android sparse image"; then

        echo "Android sparse image detected! Converting to raw image..."
        echo ""

        simg2img ./Projects/$PROJECT/Input/prism.img ./Projects/$PROJECT/Output/prism.img

        echo "Extracting filesystem..."
        sudo mount -t ext4 -o loop ./Projects/$PROJECT/Output/prism.img ./Projects/$PROJECT/Build/prism/

        echo "Done, any changed made to the prism filesystem will be reflected in the prism.img file,
        located at ./Projects/$PROJECT/Output/prism.img"
        sleep 1.5

    else
        echo "Raw image detected! Moving to Lunar Kitchen..."
        mv ./Projects/$PROJECT/Input/prism.img ./Projects/$PROJECT/Output/prism.img
        
        echo "Extracting filesystem..."
        sudo mount -t ext4 -o loop ./Projects/$PROJECT/Output/prism.img ./Projects/$PROJECT/Build/prism/

        echo "Done, any changed made to the prism filesystem will be reflected in the prism.img file,
        located at ./Projects/$PROJECT/Output/prism.img"
        sleep 1.5

    fi

else
    echo -e "${BOLD_RED}[Error 1] prism.img not found at specified path!${RESET}"
    sleep 1

fi