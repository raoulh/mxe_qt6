# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtmultimedia
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 qtmultimedia
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.4.0
$(PKG)_CHECKSUM := e82e8e847cae2a951a11db05b6d10a22b21e3a1d72e06a7781cce4bd197e796f
$(PKG)_FILE     := qtmultimedia-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qtmultimedia-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.4/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc qt6-qtbase qt6-declarative qt6-qtshadertools ffmpeg
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_OO_DEPS_$(BUILD) += qt6-conf ninja

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.qt.io/official_releases/qt/6.2/ | \
    $(SED) -n 's,.*href="\(6\.2\.[^/]*\)/".*,\1,p' | \
    sort |
    tail -1
endef

define $(PKG)_BUILD
    $(QT6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DFEATURE_gstreamer=OFF
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
endef
