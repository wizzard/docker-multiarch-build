#!/bin/bash
set -euo pipefail

# replace with your dockerhub username and image name, e.g. john/test-multiarch
NAME=xxx/yyy


BUILD_NAME=test-multiarch-build

# Adjust the platforms to your needs
BUILDX_PLATFORMS=("linux/amd64" "linux/arm" "linux/arm64")
platforms="linux/amd64,linux/arm,linux/arm64"

# Compile the binary for each platform
for platform in "${BUILDX_PLATFORMS[@]}"; do
    docker build \
            --platform "$platform" \
            --force-rm \
            --no-cache \
            --quiet \
            -t "$BUILD_NAME" \
            -f Dockerfile.build .
    docker run \
            --platform "$platform" \
            --rm \
            --quiet \
            -v "$(pwd)"/:/tmp/build \
            -it --name "$BUILD_NAME" "$BUILD_NAME"
    docker image rm "$BUILD_NAME" >/dev/null 2>&1
done

# Build the final multiarch image
docker buildx build \
        --platform "$platforms" \
        --force-rm \
        --no-cache \
        --quiet \
        --push \
        -t "$NAME" \
        -f Dockerfile .

echo "Done"

# remove temporary files
for platform in "${BUILDX_PLATFORMS[@]}"; do
    arch=$(echo "$platform" | cut -d'/' -f2)
    rm -f cpu_arch."$arch"
done

echo "Running containers:"
# Test: Run each container
for platform in "${BUILDX_PLATFORMS[@]}"; do
    docker run \
        --rm \
        --platform "$platform" \
        --quiet \
        -v "$(pwd)"/:/tmp/build \
        -it "$NAME"

    docker image rm "$NAME" >/dev/null 2>&1
done
