# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtnetworkauth
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 qtnetworkauth
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.6.1
$(PKG)_CHECKSUM := 693e11945b22735fc9b1662cad53c60098882d301c4f4a3e13c01bcc41c00d49
$(PKG)_FILE     := qtnetworkauth-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qtnetworkauth-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
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
