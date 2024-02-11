#!/bin/sh

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable

HOME_PATH="$(pwd)"

OUTPUT_DIR="builds"
OUTPUT_PATH="${HOME_PATH}/${OUTPUT_DIR}"
OUTPUT_NAME="openwrt-rpi-4.img.gz"

BUILDER_LOCATION="https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2711"
BUILDER_NAME="openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz"
BUILDER_URL="${BUILDER_LOCATION}/${BUILDER_NAME}"
BUILDER_DIR="builder"
BUILDER_PATH="${HOME_PATH}/${BUILDER_DIR}"

BUILD_PATH="${BUILDER_PATH}/bin/targets/bcm27xx/bcm2711/openwrt-bcm27xx-bcm2711-rpi-4-ext4-factory.img.gz"

INCLUDE_PACKAGES="python3"
EXCLUDE_PACKAGES="-e2fsprogs -mkf2fs -partx-utils"

## Output formatting
COLOR_RESET="\e[0m"
COLOR_RED="\e[91m"
COLOR_BLUE="\e[34m"
COLOR_GREEN="\e[32m"

error() {
    printf "${COLOR_RED}ERR: %s${COLOR_RESET}\\n" "${*}" 1>&2
    exit 1
}

info() {
    printf "${COLOR_BLUE}INFO: %s${COLOR_RESET}\\n" "${*}"
}

success() {
    printf "${COLOR_GREEN}OK: %s${COLOR_RESET}\\n" "${*}"
}

###################

info "Checking builder directory."
rm -rf "${BUILDER_PATH}" || error "Cannot delete existing builder directory."
mkdir "${BUILDER_PATH}" || error "Cannot create builder directory."
cd "${BUILDER_PATH}" || error "Cannot open builder directory."
success "Created ${BUILDER_PATH}"

info "Downloading image builder: ${BUILDER_URL}"
curl -O "${BUILDER_URL}" || error "Downloading failed. Check the Internet conenction."
success "Downloaded $(file ${BUILDER_NAME})"

info "Extracting image builder."
tar --strip-components=1 --extract --file "${BUILDER_NAME}" || error "Extracting failed."
ls -lah
success "Image builder content extracted."

info "Updating feed packages."
echo 'src-git packages https://git.openwrt.org/feed/packages.git' | tee feeds.conf

OS_NAME="$(uname)"
OS_ARC="$(uname -m)"
OS_FULL="${OS_NAME}-${OS_ARC}"
OS_REQUIRED="Linux-x86_64"
if [ "${OS_FULL}" = "${OS_REQUIRED}" ]; then
   success "Running on ${OS_FULL}"
else 
   error "Feeds update script requires ${OS_REQUIRED}. Current OS: ${OS_FULL}"
fi

./scripts/feeds update
success "Feeds update script finished."

info "Building image."
make image PROFILE=rpi-4 PACKAGES="${INCLUDE_PACKAGES} ${EXCLUDE_PACKAGES}" || error "Build failed."
success "Created $(file "${BUILD_PATH}")"

info "Moving created image to the output folder"
cp "${BUILD_PATH}" "${OUTPUT_PATH}/${OUTPUT_NAME}" || error "Cannot copy the image file."
ls -lah "${OUTPUT_PATH}"
success "The image is ready: ${OUTPUT_PATH}/${OUTPUT_NAME}"

exit 0
