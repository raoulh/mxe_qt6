# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := karchive
$(PKG)_VERSION  := 5.101.0
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.gz
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 109d73992562a091835c49110fedad04eb7900d40ccfcd5ebf3347616d4b1281
$(PKG)_URL      := https://invent.kde.org/frameworks/karchive/-/archive/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc kde-extra-cmake-modules zlib bzip2 xz zstd qt6-qtbase

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
		-DBUILD_TESTING=0 \
		-DBUILD_WITH_QT6=ON \
                -DQT_MAJOR_VERSION=6
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
