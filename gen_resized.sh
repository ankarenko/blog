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

  mkdir -p $OUTPUT_PATH/resized/$image_folder/default

  for i in $(find "$d" -name '*.jpg' -o -name '*.webP'); do 
    filesize=$(stat --format=%s "$i")
    max_allowed=1000000
    out_file=$OUTPUT_PATH/resized/$image_folder/default/$(basename $i)

    if [ $filesize -ge $max_allowed ]; then
      echo "Compressing $(basename $i)..."
      convert \
        -strip \
        -interlace Plane \
        -gaussian-blur 0.05 \
        -quality 85% \
        $i \
        $out_file
    else 
      cp $i $out_file
    fi
  done

  for i in "${!OUTPUT_WS[@]}"; do 
    w=${OUTPUT_WS[$i]}
    s=${SIZES[$i]}  
    out_path=$OUTPUT_PATH/resized/$image_folder/$s
    mkdir $out_path -p

    echo "$out_path"

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
