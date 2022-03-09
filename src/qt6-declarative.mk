# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-declarative
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 Image Formats
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.3
$(PKG)_CHECKSUM := 2618c31f64820ed426ebfe2c10b6f3a43f08d2c03d6c63f024bc396455c1a86b
$(PKG)_FILE     := qtdeclarative-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qtdeclarative-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.2/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc qt6-qtbase qt6-imageformats qt6-qtsvg qt6-qtshadertools $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := qt6-qtbase qt6-qtsvg qt6-qtshadertools
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

define $(PKG)_BUILD_$(BUILD)
    $(QT6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
endef
