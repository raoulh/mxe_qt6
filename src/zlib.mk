# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := zlib
$(PKG)_WEBSITE  := https://zlib.net/
$(PKG)_DESCR    := A Massively Spiffy Yet Delicately Unobtrusive Compression Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := 38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://zlib.net/$($(PKG)_FILE)
$(PKG)_URL_2    := https://$(SOURCEFORGE_MIRROR)/project/libpng/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://zlib.net/' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' ./configure --prefix='$(PREFIX)/$(TARGET)' --static
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

define $(PKG)_BUILD_SHARED
    $(MAKE) -C '$(1)' -f win32/Makefile.gcc \
        SHARED_MODE=1 \
        STATICLIB= \
        BINARY_PATH='$(PREFIX)/$(TARGET)/bin' \
        INCLUDE_PATH='$(PREFIX)/$(TARGET)/include' \
        LIBRARY_PATH='$(PREFIX)/$(TARGET)/lib' \
        PREFIX='$(TARGET)-' \
        -j '$(JOBS)' install
endef
