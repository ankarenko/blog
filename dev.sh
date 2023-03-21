docker run --rm \
  -v="$PWD:/srv/jekyll" \
  -p 4000:4000 \
  jekyll/jekyll:3.8 \
  jekyll \
  serve \
  --config _config.yml,_config_development.yml

