# pingfederate

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with pingfederate](#setup)
    * [Beginning with pingfederate](#beginning-with-pingfederate)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures the
[PingFederate](https://www.pingidentity.com/en/products/pingfederate.html) server using
Puppet instead of the more typical interactive shell-script approach.

## Setup

### Beginning with pingfederate

PingFederate is a big, complex package with lots of configuration. The intent of this Puppet module is to
make it easier to automate installing and configuring the server, eliminating what are otheriwse a number of
manual steps.

## Usage

At this point, the module only installs PingFederate and performs basic static configuration of the
server, that is, things that are changed prior to starting it up. These include the 
`run.properties` and various configuration XML files, and installation of the license key.
Future versions will include more advanced administrative configuraton, that is, things that
you configure once the basic system is up and running.

If you have access to the RPMs (custom-built; not distributed by PingIdentity),
it will install them, if not, install it the usual way by downloading and unzipping; you can still
use this module to manager the configuration.

### Basic Usage with RPMS available
```
include pingfederate
```

### Basic Usage without RPMS
Install PingFederate per the [installation manual](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#gettingStartedGuide/concept/gettingStarted.html) and disable RPM installation:
```
  class {'pingfederate':
    install_dir    => '/usr/local/pingfederate-1',
	package_ensure => false,
  }
```

### Providing the License Key
PingFederate is commercial licensed software and will not operate without a license key.
Provide this either in your invocation of the module or, preferably, via Hiera. Here's an example
of providing it inline as a here document:
```
$lic = @(LICENSE)
	   ID=12345
	   Organization=Columbia University
	   Product=PingFederate
	   Version=8.2
	   IssueDate=2016-11-3
	   EnforcementType=3
	   ExpirationDate=2016-12-3
	   Tier=Free
	   SaasProvisioning=true
	   WSTrustSTS=true
	   OAuth=true
	   SignCode=FF07
	   Signature=302C02141B733A755996FB354FAEDC5211E14E3BC2B4964602144EFBD282F20EF2B77AA8A87DCB17BE533A539720
	   | LICENSE

class {'pingfederate':
  license_content => $lic,
}

```

## Reference

### Parameters
Using most of the defaults will just work to get the basic server installed and running. You will have to supply
the license key file via a secure manner (e.g. via hiera).

You will need to explicitly enable and configure the various social identity plugins.

#### Packaging
[*install_dir*]
  Path to installation directory of PingFederate server.

[*owner*]
  Filesystem owner. Make sure this matches whatever the packaging system uses.

[*group*]
  Filesystem group. Make sure this matches whatever the packaging system uses.

[*package_list*]
  Name of package(s) that contains the PingFederate server.

[*package_ensure*]
  Ensure that the package is installed.

[*package_java_ensure*]
  Ensure that the Java JRE package is installed.

[*package_java_redhat*]
  Name of the preferred Java JRE package under RHEL

[*package_java_centos*]
  Name of the preferred Java JRE package under CentOS

[*facebook_adapter*]
  Set to true to enable the Facebook CIC adapter. Default: false.

[*facebook_package_list*]
  Name of package(s) that contains the Facebook adapter.

[*facebook_package_ensure*]
  Ensure that the package is installed.

*And likewise for the following:
[*google_adapter*]

[*google_package_list*]

[*google_package_ensure*]

[*linkedin_adapter*]

[*linkedin_package_list*]

[*linkedin_package_ensure*]

[*twitter_adapter*]

[*twitter_package_list*]

[*twitter_package_ensure*]

[*windowslive_adapter*]

[*windowslive_package_list*]

[*windowslive_package_ensure*]

#### Service
[*service_name*]
  Service name.

[*service_ensure*]
  Ensure it is running.

#### License File
Provider either a license file or the content. 

[*license_content*]
  String containing the content of the pflicense.lic file

[*license_file*]
  Path to the pflicense.lic file

#### Run.properties

The following are used to configure `run.properties`. See the
[PingFederate documentation](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/concept/changingConfigurationParameters.html)
for an explanation. The defaults are as distributed by PingIdentity.

[*admin_https_port*]

[*admin_hostname*]

[*console_bind_address*]

[*console_title*]

[*console_session_timeout*]

[*console_login_mode*]

[*console_authentication*]

[*admin_api_authentication*]

[*http_port*]

[*https_port*]

[*secondary_https_port*]

[*engine_bind_address*]

[*monitor_bind_address*]

[*log_event_detail*]

[*heartbeat_system_monitoring*]

[*operational_mode*]

[*cluster_node_index*]

[*cluster_auth_pwd*]

[*cluster_encrypt*]

[*cluster_bind_address*]

[*cluster_bind_port*]

[*cluster_failure_detection_bind_port*]

[*cluster_transport_protocol*]

[*cluster_mcast_group_address*]

[*cluster_mcast_group_port*]

[*cluster_tcp_discovery_initial_hosts*]

[*cluster_diagnostics_enabled*]

[*cluster_diagnostics_addr*]

[*cluster_diagnostics_port*]

#### Administration

[*adm_user*]
  Initial administrator user.

[*adm_pass*]
  Administrator user's password.

[*adm_hash*]
  Hash of administrator user's password.

[*adm_api_baseURL*]
  Base URL of the pf-admin-api.

#### Built-in SAML2 IdP

[*saml2_local_entityID*]
  SAML 2 EntityID for the built-in local IdP (that provides the *adm_user* authentication).

[*saml2_local_baseURL*]
  URL for the local SAML 2 entity.

#### Cross-Origin Resource Sharing (CORS)
[*cors_allowedOrigins*]
  Allowed origins for CORS. Default `*`

[*cors_allowedMethods*]
  Allowed HTTP methods for CORS. Default `GET,OPTIONS,POST`
  
[*cors_filter_mapping*]
  Allowed URL filter mappings for CORS. Default `/*`

#### OGNL expressions
[*ognl_expressions_enable*]
  Enable OGNL scripting. Default `true`

#### OAuth configuration
[*oauth_jdbc_url*]
  URL for
  [OAuth Client Datastore](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#concept_definingOauthClientDataStore.html)


## Limitations

This has only been tested on EL 6 with Java 1.8. It might work elsewhere. Let me know!

## Development

The package was built to use PingFederate as an OAuth2 Server with SAML and social identity federation for the
authorization code flow. PingFederate has many other features which are not yet configured here. 

Please fork and submit PRs on [github](https://github.com/n2ygk/puppet-pingfederate) as you add features.

### Next Steps

Planned next development steps are to:

1. Configure the various static XML files for a JDBC database connector, CORS support, etc.

1. Configure the database server (schema initialization, etc.).

1. Configure administrative settings via the pf-admin-api once the server is up and running.

### Using Augeas to edit XML configuration files

See [this Augeas blog post](http://elatov.github.io/2014/09/using-augeas-to-modify-configuration-files/)
for a great introduction, Use the `augtool` command to test Augeas parsing before wasting too much
time with using it with Puppet.

Of note, the Properties lens appears to be broken for Java Properties files like run.properties. At least that's
been my experience with the (out-of-date) version of the augeas-libs on CentOS 6. I ended up using puppetlabs-inifile
for that.

However, it appears to work well for XML files. Here's an example of looking at the admin-user password
file which will help write the puppet augeas expression:

```bash
[vagrant@localhost opt]$ augtool -A
augtool> set /augeas/load/Xml/lens Xml.lns
augtool> set /augeas/load/Xml/incl /opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml
augtool> load
augtool> ls /files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/
#declaration/ = (none)
adm:administrative-users/ = (none)
augtool> print /files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/#declaration
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/#declaration/#attribute
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/#declaration/#attribute/version = "1.0"
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/#declaration/#attribute/encoding = "UTF-8"
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/adm:administrative-users
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/adm:administrative-users/#attribute
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/adm:administrative-users/#attribute/multi-admin = "true"
/files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/adm:administrative-users/#attribute/xmlns:adm = "http://pingidentity.com/2006/01/admin-users"
...
augtool> ls /files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/adm:administrative-users/
#attribute/ = (none)
#text =

adm:user/ = (none)
augtool> ls /files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/adm:administrative-users/adm:user/
adm:active/                    adm:description/               adm:user-name/                 #text[14]                      #text[7]
adm:admin/                     adm:email-address/             #text[1]                       #text[2]                       #text[8]
adm:admin-manager/             adm:hash/                      #text[10]                      #text[3]                       #text[9]
adm:auditor/                   adm:password-change-required/  #text[11]                      #text[4]
adm:crypto-manager/            adm:phone-number/              #text[12]                      #text[5]
adm:department/                adm:salt                       #text[13]                      #text[6]
augtool> ls /files/opt/pingfederate-8.2.2/pingfederate/server/default/data/pingfederate-admin-user.xml/adm:administrative-users/adm:user/adm:active/
#text = true
augtool>
```

Here's the corresponding password file (with the hash hosed-up just a little):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<adm:administrative-users multi-admin="true" xmlns:adm="http://pingidentity.com/2006/01/admin-users">
    <adm:user>
        <adm:user-name>Administrator</adm:user-name>
        <adm:salt/>
        <adm:hash>k1H1o2jc66xxxDjJKq85Sr22QNk143S20oR2Yyt2kqo.5Cu-mnqB.2</adm:hash>
        <adm:phone-number xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
        <adm:email-address xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
        <adm:department xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
        <adm:description>Initial administrator user.</adm:description>
        <adm:admin-manager>true</adm:admin-manager>
        <adm:admin>true</adm:admin>
        <adm:crypto-manager>true</adm:crypto-manager>
        <adm:auditor>false</adm:auditor>
        <adm:active>true</adm:active>
        <adm:password-change-required>false</adm:password-change-required>
    </adm:user>
</adm:administrative-users>
```

N.B. If the XML file is not pre-existing, the Augeas XML lens will not "pretty-print" the XML;
it will all be run together with no indentation. Do not fear as this is still valid XML.

See [these additional notes](notes.md) for more background on how to
develop configuration puppet modules based on diffs of XML config files.

### Custom Facts
Custom external facts are defined in [facts.d/](facts.d/).

[*${::facts[$::pingfederate::oauth_jdbc_url]}*]
  A custom [external fact](facts.d/pingxmlfacts.py) is named the same as the
  oauth_jdbc_url and with value of the JNDI-name that the server assigned when the
  datastore was added (via the pf-admin-api).
