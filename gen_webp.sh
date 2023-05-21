
IMAGE_DIRECTORY=${PWD}/assets/images

for d in  $IMAGE_DIRECTORY/*; do
  [ -L "${d%/}" ] && continue

  if [ $1 = "clean" ]; then
    rm -rf $d/*.webP -f
  fi

  for i in $(find "$IMAGE_DIRECTORY" -not -path "$IMAGE_DIRECTORY/resized/*" -name '*.jpg'); do 
    filename=$(basename $i .jpg)
    path=${i%.*}

    [ ! -f $path.webP ] && convert -format webP $path.jpg $path.webP
  done

  #$(cd $d && mogrify -format webP -path ./ *.jpg)
done
  
