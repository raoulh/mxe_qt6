# This file is part of MXE. See LICENSE.md for licensing information.

# this pkg is the base for both src/libltdl and plugins/native/libtool
PKG             := libtool
$(PKG)_WEBSITE  := https://www.gnu.org/software/libtool/
$(PKG)_DESCR    := GNU Libtool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.7
$(PKG)_CHECKSUM := 04e96c2404ea70c590c546eba4202a4e12722c640016c12b9b2f1ce3d481e9a8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/libtool/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="libtool-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef
