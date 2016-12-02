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

PingFederate is a big, hairy package with lots of configuration. The intent of this Puppet module is to
make it easier to automate installing and configuring the server, elimiate what are otheriwse a number of
manual steps.

## Usage

At this point, the module only installs PingFederate and performs basic configuraiton of the
`run.properties`. Future updates will include more advanced configuraton.
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
    install_dir    => '/usr/local/pingfederte-1',
	package_ensure => false,
  }
```

## Reference

### Parameters
Using most of the defaults will just work with the exception of adding some social identity providers.

### Packaging
[*install_dir*]
  Path to installation directory of PingFederate server.

[*package_list*]
  Name of package(s) that contains the PingFederate server.

[*package_ensure*]
  Ensure that the package is installed.

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

#### Run PingFederate as a service
[*service_name*]
  Service name.

[*service_ensure*]
  Ensure it is running.

#### Runtime properties.

The following are used to configure `run.properties`. See the
[PingFederate documentation](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/concept/changingConfigurationParameters.html)
for an explanation.

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


## Limitations

This has only been tested on EL 6 with Java 1.8. It might works elsewhere. Let me know!

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

Please fork and submit PRs on [github](https://github.com/n2ygk/puppet-pingfederate)!

