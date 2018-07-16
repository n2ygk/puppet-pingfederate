Name:           pingfederate
%global pingver 9.1.1
%global pfver pf91
Version:        %{pingver}
Release:        6%{?dist}
Summary:        PingFederate 
Group:          Applications/System
License:        PingIdentity License
URL:            https://documentation.pingidentity.com/pingfederate/%{pfver}/
Source0:        https://s3.amazonaws.com/pingone/public_downloads/pingfederate/%{version}/%{name}-%{version}.zip
Source1:	https://www.pingidentity.com/content/dam/pic/downloads/software/servers/PingFederate/pf-install.sh
Source2:	pingfederate-init
%global fbver 2-0
%global fbversion 2.0
%global fbdoc https://docs.pingidentity.com/bundle/fbcic20_sm_facebookCloudIdentityConnector/page/fbcic20_c_pingFederateFacebookCloudIdentityConnector.html
Source3:        https://www.pingidentity.com/content/dam/ping-6-2-assets/Software/cloud-identity-connectors/Facebook-Cloud-Identity-Connector-%{fbver}.zip
%global gver 1-1-1
%global gversion 1.1.1
%global gdoc https://docs.pingidentity.com/bundle/GoogCIC_sm_googleCloudIdentityConnector/page/GoogCIC_c_googleCloudIdentityConnector_1_1.html
Source4:	https://www.pingidentity.com/content/dam/ping-6-2-assets/Software/cloud-identity-connectors/Google-Cloud-Identity-Connector-%{gver}.zip
%global lver 1-1
%global lversion 1.1
%global ldoc https://docs.pingidentity.com/bundle/licic11_sm_linkedInCloudIdentityConnector/page/licic_c_linkedInCloudIdentityConnector.html
Source5:	https://www.pingidentity.com/content/dam/ping-6-2-assets/Software/cloud-identity-connectors/LinkedIn-Cloud-Identity-Connector-%{lver}.zip
%global tver 1-3
%global tversion 1.3
%global tdoc https://docs.pingidentity.com/bundle/tcic13_sm_twitterCloudIdentityConnector/page/tcic13_c_pingfederateTwitterCloudIdentityConnector.html
Source6:	https://www.pingidentity.com/content/dam/ping-6-2-assets/Software/cloud-identity-connectors/pf-twitter-cloud-identity-connector-%{tversion}.zip
%global wversion 2.1
%global wdoc https://docs.pingidentity.com/bundle/wlcic21_sm_windowsLiveCiC/page/wlcic_c_windowsLiveCloudIdentityConnector.html
Source7:	https://www.pingidentity.com/content/dam/ping-6-2-assets/Software/cloud-identity-connectors/pf-windows-live-cloud-identity-connector-%{wversion}.zip

%description
PingFederate federated identity server version %{pingver}.

This package simply installs the server without configuring it.
See https://documentation.pingidentity.com/pingfederate/%{pfver}/
for configuration instructions.

%package server
Summary: PingFederate Server
BuildRequires:  unzip
Requires:       jre >= 1.8.0

%description server
Installs the basic server with no added plugins.

# the adapters follow:
%package facebook-adapter
Version: %{fbversion}
Summary: PingFederate Facebook Cloud Identity Connector adapter.
Requires: pingfederate-server >= %{version}

%description facebook-adapter
Installs the PingFederate Facebook Cloud Identity Connector plugin.
To configure, see %{fbdoc}

%package google-adapter
Version: %{gversion}
Summary: PingFederate Google Cloud Identity Connector adapter.
Requires: pingfederate-server >= %{version}

%description google-adapter
Installs the PingFederate Google Cloud Identity Connector plugin.
To configure, see %{gdoc}

%package linkedin-adapter
Version: %{lversion}
Summary: PingFederate LinkedIn Cloud Identity Connector adapter.
Requires: pingfederate-server >= %{version}

%description linkedin-adapter
Installs the PingFederate LinkedIn Cloud Identity Connector plugin.
To configure, see %{ldoc}

%package twitter-adapter
Version: %{tversion}
Summary: PingFederate Twitter Cloud Identity Connector adapter.
Requires: pingfederate-server >= %{version}

%description twitter-adapter
Installs the PingFederate Twitter Cloud Identity Connector plugin.
To configure, see %{tdoc}

%package windowslive-adapter
Version: %{wversion}
Summary: PingFederate Windows Live Cloud Identity Connector adapter.
Requires: pingfederate-server >= %{version}

%description windowslive-adapter
Installs the PingFederate Windows Live Cloud Identity Connector plugin.
To configure, see %{wdoc}

####
# The pingfederate-server just unzips into the install directory.
# Plugins are first unzipped and then the .jar files are copied to pingfederate/server/default/deploy

%prep
%setup -T -c -b 3
%setup -D -T -c -b 4
%setup -D -T -c -b 5
%setup -D -T -c -b 6
%setup -D -T -c -b 7

