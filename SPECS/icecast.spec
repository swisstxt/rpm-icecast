Name:		icecast-
Version:	%{ver}
Summary:	Xiph Streaming media server that supports multiple audio formats. Source from Original software vendor icecast.org

Group:		Applications/Multimedia
License:	GPL
URL:		http://www.icecast.org/
Vendor:		Xiph.org Foundation <team@icecast.org>
Prefix:		%{_prefix}
BuildRoot:	%{_tmppath}/%{name}-root

Source0:	%{name}-%{ver}.tar.gz
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
%define _rpmfilename %{ARCH}/%%{NAME}-%{ver}%{?dist}.%{ARCH}.rpm


%description
Original Software of the Icecast streaming media server by Xiph.

%pre
getent group icecast > /dev/null || groupadd -r icecast
getent passwd icecast > /dev/null || useradd -r -g icecast -d /usr/share/icecast -s /sbin/nologin -c "icecast streaming server" icecast
exit 0

%prep
# example. icecast-2.4.4
%autosetup -v -n %{name}-%{ver}

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
* Creation of original icecast software 
