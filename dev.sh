sh ./build_images.sh && \
docker image build -t jekyll_local . && \
docker run --rm \
  -v="$PWD:/srv/jekyll" \
  -p 4000:4000 \
  --volume jekyll_gems:/usr/local/bundle \
  jekyll_local \
  jekyll \
  serve \
  --config _config.yml,_config_development.yml \
  --drafts

