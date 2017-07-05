HOME=$(shell pwd)
NAME=icecast
FORK=kh
VERSION=2.4.0
SUFFIX=5
GITREPO=https://github.com/karlheyes/icecast-${FORK}.git

# For release versions
GITREV=icecast-${FORK}-${VERSION}-${SUFFIX}
URL=https://github.com/karlheyes/icecast-${FORK}/archive/${NAME}-${VERSION}-${FORK}${SUFFIX}.tar.gz
SRCFOLDER=icecast-${FORK}-icecast-${VERSION}-${FORK}${SUFFIX}

# For development versions
#GITREV=e78da33b004917a17210a74e33f5c768880c7cb7
#URL=https://api.github.com/repos/karlheyes/icecast-${FORK}/tarball/${GITREV}
#SRCFOLDER=karlheyes-icecast-${FORK}-e78da33

RELEASE=$(shell /opt/buildhelper/buildhelper getgitrev .)
OS_RELEASE=$(shell /opt/buildhelper/buildhelper getosrelease)
SPEC=$(shell /opt/buildhelper/buildhelper getspec ${NAME})
#ARCHIVE=SOURCES/${NAME}-${VERSION}${FORK}${SUFFIX}.tar.gz
ARCHIVE=SOURCES/${NAME}-${FORK}-${VERSION}-${SUFFIX}.tar.gz

all: clean $(ARCHIVE) build

clean:
	rm -f SOURCES/*.tar.gz
	rm -rf ./rpmbuild
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/

$(ARCHIVE):
	curl -L -s -o "${ARCHIVE}" "${URL}"

build:
	cp -r ./SPECS/* ./rpmbuild/SPECS/
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/
	rpmbuild -bb ${SPEC} \
	--define "ver ${VERSION}" \
	--define "fork ${FORK}" \
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
