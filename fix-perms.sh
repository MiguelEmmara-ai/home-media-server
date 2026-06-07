#!/bin/bash
# Runs in background, fixes permissions on new download folders every 5 seconds
while true; do
  find ~/media-server-data/downloads/intermediate -type d ! -perm 777 -exec chmod 777 {} \; 2>/dev/null
  sleep 5
done
