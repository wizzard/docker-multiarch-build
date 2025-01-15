#!/bin/sh

echo "Building for $TARGETARCH"

gcc -o /tmp/build/cpu_arch."$TARGETARCH" /tmp/build/main.c