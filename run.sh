#!/bin/bash

if [ ! -z "$1" ] && [ "$1" = "server" ]; then
  bundle exec rails s -p 3000 -b '0.0.0.0'
fi