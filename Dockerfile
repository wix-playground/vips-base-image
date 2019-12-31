FROM golang:buster as builder

ARG LIBVIPS_VERSION="8.8.4"

# Installs libvips + required libraries

RUN DEBIAN_FRONTEND=noninteractive \
    apt update && \
    apt install --no-install-recommends -y \
    ca-certificates \
    automake build-essential curl \
    gobject-introspection gtk-doc-tools libglib2.0-dev libjpeg62-turbo-dev libpng-dev \
    libwebp-dev libtiff5-dev libgif-dev libexif-dev libxml2-dev libpoppler-glib-dev \
    swig libmagickwand-dev libpango1.0-dev libmatio-dev libopenslide-dev libcfitsio-dev \
    libgsf-1-dev fftw3-dev liborc-0.4-dev librsvg2-dev libimagequant-dev libheif-dev

RUN cd /tmp && \
    curl -fsSLO https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz && \
    tar zvxf vips-${LIBVIPS_VERSION}.tar.gz && \
    cd /tmp/vips-${LIBVIPS_VERSION} && \
	CFLAGS="-g -O3" CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0 -g -O3" \
    ./configure \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-introspection \
    --disable-static \
    --enable-gtk-doc-html=no \
    --enable-gtk-doc=no \
    --enable-pyvips8=no && \
    make && \
    make install && \
    ldconfig

COPY . /media-platform-image-manipulator
