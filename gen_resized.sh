

OUTPUT_WS=(1100 800 700)
SIZES=("lg" "md" "sm")

i=$1
default_file=$2
filename=$3

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

compress $i $default_file.jpg && \
make_webp $default_file.jpg $default_file.webP && \
make_resized $default_file.jpg $filename.jpg && \
make_resized $default_file.webP $filename.webP 