#!/usr/bin/bash

day=$1

if [[ "$day" != "" ]]; then
  filter="-e day$day"
fi

# while inotifywait -e close_write days/* inputs/* spec/*; do bundle exec rspec -fd --fail-fast; done
while inotifywait days/* inputs/* spec/*; do bundle exec rspec -fd --fail-fast $filter; done
