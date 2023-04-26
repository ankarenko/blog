OUTPUT_PATH=${PWD}/assets/images
IMAGE_DIRECTORY=${PWD}/assets/images

function is_processed () {
  if [ -f "$1" ]; then
    return
  fi

  false
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
    source $PWD/gen_resized.sh $i $default_file $filename
  done
done
