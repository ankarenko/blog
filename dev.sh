docker run --rm -it \
  -v="$PWD:/srv/jekyll" \
  -p 4000:4000 \
  --volume jekyll_gems:/usr/local/bundle \
  jekyll/jekyll:3.8 \
  bash

