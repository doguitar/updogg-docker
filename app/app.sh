#!/bin/bash
echo "startup successful"
# Sleep forever to keep the container alive
while true; do clear; nvidia-smi; sleep 1; done