# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtsvg
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 qtsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.4.0
$(PKG)_CHECKSUM := 03fdae9437d074dcfa387dc1f2c6e7e14fea0f989bf7e1aa265fd35ffc2c5b25
$(PKG)_FILE     := qtsvg-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qtsvg-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.4/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc qt6-qtbase
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