%install 
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt
mkdir -p $RPM_BUILD_ROOT/%{_initddir}
unzip -qq -d $RPM_BUILD_ROOT/opt %{SOURCE0}
(cd $RPM_BUILD_ROOT/opt; ln -s %{name}-%{pingver}/pingfederate %{name})
sed -e 's:@DIR@:/opt/%{name}-%{pingver}/pingfederate/sbin/:' \
    -e 's:@USER@:pingfederate:' \
    %{SOURCE2} >$RPM_BUILD_ROOT/%{_initddir}/pingfederate
# Make the adapters server-independent by installing via the symlink
install -c -m 644 pf-facebook-cloud-identity-connector/dist/* $RPM_BUILD_ROOT/opt/%{name}/server/default/deploy/
install -c -m 644 pf-google-cloud-identity-connector/dist/* $RPM_BUILD_ROOT/opt/%{name}/server/default/deploy/
install -c -m 644 pf-linkedin-cloud-identity-connector/dist/* $RPM_BUILD_ROOT/opt/%{name}/server/default/deploy/
install -c -m 644 pf-twitter-cloud-identity-connector/dist/* $RPM_BUILD_ROOT/opt/%{name}/server/default/deploy/
install -c -m 644 pf-windows-live-connect-cloud-identity-connector/dist/* $RPM_BUILD_ROOT/opt/%{name}/server/default/deploy/

%pre server
case "$1" in
    1)  # initial installation
	# TODO: set JAVA_HOME in init file instead so there's no need for this user homedir.
	/usr/sbin/useradd -g root pingfederate
	# echo export JAVA_HOME=`/bin/readlink -f $(which java) | sed -e 's:/bin/java$::'` >>/home/pingfederate/.bashrc
	# echo export JAVA_HOME=`/bin/readlink -f $(which java) | sed -e 's:/bin/java$::'` >>/home/pingfederate/.bash_profile
	# chown pingfederate /home/pingfederate/.bashrc /home/pingfederate/.bash_profile
	# chmod +x /home/pingfederate/.bashrc
	# chmod +x /home/pingfederate/.bash_profile
	;;
    2)  # upgrade installation
	/sbin/service pingfederate stop > /dev/null 2>&1
	;;
esac
exit 0

%post server
case "$1" in
    1)  # initial installation
	/sbin/chkconfig --add pingfederate
	/sbin/chkconfig pingfederate off
	;;
    2)  # upgrade installation
	/sbin/chkconfig --del pingfederate
	/sbin/chkconfig --add pingfederate
	/sbin/chkconfig pingfederate off
	;;
esac
exit 0

%preun server
case "$1" in
    0)  # uninstall
	/sbin/service pingfederate stop > /dev/null 2>&1
	/sbin/chkconfig --del pingfederate
	;;
esac
exit 0

%postun server
case "$1" in
    0)
	/usr/sbin/userdel pingfederate
	;;
esac
exit 0

%clean
rm -rf $RPM_BUILD_ROOT

%files server
%defattr(-,pingfederate,root,-)
%attr(755,root,root) %{_initddir}/pingfederate
/opt/%{name}-%{pingver}/
/opt/%{name}
%exclude /opt/%{name}/server/default/deploy/pf-facebook-adapter*
%exclude /opt/%{name}/server/default/deploy/json-simple*
%exclude /opt/%{name}/server/default/deploy/pf-google*
%exclude /opt/%{name}/server/default/deploy/pf-linkedin*
%exclude /opt/%{name}/server/default/deploy/scribe*
%exclude /opt/%{name}/server/default/deploy/pf-twitter*
%exclude /opt/%{name}/server/default/deploy/pf-live*

%files facebook-adapter
%defattr(-,pingfederate,root,-)
/opt/%{name}/server/default/deploy/pf-facebook-adapter*
/opt/%{name}/server/default/deploy/json-simple*

%files google-adapter
/opt/%{name}/server/default/deploy/pf-google*

%files linkedin-adapter
/opt/%{name}/server/default/deploy/pf-linkedin*
/opt/%{name}/server/default/deploy/json-simple*
/opt/%{name}/server/default/deploy/scribe*

%files twitter-adapter
/opt/%{name}/server/default/deploy/pf-twitter*
/opt/%{name}/server/default/deploy/json-simple*
/opt/%{name}/server/default/deploy/scribe*

%files windowslive-adapter
/opt/%{name}/server/default/deploy/pf-live*
/opt/%{name}/server/default/deploy/json-simple*

%changelog
* Sat Jul 14 2018  Alan Crosswell <alan@columbia.edu> - 9.1.1-6
- upgrade to 9.1.1 and associated adapter versions

* Mon Jun 26 2017 Alan Crosswell <alan@columbia.edu> - 8.4.0-5
- make adapters independent of server version by installing via the /opt/pingfederate/ symlink

* Fri Jun 23 2017 Alan Crosswell <alan@columbia.edu> - 8.4.0-4
- upgrade to 8.4.0 and Facebook 1.3.2

* Mon Jan 30 2017 Alan Crosswell <alan@columbia.edu> - 8.3.1-3
- upgrade to 8.3.1

* Thu Dec  1 2016 Alan Crosswell <alan@columbia.edu> - 8.2.2-2
- add connectors for additional social identity providers

* Wed Nov 30 2016 Alan Crosswell <alan@columbia.edu> - 8.2.2-1
- initial

