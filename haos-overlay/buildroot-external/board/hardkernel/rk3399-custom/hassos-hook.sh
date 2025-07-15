#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    # cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}"/*.dtb "${BOOT_DATA}/"

    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/haos-config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"
    cp ${BOARD_DIR}/rkbin/idbloader.img ${BINARIES_DIR}/
    cp ${BOARD_DIR}/rkbin/trust.img ${BINARIES_DIR}/
    mkimage -C none -A arm -T script -d ${BOARD_DIR}/uboot-boot.ush ${BOOT_DATA}/boot.scr  
    ${BOARD_DIR}/rkbin/loaderimage --pack --uboot ${BINARIES_DIR}/u-boot.bin ${BINARIES_DIR}/u-boot.img 0x200000
}


function hassos_post_image() {
    convert_disk_image_xz
}

