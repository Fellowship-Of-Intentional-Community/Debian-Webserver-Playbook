#!/bin/bash
IMAGE_FILES="/var/www/html/wp-content/"
CACHE_FILE="$HOME/.optimized-image-cache.sh"

# Load the Cache File or Create a New Array
if [ -f "$CACHE_FILE" ]; then
    source -- "$CACHE_FILE"
else
    declare -A OPTIMIZED_IMAGES
fi


# Add $1 to the Cache Array
function addToCache {
    OPTIMIZED_IMAGES[$1]=1
}

# Check the cache for existence of $1
function notInCache {
    if [ ${OPTIMIZED_IMAGES[$1]} ]; then
        return
    else
        echo 1
    fi
}

# Optimize PNGs
function optimizePNG {
    NOT_IN_CACHE=$(notInCache "$1")
    if [[ $NOT_IN_CACHE ]]; then
        addToCache "$1"
        optipng -quiet -o7 "$1" > /dev/null
    fi
}

# Optimize JPGs
function optimizeJPG {
    NOT_IN_CACHE=$(notInCache "$1")
    if [[ $NOT_IN_CACHE ]]; then
        addToCache "$1"
        jpegtran -copy none -progressive -optimize -outfile "$1" "$1" > /dev/null 2&>1
    fi
}


# Optimize the Images
while read file; do
    optimizePNG "$file"
done < <(find "$IMAGE_FILES" -type f -iname "*.png")
while read file; do
    optimizeJPG "$file"
done < <(find "$IMAGE_FILES" -type f -iname "*.jpg" -o -iname "*.jpeg")


# Save the Cache File
declare -p OPTIMIZED_IMAGES > $CACHE_FILE
