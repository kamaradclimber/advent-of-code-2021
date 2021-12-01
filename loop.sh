#!/usr/bin/bash

while inotifywait -e close_write days/*; do rspec -fd --fail-fast; done
