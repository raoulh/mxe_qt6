# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtmqtt
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 qtMQTT
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.6.1
$(PKG)_CHECKSUM := d0c6a89ccace848f5fce35ca634c98e7f93d18611e60ddea3a3d3a9ab661429e
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_SUBDIR   := qtmqtt-$($(PKG)_VERSION)
$(PKG)_URL      := https://github.com/qt/qtmqtt/archive/refs/tags/$($(PKG)_FILE)
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
