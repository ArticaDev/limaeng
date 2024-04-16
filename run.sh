#!/bin/bash

if [ ! -z "$1" ] && [ "$1" = "server" ]; then
<<<<<<< HEAD
  rm -f tmp/pids/server.pid
  bundle exec rails s -p 3000 -b '0.0.0.0'
=======
  rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'
>>>>>>> 464dc9da93501dcbe7ccb26fd2b88f14d150c5b1
fi