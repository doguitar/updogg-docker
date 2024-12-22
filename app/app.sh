#!/bin/bash
echo "startup successful"
# Sleep forever to keep the container alive
while true; do pip show torch; sleep 1000; done