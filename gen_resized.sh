OUTPUT_PATH=${PWD}/assets/images
INPUT_PATH=./test/*
IMAGE_DIRECTORY=${PWD}/assets/images
OUTPUT_WS=(1100 800 700)
SIZES=("lg" "md" "sm")

rm -rf $IMAGE_DIRECTORY/resized
rm -rf $IMAGE_DIRECTORY/webp

#magick mogrify -format webP -path ~/Pictures/WebP/ *.png

for d in  $IMAGE_DIRECTORY/*; do
  [ -L "${d%/}" ] && continue
  image_folder=$(basename $d)

  echo "Processing $d..."

  for i in "${!OUTPUT_WS[@]}"; do 
    w=${OUTPUT_WS[$i]}
    s=${SIZES[$i]}  
    out_path=$OUTPUT_PATH/resized/$image_folder/$s
    mkdir $out_path -p

    echo $OUTPUT_PATH[$i]

    echo "Generating $s..." && \
    mogrify \
    -path $out_path \
    -thumbnail $w \
    -filter Triangle \
    -define filter:support=2 \
    -unsharp 0.25x0.25+8+0.065 \
    -dither None \
    -posterize 136 \
    -quality 82 \
    -interlace none \
    -colorspace sRGB \
    -strip $d/*
  done

done
