HOME=$(shell pwd)
NAME=icecast
VERSION=2.4.0
SUFFIX=kh5
GITREPO=https://github.com/karlheyes/icecast-kh.git

# For release versions
GITREV=icecast-${VERSION}-${SUFFIX}
URL=https://github.com/karlheyes/icecast-kh/archive/${NAME}-${VERSION}-${SUFFIX}.tar.gz
SRCFOLDER=icecast-kh-icecast-${VERSION}-${SUFFIX}

# For development versions
#GITREV=e78da33b004917a17210a74e33f5c768880c7cb7
#URL=https://api.github.com/repos/karlheyes/icecast-kh/tarball/${GITREV}
#SRCFOLDER=karlheyes-icecast-kh-e78da33

#RELEASE=$(shell /opt/buildhelper/buildhelper getgitrev .)
RELEASE=51
OS_RELEASE=$(shell /opt/buildhelper/buildhelper getosrelease)
SPEC=$(shell /opt/buildhelper/buildhelper getspec ${NAME})
ARCHIVE=SOURCES/${NAME}-${VERSION}${SUFFIX}.tar.gz

all: build

clean:
	rm -rf ./rpmbuild
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/

$(ARCHIVE):
	echo "Skipping download...workaround!"
	#curl -L -s -o "${ARCHIVE}" "${URL}"

build: $(ARCHIVE) clean
	cp -r ./SPECS/* ./rpmbuild/SPECS/
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/
	rpmbuild -ba ${SPEC} \
	--define "ver ${VERSION}" \
	--define "ver_suffix ${SUFFIX}" \
	--define "git_repo ${GITREPO}" \
	--define "git_rev ${GITREV}" \
	--define "src_folder ${SRCFOLDER}" \
	--define "rel ${RELEASE}" \
	--define "os_rel ${OS_RELEASE}" \
	--define "_topdir %(pwd)/rpmbuild" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \

publish:
	/opt/buildhelper/buildhelper pushrpm yum-01.stxt.media.int:8080/swisstxt-centos
