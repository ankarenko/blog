OUTPUT_PATH=${PWD}/assets/images
INPUT_PATH=./test/*
IMAGE_DIRECTORY=${PWD}/assets/images
OUTPUT_WS=(1100 800 700)
SIZES=("lg" "md" "sm")

function is_processed () {
  if [ -f "$1" ]; then
    return
  fi

  false
}

function compress () {
  max_allowed=1000000
  filesize=$(stat --format=%s "$1")

  if [ $filesize -ge $max_allowed ]; then
    echo "Compressing $filename..."
    convert \
      $1 \
      -interlace Plane \
      -gaussian-blur 0.05 \
      -quality 85% \
      $2
  else 
    cp $i $2
  fi
}

function make_resized () {
  for k in "${!OUTPUT_WS[@]}"; do 
    w=${OUTPUT_WS[$k]}
    s=${SIZES[$k]}

    mkdir -p $OUTPUT_PATH/resized/$image_folder/$s
    out_file=$OUTPUT_PATH/resized/$image_folder/$s/$2
    
    convert \
    $1 \
    -thumbnail $w \
    -filter Triangle \
    -define filter:support=2 \
    -unsharp 0.25x0.25+8+0.065 \
    -dither None \
    -posterize 136 \
    -quality 82 \
    -interlace none \
    -colorspace sRGB \
    $out_file
  done
}

function make_webp () {
  convert -format webP $1 $2
}

for d in  $IMAGE_DIRECTORY/*; do
  if [[ "$d" != *"20"* ]]; then
    continue
  fi

  [ -L "${d%/}" ] && continue
  image_folder=$(basename $d)

  echo "Processing $d..."

  mkdir -p $OUTPUT_PATH/resized/$image_folder/default
  
  for i in $(find "$d" -name '*.jpg'); do 
    filename=$(basename $i .jpg)
    default_file=$OUTPUT_PATH/resized/$image_folder/default/$filename
    
    if is_processed $default_file.jpg; then
      continue
    fi

    echo "Processing $filename"

    compress $i $default_file.jpg && \
    make_webp $default_file.jpg $default_file.webP && \
    make_resized $default_file.jpg $filename.jpg && \
    make_resized $default_file.webP $filename.webP 
  done
  
done
