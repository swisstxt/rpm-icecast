Icecast KH RPM
=============

Builds a rpm based on source of https://github.com/karlheyes/icecast-kh.git

The default rpm name would result in something like icecast-2.4.0kh5-39.el7.centos.x86_64.rpm
The part 2.4.0kh5 is not handled well by yum so some effort has to be taken to control the
rpm name to be something more according to best practice.

Check the Makfile and the Specfile for these modifications.

Usage:
------
	example:
	# git clone https://github.com/swisstxt/rpm-icecast.git
	# cd rpm-icecast
	# make VERSION=2.4.0 SUFFIX=5 RELEASE=40
	Wheras VERSION is the icecast version, SUFFIX denotes the version of the fork (by karl heyes)
	and RELEASE is the SwissTXT build incrementer.
