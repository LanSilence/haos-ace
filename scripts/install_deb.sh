#!/bin/bash
mkdir -p cache
if [ ! -f cache/assismgr.deb ];then
ASSISMGER_LATEST_VERSION=$(curl -s https://api.github.com/repos/LanSilence/assismgr/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
wget -O cache/assismgr.deb https://github.com/LanSilence/assismgr/releases/download/${ASSISMGER_LATEST_VERSION}/assismgr_${ASSISMGER_LATEST_VERSION}_arm64.deb
fi

dpkg -x cache/assismgr.deb haos-overlay/buildroot-external/rootfs-overlay/