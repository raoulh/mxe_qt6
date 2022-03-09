# :floppy_disk: MXE (M cross environment) [![License][license-badge]][license-page]

[license-page]: LICENSE.md
[license-badge]: https://img.shields.io/badge/License-MIT-brightgreen.svg

MXE (M cross environment) is a Makefile that compiles a cross compiler and many free libraries.

This is a modified and minimal version of MXE specifically to build [Calaos](https://github.com/calaos) and [Moolticute](https://github.com/mooltipass/moolticute)

Feel free to make use of it if you need something.

See [MXE](https://github.com/mxe/mxe) for the official and full version.

Some of the libraries here are:

  * GCC 11
  * pthreads
  * Boost
  * CMake
  * Protobuf
  * GLib
  * GStreamer
  * GnuTLS
  * OpenSSL
  * SQLite
  * FFTW
  * Qt 6 with all available modules
  * Google Test

+ All their dependencies.

Differences from the official repositories:

  * Most of the packages here are on the latest version
  * Up-to-date core packages, GLib, libsoup and pango.
  * GStreamer has only audio specific plugins.

## Docker

In the docker/ folder you can find a docker file to build the entire toolchain for x86 and x86-64. This image can be reused by build CI to build your own binaries.

An already built docker image is available [Docker Hub](https://hub.docker.com/repository/docker/raoulh/mxe_qt6)
