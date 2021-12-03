#!/usr/bin/bash

while inotifywait -e close_write days/* inputs/* spec/*; do rspec -fd --fail-fast; done
