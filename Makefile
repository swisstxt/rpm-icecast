HOME=$(shell pwd)
VERSION="2.4.0"
SUFIX="kh1"
RELEASE="1"

all: build

clean:
	rm -rf ./rpmbuild
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/

build: clean
	cp -r ./SPECS/* ./rpmbuild/SPECS/
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/
	rpmbuild -ba SPECS/icecast.spec \
	--define "ver ${VERSION}" \
	--define "sufix ${SUFIX}" \
	--define "rel ${RELEASE}" \
	--define "_topdir %(pwd)/rpmbuild" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
