#!/bin/bash

echo -e "\033[34;43m编译本工程，系统必须支持docker\033[0m"
echo -e "\033[34;43mBuilding this project, the system must support Docker\033[0m"


DEFAULT_TARGET="k2b_h618 rk3399_custom"

TARGET="${1:-$DEFAULT_TARGET}" 

if sudo docker ps &> /dev/null; then
    echo "Docker is running."
else
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

./scripts/install_deb.sh
cp -a haos-overlay/* ./operating-system/

cd operating-system 

for target in $TARGET; do
    echo -e "Building for target: \033[34;43m$target\033[0m"
    echo "./scripts/enter.sh make -j $(( $(nproc) * 2 )) $target"
    if ./scripts/enter.sh make -j $(( $(nproc) * 2 )) $target; then
        echo "Build for $target succeeded."
    else
        echo "Build for $target failed."
        exit 1
    fi
done
cd ../
if [ ! -d ./output ];then
    ln -s operating-system/output ./output
fi