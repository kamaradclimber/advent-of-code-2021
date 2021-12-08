#!/usr/bin/bash

while inotifywait -e close_write days/* inputs/* spec/*; do bundle exec rspec -fd --fail-fast; done
