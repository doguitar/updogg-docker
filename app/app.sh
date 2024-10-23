#!/bin/bash
echo "runing as $(id -u):$(id -g)"
echo "startup successful"
# Sleep forever to keep the container alive
while true; do sleep 1000; done