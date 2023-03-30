OUTPUT_PATH=${PWD}/assets/images
INPUT_PATH=./test/*
IMAGE_DIRECTORY=${PWD}/assets/images
OUTPUT_WS="800"

rm -rf $IMAGE_DIRECTORY/resized
rm -rf $IMAGE_DIRECTORY/webp

#magick mogrify -format webP -path ~/Pictures/WebP/ *.png

for d in  $IMAGE_DIRECTORY/*; do
  [ -L "${d%/}" ] && continue
  image_folder=$(basename $d)

  echo "Processing $d..."
  for w in $OUTPUT_WS; do
    out_path=$OUTPUT_PATH/resized/$image_folder/$w
    mkdir $out_path -p

    echo "Generating $w..." && \
    mogrify \
    -path $out_path \
    -thumbnail $w \
    -interlace Plane -gaussian-blur 0.05 -quality 85% \
    -strip $d/*
  done

done
