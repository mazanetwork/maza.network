#!/bin/sh

owner=$(ls -n Gemfile.lock | awk '{print $3":"$4}') 
docker run -it --rm \
  -v $(pwd):/srv/jekyll \
  jekyll/builder chown -R 1000:1000 /srv/jekyll

docker run -it --rm -v $(pwd):/srv/jekyll jekyll/builder bundle update
docker run -it --rm -v $(pwd):/srv/jekyll jekyll/builder jekyll build $@

sudo chown -R $owner .
