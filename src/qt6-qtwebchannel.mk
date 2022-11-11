# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtwebchannel
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 qtwebchannel
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.4.0
$(PKG)_CHECKSUM := 528f6d837cc58854deaddafbb76eb237f4dbd688a4407b438ab9c0db1613695a
$(PKG)_FILE     := qtwebchannel-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qtwebchannel-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.4/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc qt6-qtbase qt6-declarative qt6-qtwebsockets
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
