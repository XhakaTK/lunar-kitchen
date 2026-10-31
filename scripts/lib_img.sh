#!/bin/bash
# Resolves a PATH prompt to an image file: accepts the image itself, or the folder holding it,
# with a leading '~' expanded since read does not do that itself.
# Sets IMG_SRC to the resolved path; returns 1 when neither form exists.

resolve_img_src() {
    local input="$1" name="$2"
    case "$input" in
        "~" | "~/"*) input="$HOME${input#\~}" ;;
    esac

    IMG_SRC=""
    if [ -f "$input" ]; then
        IMG_SRC="$input"
    elif [ -f "${input%/}/$name" ]; then
        IMG_SRC="${input%/}/$name"
    fi

    [ -n "$IMG_SRC" ]
}
