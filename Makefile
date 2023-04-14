HOME=$(shell pwd)
NAME=icecast
VERSION=2.4.4
ARCH=$(shell /opt/buildhelper/buildhelper getarch)
OS_RELEASE=$(shell /opt/buildhelper/buildhelper getosrelease)

# Shitty nameing here....
#https://ftp.osuosl.org/pub/xiph/releases/icecast/icecast-2.4.4.tar.gz
#GITREV=icecast-${VERSION}-${SUFFIX}
URL=https://ftp.osuosl.org/pub/xiph/releases/icecast/${NAME}-${VERSION}.tar.gz
SRCFOLDER=icecast-${VERSION}-${SUFFIX}

SPEC=$(shell /opt/buildhelper/buildhelper getspec ${NAME}-${VERSION})
ARCHIVE=SOURCES/${NAME}-${VERSION}.tar.gz

all: build

clean:
	rm -rf ./rpmbuild
	rm -f SOURCES/icecast*

$(ARCHIVE):
	WGETRC=/dev/null
	wget -q -O "${ARCHIVE}" "${URL}"

build: clean $(ARCHIVE)
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/
	cp -r ./SPECS/* ./rpmbuild/SPECS/
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/
	rpmbuild -v -bb ${SPEC} \
	--define "ver ${VERSION}" \
	--define "os_rel ${OS_RELEASE}" \
	--define "arch ${ARCH}" \
	--define "_topdir %(pwd)/rpmbuild" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "debug_package %{nil}"

publish:
	/opt/buildhelper/buildhelper pushrpm yum-01.stxt.media.int:8080/swisstxt-centos
