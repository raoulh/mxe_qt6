FROM ubuntu:22.10 as intermediate_builder

LABEL maintainer="raoul.hecky@gmail.com"
LABEL description="Ubuntu image with Qt6 build with mxe"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    gcc \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    python3 \
    python-is-python3 \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils \
    meson \
    cmake \
    python3-mako \
    texinfo

WORKDIR /mxe

COPY mxe_mingw_qt6 /mxe

RUN make dbus fontconfig freetds libmysqlclient openssl postgresql sqlite icu4c zstd -j4 JOBS=20
RUN make jpeg libwebp xz minizip jasper tiff assimp lcms libmng libxml2 openssl libgit2 -j4 JOBS=20

RUN make qt6-qtbase -j4 JOBS=20
RUN make qt6-qttools -j4 JOBS=20
RUN make qt6-imageformats -j4 JOBS=20
RUN make qt6-qtsvg -j4 JOBS=20
RUN make qt6-qtshadertools -j4 JOBS=20
RUN make qt6-declarative -j4 JOBS=20
RUN make qt6-qtactiveqt -j4 JOBS=20
#RUN make qt6-qt3d -j4 JOBS=20
RUN make qt6-qtcharts -j4 JOBS=20
RUN make qt6-qtconnectivity -j4 JOBS=20
RUN make qt6-qtcore5compat -j4 JOBS=20
#RUN make qt6-qtdatavis3d -j4 JOBS=20
RUN make qt6-qtnetworkauth -j4 JOBS=20
RUN make qt6-qtpositioning -j4 JOBS=20
#RUN make qt6-qtquick3d -j4 JOBS=20
RUN make qt6-qtquicktimeline -j4 JOBS=20
RUN make qt6-qtremoteobjects -j4 JOBS=20
RUN make qt6-qtscxml -j4 JOBS=20
RUN make qt6-qtsensors -j4 JOBS=20
RUN make qt6-qtserialport -j4 JOBS=20
RUN make qt6-qtserialbus -j4 JOBS=20
RUN make qt6-qttranslations -j4 JOBS=20
RUN make qt6-qtwebsockets -j4 JOBS=20
RUN make qt6-qtwebchannel -j4 JOBS=20
RUN make qt6-qtwebview -j4 JOBS=20
#RUN make qt6-qtmultimedia -j4 JOBS=20
RUN make qt6-qtvirtualkeyboard -j4 JOBS=20
RUN make qt6-qtlottie -j4 JOBS=20

RUN make karchive -j4 JOBS=20

#Install innosetup in another stage
FROM amake/wine:latest as inno
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends procps xvfb \
    && rm -rf /var/lib/apt/lists/*

# get at least error information from wine
ENV WINEDEBUG -all,err+all

# Run virtual X buffer on this port
ENV DISPLAY :99

COPY opt /opt
RUN chmod +x /opt/bin/*
ENV PATH $PATH:/opt/bin
USER xclient

# Install Inno Setup binaries
RUN curl -SL "https://files.jrsoftware.org/is/6/innosetup-6.2.0.exe" -o is.exe && \
    wine-x11-run wine is.exe /SP- /VERYSILENT /ALLUSERS /SUPPRESSMSGBOXES && \
    rm is.exe

# Install unofficial languages
RUN cd "/home/xclient/.wine/drive_c/Program Files/Inno Setup 6/Languages" && \
    curl -L "https://api.github.com/repos/jrsoftware/issrc/tarball/is-6_2_0" | \
    tar xz --strip-components=4 --wildcards "*/Files/Languages/Unofficial/*.isl"

#Use multi-stage to not keep builds deps and file into the final image to reduce size
FROM ubuntu:22.10

COPY etc/no-man /etc/dpkg/dpkg.cfg.d/01_nodoc

COPY --from=intermediate_builder /mxe/usr /mxe/usr

RUN addgroup --system xusers \
    && adduser \
    --home /home/xclient \
    --disabled-password \
    --shell /bin/bash \
    --gecos "user for running an xclient application" \
    --ingroup xusers \
    --quiet \
    xclient

# Install some tools required for creating the image
# Install wine and related packages
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends libc6:i386 && \
    apt-get install -y --no-install-recommends \
    wine \
    wine32 \
    osslsigncode \
    && rm -rf /var/lib/apt/lists/*

COPY opt /opt
RUN chmod +x /opt/bin/*
ENV PATH $PATH:/opt/bin

#Copy from intermediate Inno setup
COPY --chown=xclient:xusers --from=inno /home/xclient/.wine /home/xclient/.wine

RUN mkdir /work-iscc && chown xclient:xusers -R /work-iscc

#Install missing dev tools
RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt install -y \
        make zip unzip wget xz-utils git bzip2 bash curl python3 python-is-python3 cifs-utils sudo rsync \
        libpcre2-16-0

# Wine really doesn't like to be run as root, so let's use a non-root user
# iscc must be started with sudo
RUN mkdir /work /nfs-share && \
    chown -R xclient:xusers /work /nfs-share

RUN echo "xclient ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER xclient
ENV HOME /home/xclient
ENV WINEPREFIX /home/xclient/.wine
ENV WINEARCH win32
RUN mkdir /home/xclient/bin
ENV PATH="$HOME/bin:${PATH}"

#Fix host lrelease path that is not found by qmake
RUN sudo ln -s /mxe/usr/x86_64-pc-linux-gnu/qt6/bin/lrelease /mxe/usr/i686-w64-mingw32.shared.posix/qt6/bin/lrelease && \
    sudo ln -s /mxe/usr/x86_64-pc-linux-gnu/qt6/bin/lupdate /mxe/usr/i686-w64-mingw32.shared.posix/qt6/bin/lupdate && \
    sudo ln -s /mxe/usr/x86_64-pc-linux-gnu/qt6/bin/lrelease /mxe/usr/x86_64-w64-mingw32.shared.posix/qt6/bin/lrelease && \
    sudo ln -s /mxe/usr/x86_64-pc-linux-gnu/qt6/bin/lupdate /mxe/usr/x86_64-w64-mingw32.shared.posix/qt6/bin/lupdate
