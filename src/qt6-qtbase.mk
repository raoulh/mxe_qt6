# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6-qtbase
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt 6 Base
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.4.0
$(PKG)_CHECKSUM := cb6475a0bd8567c49f7ffbb072a05516ee6671171bed55db75b22b94ead9b37d
$(PKG)_FILE     := qtbase-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_SUBDIR   := qtbase-everywhere-src-$($(PKG)_VERSION)
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.4/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc openssl fontconfig zlib zstd sqlite mesa $(BUILD)~$(PKG) $(BUILD)~qt6-qttools
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_OO_DEPS_$(BUILD) += qt6-conf ninja

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.qt.io/official_releases/qt/6.4/ | \
    $(SED) -n 's,.*href="\(6\.[0-9]*\.[^/]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir -p '$(PREFIX)/$(TARGET)/qt6/bin/'
    cp '$(PREFIX)/$(BUILD)/qt6/libexec/qvkgen' '$(PREFIX)/$(TARGET)/qt6/bin/qvkgen.exe'
    PKG_CONFIG="${TARGET}-pkg-config" \
    PKG_CONFIG_SYSROOT_DIR="/" \
    PKG_CONFIG_LIBDIR="$(PREFIX)/$(TARGET)/lib/pkgconfig" \
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -G Ninja \
        -DCMAKE_BUILD_TYPE='$(MXE_BUILD_TYPE)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)/qt6' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DPKG_CONFIG_EXECUTABLE=$(PREFIX)/bin/$(TARGET)-pkg-config \
        -DQT_HOST_PATH='$(PREFIX)/$(BUILD)/qt6' \
        -DQT_QMAKE_TARGET_MKSPEC=win32-g++ \
        -DQT_QMAKE_DEVICE_OPTIONS='CROSS_COMPILE=$(TARGET)-;PKG_CONFIG=$(TARGET)-pkg-config' \
        -DQT_BUILD_EXAMPLES=OFF \
        -DQT_BUILD_BENCHMARKS=OFF \
        -DQT_BUILD_TESTS=OFF \
        -DQT_BUILD_EXAMPLES_BY_DEFAULT=OFF \
        -DQT_BUILD_TOOLS_BY_DEFAULT=ON \
        -DQT_WILL_BUILD_TOOLS=ON \
        -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON \
        -DBUILD_WITH_PCH=OFF \
        -DFEATURE_rpath=OFF \
        -DFEATURE_pkg_config=ON \
        -DFEATURE_accessibility=ON \
        -DFEATURE_brotli=ON \
        -DFEATURE_fontconfig=OFF \
        -DFEATURE_freetype=ON \
        -DFEATURE_harfbuzz=ON \
        -DFEATURE_pcre2=ON \
        -DFEATURE_schannel=ON \
        -DFEATURE_openssl=ON \
        $(if $(BUILD_SHARED), -DFEATURE_openssl_linked=ON) \
        -DFEATURE_opengl=ON \
        -DFEATURE_opengl_dynamic=ON \
        -DFEATURE_use_gold_linker_alias=OFF \
        -DFEATURE_glib=OFF \
        -DFEATURE_icu=OFF \
        -DFEATURE_directfb=OFF \
        -DFEATURE_dbus=OFF \
        -DFEATURE_sql=ON \
        -DFEATURE_sql_sqlite=ON \
        -DFEATURE_sql_odbc=ON \
        -DFEATURE_sql_mysql=OFF \
        -DFEATURE_sql_psql=OFF \
        -DFEATURE_jpeg=ON \
        -DFEATURE_png=ON \
        -DFEATURE_gif=ON \
        -DFEATURE_style_windows=ON \
        -DFEATURE_style_windowsvista=ON \
        -DFEATURE_system_zlib=ON \
        -DFEATURE_qt_png=ON \
        -DFEATURE_qt_jpeg=ON \
        -DFEATURE_qt_pcre2=ON \
        -DFEATURE_qt_harfbuzz=ON \
        -DFEATURE_qt_freetype=ON \
        -DFEATURE_qt_sqlite=ON

    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'

endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && CXXFLAGS='$(CXXFLAGS) -Wno-unused-but-set-variable' '$(SOURCE_DIR)/configure' \
        -prefix '$(PREFIX)/$(TARGET)/qt6' \
        -static \
        -release \
        -opensource \
        -confirm-license \
        -developer-build \
        -no-{accessibility,glib,openssl,opengl,dbus,fontconfig,icu,harfbuzz,xcb-xlib,xcb,xkbcommon,eventfd,evdev,gif,ico,libjpeg,pch} \
        -no-sql-{db2,ibase,mysql,oci,odbc,psql,sqlite} \
        -no-use-gold-linker \
        -nomake examples \
        -nomake tests \
        -nomake benchmarks \
        -nomake manual-tests \
        -nomake minimal-static-tests \
        -make tools

    '$(TARGET)-cmake' --build '$(BUILD_DIR)' -j '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'
endef
