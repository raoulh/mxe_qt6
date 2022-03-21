# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-declarative
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 Image Formats
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.4
$(PKG)_CHECKSUM := fa6a8b5bfe43203daf022b7949c7874240ec28b9c4b7ebc52b2e5ea440e6e94f
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
