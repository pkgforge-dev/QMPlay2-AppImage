#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	clang			\
	cmake			\
	kvantum 	    \
	libass			\
	libcdio			\
	libgme		    \
	libopenmpt		\
    libsidplayfp    \
	lld				\
	lxqt-qtplugin   \
	ninja			\
    pipewire-audio  \
    pipewire-jack   \
	qt6-5compat	    \
	qt6-base 	    \
	qt6-declarative \
	qt6-svg  		\
	qt6-tools		\
	qt6ct			\
	rubberband		\
	shaderc			\
	taglib

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

# Comment this out if you need an AUR package
#make-aur-package qmplay2-git

# If the application needs to be manually built that has to be done down here
echo "Building QMPlay2..."
echo "---------------------------------------------------------------"
REPO="https://github.com/zaps166/QMPlay2"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./QMPlay2
echo "$VERSION" > ~/version

cmake -S ./QMPlay2 -B build \
	-G Ninja \
	-DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
    -DUSE_PCH=ON \
    -DUSE_GIT_VERSION=ON
cmake --build build -j$(nproc)
ninja install
