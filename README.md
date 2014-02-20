# ICECAST RPM

    git clone https://github.com/swisstxt/rpm-icecast.git
    make VERSION=${VERSION} SUFIX=${SUFIX} RELEASE="${BUILD_NUMBER}.git$(git rev-parse --short HEAD)"
