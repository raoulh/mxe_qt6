# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qttools
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 Tools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.4.0
$(PKG)_CHECKSUM := 97f3d5f88c458be7a8f7b7b08efc06c4ebad39ca51669476b18bf9e4c11afba2
$(PKG)_FILE     := qttools-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qttools-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.4/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc qt6-qtbase $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := qt6-qtbase
$(PKG)_OO_DEPS_$(BUILD) += qt6-conf ninja

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.qt.io/official_releases/qt/6.2/ | \
    $(SED) -n 's,.*href="\(6\.2\.[^/]*\)/".*,\1,p' | \
    sort |
    tail -1
endef

define $(PKG)_BUILD
    $(QT6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' -DCMAKE_BUILD_TYPE='$(MXE_BUILD_TYPE)' -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON -DFEATURE_assistant=OFF
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'

    cp '$(PREFIX)/$(BUILD)/qt6/libexec/moc' '$(PREFIX)/$(TARGET)/qt6/bin/moc.exe'
    cp '$(PREFIX)/$(BUILD)/qt6/libexec/rcc' '$(PREFIX)/$(TARGET)/qt6/bin/rcc.exe'
    cp '$(PREFIX)/$(BUILD)/qt6/libexec/uic' '$(PREFIX)/$(TARGET)/qt6/bin/uic.exe'
    cp '$(PREFIX)/$(BUILD)/qt6/bin/lrelease' '$(PREFIX)/$(TARGET)/qt6/bin/lrelease.exe'
    cp '$(PREFIX)/$(BUILD)/qt6/bin/lconvert' '$(PREFIX)/$(TARGET)/qt6/bin/lconvert.exe'

endef

define $(PKG)_BUILD_$(BUILD)
    $(QT6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
endef
