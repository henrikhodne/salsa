#!/bin/bash
set -e

# Get the parent directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# Change into that dir because we expect that
cd $DIR

# Determine the version that we're building based on the contents
# of vers.go.
VERSION=$(grep "const version " vers.go | sed -E 's/.*"(.+)"$/\1/')

echo "Version: ${VERSION}"

# Determine the arch/os combos we're building for
XC_ARCH=${XC_ARCH:-"386 amd64 arm"}
XC_OS=${XC_OS:-linux darwin windows freebsd openbsd}

echo "Arch: ${XC_ARCH}"
echo "OS: ${XC_OS}"

# This function builds whatever directory we're in...
xc() {
  goxc \
    -arch="$XC_ARCH" \
    -os="$XC_OS" \
    -d="${DIR}/pkg" \
    -pv="${VERSION}" \
    $XC_OPTS \
    go-install \
    xc
}

# This function wais for all background tasks to complete
waitAll() {
  RESULT=0
  for job in `jobs -p`; do
    wait $job
    if [ $? -ne 0 ]; then
      RESULT=1
    fi
  done

  if [ $RESULT -ne 0 ]; then
    exit $RESULT
  fi
}

# Make sure that if we're killed, we kill all our subprocesses
trap "kill 0" SIGINT SIGTERM EXIT

# Build our root project
xc

# Zip all the packages
mkdir -p ./pkg/${VERSION}/dist
for PLATFORM in $(find ./pkg/${VERSION} -mindepth 1 -maxdepth 1 -type d); do
  PLATFORM_NAME=$(basename ${PLATFORM})
  ARCHIVE_NAME="${VERSION}_${PLATFORM_NAME}"

  if [ $PLATFORM_NAME = "dist" ]; then
    continue
  fi

  (
  pushd ${PLATFORM}
  zip ${DIR}/pkg/${VERSION}/dist/${ARCHIVE_NAME}.zip ./*
  popd
  ) &
done

waitAll

# Make the checksums
pushd ./pkg/${VERSION}/dist
shasum -a256 * > ./${VERSION}_SHA256SUMS
popd

exit 0
