# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := kde-extra-cmake-modules
$(PKG)_VERSION  := 5.101.0
$(PKG)_FILE     := extra-cmake-modules-v$($(PKG)_VERSION).tar.gz
$(PKG)_SUBDIR   := extra-cmake-modules-v$($(PKG)_VERSION)
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1fa74fe864517935b823ed9788ba4e0105e13ed99d8c66e5afb84be5be95041a
$(PKG)_URL      := https://invent.kde.org/frameworks/extra-cmake-modules/-/archive/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

