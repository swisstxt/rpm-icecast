Name:		icecast-%{fork}
Version:	%{ver}
Release:	%{rel}
Summary:	Xiph Streaming media server that supports multiple audio formats. Fork by Karl Heyes.

Group:		Applications/Multimedia
License:	GPL
URL:		http://www.icecast.org/
Vendor:		Xiph.org Foundation <team@icecast.org>
Prefix:		%{_prefix}
BuildRoot:	%{_tmppath}/%{name}-root

Source0:	%{name}-%{ver}-%{rel}.tar.gz
Source1:	icecast.service

Requires:       libvorbis >= 1.0
BuildRequires:	libvorbis-devel >= 1.0
Requires:       libogg >= 1.0
BuildRequires:	libogg-devel >= 1.0
Requires:       curl >= 7.10.0
BuildRequires:	curl-devel >= 7.10.0
Requires:       libxml2
BuildRequires:	libxml2-devel
Requires:       libxslt
BuildRequires:	libxslt-devel

%define systemd_dest /usr/lib/systemd/system/
%define _rpmfilename %{ARCH}/%%{NAME}-%{ver}-%{rel}%{?dist}.%{ARCH}.rpm


%description
Fork by Karl Heyes of the Icecast streaming media server by Xiph.
Supports FLV wrapping and has better performance on single-core computers. 

%pre
getent group icecast > /dev/null || groupadd -r icecast
getent passwd icecast > /dev/null || useradd -r -g icecast -d /usr/share/icecast -s /sbin/nologin -c "icecast streaming server" icecast
exit 0

%prep
# icecast-kh-icecast-2.4.0-kh9...WTF karl...???
%autosetup -v -n %{name}-icecast-%{ver}-%{fork}%{rel}

%build
CFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=%{_prefix} --sysconfdir=/etc --with-openssl
make

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{systemd_dest}

make DESTDIR=$RPM_BUILD_ROOT install
rm -rf $RPM_BUILD_ROOT%{_datadir}/doc/icecast

%{__install} -p -m 0755 %{SOURCE1} $RPM_BUILD_ROOT/%{systemd_dest}/icecast.service

%clean 
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%config(noreplace) /etc/icecast.xml
%config(noreplace) %{_prefix}/share/icecast/admin/*
%config(noreplace) %{_prefix}/share/icecast/web/*
%{_bindir}/icecast
%{_prefix}/share/icecast/*
%{systemd_dest}/icecast.service

%changelog
* Tue Apr 10 2018 Sam Friedli <samuel.friedli@swisstxt.ch>
Major overhaul. Properly handles icecast fork by Karl Heyes (icecast-kh). The package name also reflects this.
* Wed May 25 2016 Gregor Riepl <gregor.riepl@swisstxt.ch>
Changed to git version, already contains a fix for the range bug
* Mon May 23 2016 Gregor Riepl <gregor.riepl@swisstxt.ch>
Added patch to fix empty HTTP range transfers
* Thu Mar 10 2016 Sam Friedli <samuel.friedli@swisstxt.ch>
Re-creation due to splitting of CentOS 6 and 7 version.
