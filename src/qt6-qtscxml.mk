# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtscxml
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 qtscxml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.4
$(PKG)_CHECKSUM := 9b98f43eaf72c282f894564e84e1d93095e654350cb83d85f7d018b7e9efb876
$(PKG)_FILE     := qtscxml-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qtscxml-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.2/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
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
