HOME=$(shell pwd)
NAME=icecast
FORK=kh
VERSION=2.4.0
REL=9
ARCH=$(shell /opt/buildhelper/buildhelper getarch)
OS_RELEASE=$(shell /opt/buildhelper/buildhelper getosrelease)
#GITREPO=https://github.com/karlheyes/icecast-kh.git

# Shitty nameing here....
#GITREV=icecast-${VERSION}-${SUFFIX}
URL=https://github.com/karlheyes/icecast-kh/archive/${NAME}-${VERSION}-${FORK}${REL}.tar.gz
SRCFOLDER=icecast-kh-icecast-${VERSION}-${SUFFIX}

SPEC=$(shell /opt/buildhelper/buildhelper getspec ${NAME}-${FORK})
ARCHIVE=SOURCES/${NAME}-${FORK}-${VERSION}-${REL}.tar.gz

all: build

clean:
	rm -rf ./rpmbuild
	rm -f SOURCES/icecast-kh*

$(ARCHIVE):
	WGETRC=/dev/null
	wget -q -O "${ARCHIVE}" "${URL}"

build: clean $(ARCHIVE)
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/
	cp -r ./SPECS/* ./rpmbuild/SPECS/
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/
	rpmbuild -v -bb ${SPEC} \
	--define "ver ${VERSION}" \
	--define "fork ${FORK}" \
	--define "rel ${REL}" \
	--define "os_rel ${OS_RELEASE}" \
	--define "arch ${ARCH}" \
	--define "_topdir %(pwd)/rpmbuild" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "debug_package %{nil}"

publish:
	/opt/buildhelper/buildhelper pushrpm yum-01.stxt.media.int:8080/swisstxt-centos

