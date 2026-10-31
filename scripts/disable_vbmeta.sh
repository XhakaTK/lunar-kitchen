#!/bin/bash

# Tool to make a vbmeta disabled image

source "$(dirname "$0")/lib_img.sh"

echo ""
echo "Specify the path to vbmeta.img, or the folder containing it"
echo ""

read -p "PATH: " image

if resolve_img_src "$image" vbmeta.img; then
    echo ""
    echo "vbmeta.img found, disabling it..."
    echo ""

    # Logic to it
    cp "$IMG_SRC" ./Projects/$PROJECT/Output/vbmeta.img

    case "$(uname -m)" in
        x86_64) TOOL=./tools/vbmeta/x86_64/vbmeta-disable-verification ;;
        *)      TOOL=./tools/vbmeta/arm64-v8a/vbmeta-disable-verification ;;
    esac

    if "$TOOL" ./Projects/$PROJECT/Output/vbmeta.img; then
        echo ""
        echo "Check Projects/$PROJECT/Output for the disabled vbmeta.img file."
        sleep 1
        echo "Done!"
        echo ""
        echo ""
    else
        rm -f ./Projects/$PROJECT/Output/vbmeta.img
        echo ""
        echo -e "${BOLD_RED}[Error 2] vbmeta-disable-verification failed!${RESET}"
        echo -e "The image is unmodified, so the copy in Output has been removed."
    fi
else
    echo ""
    echo -e "${BOLD_RED}[Error 1] vbmeta.img not found!"
    echo -e "Give the path to vbmeta.img or to the folder containing it.${RESET}"
    echo ""
fi