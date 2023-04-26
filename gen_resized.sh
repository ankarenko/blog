OUTPUT_PATH=${PWD}/assets/images
INPUT_PATH=./test/*
IMAGE_DIRECTORY=${PWD}/assets/images
OUTPUT_WS=(1100 800 700)
SIZES=("lg" "md" "sm")

for d in  $IMAGE_DIRECTORY/2023-03-05-pico-de-orizaba; do
  if [[ "$d" != *"20"* ]]; then
    continue
  fi

  [ -L "${d%/}" ] && continue
  image_folder=$(basename $d)

  echo "Processing $d..."

  mkdir -p $OUTPUT_PATH/resized/$image_folder/default
  
  for i in $(find "$d" -name '*.jpg' -o -name '*.webP'); do 
    filesize=$(stat --format=%s "$i")
    max_allowed=1000000
    filename=$(basename $i)
    default_file=$OUTPUT_PATH/resized/$image_folder/default/$filename
    
    if [ -f "$default_file" ]; then
      continue
    fi

    echo "Processing $filename"

    if [ $filesize -ge $max_allowed ]; then
      echo "Compressing $filename..."
      convert \
        $i \
        -interlace Plane \
        -gaussian-blur 0.05 \
        -quality 85% \
        $default_file
    else 
      cp $i $default_file
    fi

    for k in "${!OUTPUT_WS[@]}"; do 
      w=${OUTPUT_WS[$k]}
      s=${SIZES[$k]}

      mkdir -p $OUTPUT_PATH/resized/$image_folder/$s
      out_file=$OUTPUT_PATH/resized/$image_folder/$s/$filename
      
      convert \
      $default_file \
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
  done
  
done
