# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtserialbus
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 qtserialbus
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.4
$(PKG)_CHECKSUM := 33c15752f8e7f99cc49b9d3bf9eabd857bfcd649e37ada8bffceedc5a66a8a64
$(PKG)_FILE     := qtserialbus-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qtserialbus-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.2/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc qt6-qtbase qt6-qtserialport
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_OO_DEPS_$(BUILD) += qt6-conf ninja

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.qt.io/official_releases/qt/6.2/ | \
    $(SED) -n 's,.*href="\(6\.2\.[^/]*\)/".*,\1,p' | \
    sort |
    tail -1
endef

define $(PKG)_BUILD
    $(QT6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
endef
