OUTPUT_PATH=${PWD}/assets/images
INPUT_PATH=./test/*
IMAGE_DIRECTORY=${PWD}/assets/images
OUTPUT_WS="800 480 320"

mkdir -p resized

for d in  $IMAGE_DIRECTORY/*; do
  [ -L "${d%/}" ] && continue

  image_folder=$(basename $d)

  echo "Processing $d..."
  for w in $OUTPUT_WS; do
    out_path=$OUTPUT_PATH/$image_folder/resized/$w
    mkdir $out_path -p

    echo "Generating $w..." && \
    mogrify \
    -path $out_path \
    -filter Triangle \
    -define filter:support=2 \
    -thumbnail $w \
    -unsharp 0.25x0.25+8+0.065 \
    -dither None \
    -posterize 136 \
    -quality 82 \
    -define jpeg:fancy-upsampling=off \
    -define png:compression-filter=5 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -define png:exclude-chunk=all \
    -interlace none \
    -colorspace sRGB \
    -strip $d/*
  done

done
