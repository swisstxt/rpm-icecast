Icecast RPM
===========

Builds an Icecast RPM based on the fork by Karl Heyes
The name of the package is "icecast-kh" (and not "icecast" as in the CentOS or EPEL repos).
Directories, binaries, config files, etc. will still be named "icecast".

Usage:
------
	# Example to Build icecast-2.4.0kh9
	# The resulting rpm will be icecast-kh-2.4.0-9.rpm
	make clean
    make VERSION=2.4.0 REL=12
	# Publish it to swisstxt-centos${centos_version}
	make publish
