# pingfederate

#### Table of Contents

<!-- TOC generated with: `markdown-toc -i README.md` -->

<!-- toc -->

- [Description](#description)
- [Compatibility](#compatibility)
- [Setup](#setup)
  * [Beginning with pingfederate](#beginning-with-pingfederate)
- [Usage](#usage)
  * [Basic Usage](#basic-usage)
    + [with RPMS available](#with-rpms-available)
    + [without RPMS](#without-rpms)
  * [Parameters](#parameters)
    + [Packaging](#packaging)
      - [`install_dir`](#install_dir)
      - [`owner`](#owner)
      - [`group`](#group)
      - [`package_list`](#package_list)
      - [`package_ensure`](#package_ensure)
      - [`package_java_ensure`](#package_java_ensure)
      - [`package_java_redhat`](#package_java_redhat)
      - [`package_java_centos`](#package_java_centos)
    + [Service](#service)
      - [`service_name`](#service_name)
      - [`service_ensure`](#service_ensure)
    + [Logging](#logging)
      - [`log_dir`](#log_dir)
      - [`log_retain_days`](#log_retain_days)
      - [`log_files`](#log_files)
      - [`log_levels`](#log_levels)
    + [Providing the License Key](#providing-the-license-key)
      - [`license_content`](#license_content)
      - [`license_file`](#license_file)
    + [Run.properties](#runproperties)
      - [`admin_https_port`](#admin_https_port)
      - [`admin_hostname`](#admin_hostname)
      - [`console_bind_address`](#console_bind_address)
      - [`console_title`](#console_title)
      - [`console_session_timeout`](#console_session_timeout)
      - [`console_login_mode`](#console_login_mode)
      - [`console_authentication`](#console_authentication)
      - [`admin_api_authentication`](#admin_api_authentication)
      - [`http_port`](#http_port)
      - [`https_port`](#https_port)
      - [`secondary_https_port`](#secondary_https_port)
      - [`engine_bind_address`](#engine_bind_address)
      - [`monitor_bind_address`](#monitor_bind_address)
      - [`log_event_detail`](#log_event_detail)
      - [`heartbeat_system_monitoring`](#heartbeat_system_monitoring)
      - [`operational_mode`](#operational_mode)
      - [`cluster_node_index`](#cluster_node_index)
      - [`cluster_auth_pwd`](#cluster_auth_pwd)
      - [`cluster_encrypt`](#cluster_encrypt)
      - [`cluster_bind_address`](#cluster_bind_address)
      - [`cluster_bind_port`](#cluster_bind_port)
      - [`cluster_failure_detection_bind_port`](#cluster_failure_detection_bind_port)
      - [`cluster_transport_protocol`](#cluster_transport_protocol)
      - [`cluster_mcast_group_address`](#cluster_mcast_group_address)
      - [`cluster_mcast_group_port`](#cluster_mcast_group_port)
      - [`cluster_tcp_discovery_initial_hosts`](#cluster_tcp_discovery_initial_hosts)
      - [`cluster_diagnostics_enabled`](#cluster_diagnostics_enabled)
      - [`cluster_diagnostics_addr`](#cluster_diagnostics_addr)
      - [`cluster_diagnostics_port`](#cluster_diagnostics_port)
    + [Cross-Origin Resource Sharing (CORS)](#cross-origin-resource-sharing-cors)
      - [`cors_allowedOrigins`](#cors_allowedorigins)
      - [`cors_allowedMethods`](#cors_allowedmethods)
      - [`cors_allowedHeaders`](#cors_allowedheaders)
      - [`cors_filter_mapping`](#cors_filter_mapping)
    + [OGNL expressions](#ognl-expressions)
      - [`ognl_expressions_enable`](#ognl_expressions_enable)
    + [Administration](#administration)
      - [`adm_user`](#adm_user)
      - [`adm_pass`](#adm_pass)
      - [`adm_hash`](#adm_hash)
      - [`adm_api_baseURL`](#adm_api_baseurl)
      - [`service_api_baseURL`](#service_api_baseurl)
    + [Native SAML2 IdP](#native-saml2-idp)
      - [`saml2_local_entityID`](#saml2_local_entityid)
      - [`saml1_local_issuerID`](#saml1_local_issuerid)
      - [`wsfed_local_realm`](#wsfed_local_realm)
      - [`http_forwarded_for_header`](#http_forwarded_for_header)
      - [`http_forwarded_host_header`](#http_forwarded_host_header)
    + [SAML 2.0 SP Configuration](#saml-20-sp-configuration)
      - [Authentication Policy Contracts](#authentication-policy-contracts)
        * [`name` (string)](#name-string)
        * [`core_attrs` (Array[string])](#core_attrs-arraystring)
        * [`extd_attrs` (Array[string])](#extd_attrs-arraystring)
    + [SAML 2.0 Partner IdP Configuration](#saml-20-partner-idp-configuration)
      - [`url`](#url)
      - [`post`](#post)
      - [`redirect`](#redirect)
      - [`entityID`](#entityid)
      - [`name`](#name)
      - [`metadata`](#metadata)
      - [`virtual`](#virtual)
      - [`contact`](#contact)
      - [`profiles`](#profiles)
      - [`auth_policy_contract`](#auth_policy_contract)
      - [`id_mapping`](#id_mapping)
      - [`core_attrs`](#core_attrs)
      - [`extd_attrs`](#extd_attrs)
      - [`attr_map`](#attr_map)
      - [`oauth_map`](#oauth_map)
      - [`cert_file`](#cert_file)
      - [`cert_content`](#cert_content)
      - [`saml2_oauth_token_map`](#saml2_oauth_token_map)
    + [OAuth JDBC configuration](#oauth-jdbc-configuration)
      - [`oauth_jdbc_type`](#oauth_jdbc_type)
      - [`oauth_jdbc_db`](#oauth_jdbc_db)
      - [`oauth_jdbc_user`](#oauth_jdbc_user)
      - [`oauth_jdbc_pass`](#oauth_jdbc_pass)
      - [`oauth_jdbc_host`](#oauth_jdbc_host)
      - [`oauth_jdbc_port`](#oauth_jdbc_port)
      - [`oauth_jdbc_driver`](#oauth_jdbc_driver)
      - [`oauth_jdbc_package_list`](#oauth_jdbc_package_list)
      - [`oauth_jdbc_package_ensure`](#oauth_jdbc_package_ensure)
      - [`oauth_jdbc_jar_dir`](#oauth_jdbc_jar_dir)
      - [`oauth_jdbc_jar`](#oauth_jdbc_jar)
      - [`oauth_jdbc_url`](#oauth_jdbc_url)
      - [`oauth_jdbc_validate`](#oauth_jdbc_validate)
      - [`oauth_jdbc_create_cmd`](#oauth_jdbc_create_cmd)
      - [`oauth_jdbc_client_ddl_cmd`](#oauth_jdbc_client_ddl_cmd)
      - [`oauth_jdbc_access_ddl_cmd`](#oauth_jdbc_access_ddl_cmd)
      - [`acct_jdbc_linking_ddl_cmd`](#acct_jdbc_linking_ddl_cmd)
    + [OAuth client manager](#oauth-client-manager)
      - [`oauth_client_mgr_user`](#oauth_client_mgr_user)
      - [`oauth_client_mgr_pass`](#oauth_client_mgr_pass)
    + [OAuth server settings](#oauth-server-settings)
      - [`oauth_svc_scopes`](#oauth_svc_scopes)
      - [`oauth_svc_scope_groups`](#oauth_svc_scope_groups)
      - [`oauth_svc_grant_core_attrs`](#oauth_svc_grant_core_attrs)
      - [`oauth_svc_grant_extd_attrs`](#oauth_svc_grant_extd_attrs)
    + [OAuth scope selectors](#oauth-scope-selectors)
      - [`oauth_scope_selectors`](#oauth_scope_selectors)
      - [`oauth_scope_fail_no_selection`](#oauth_scope_fail_no_selection)
    + [OAuth Access Token Managers](#oauth-access-token-managers)
      - [`oauth_svc_acc_tok_mgr_id`](#oauth_svc_acc_tok_mgr_id)
      - [`oauth_svc_acc_tok_mgr_core_attrs`](#oauth_svc_acc_tok_mgr_core_attrs)
      - [`oauth_svc_acc_tok_mgr_extd_attrs`](#oauth_svc_acc_tok_mgr_extd_attrs)
    + [OAuth OpenID Connect Policy Contracts](#oauth-openid-connect-policy-contracts)
      - [`oauth_oidc_policy_id`](#oauth_oidc_policy_id)
      - [`oauth_oidc_id_userinfo`](#oauth_oidc_id_userinfo)
      - [`oauth_oidc_policy_core_map`](#oauth_oidc_policy_core_map)
      - [`oauth_oidc_policy_extd_map`](#oauth_oidc_policy_extd_map)
      - [`oauth_authn_policy_map`](#oauth_authn_policy_map)
    + [`social_adapter`](#social_adapter)
        * [`name`](#name-1)
        * [`enable`](#enable)
        * [`package_list`](#package_list-1)
        * [`package_ensure`](#package_ensure-1)
        * [`app_id`](#app_id)
        * [`app_secret`](#app_secret)
        * [`oauth_token_map`](#oauth_token_map)
        * [`oauth_idp_map`](#oauth_idp_map)
    + [OAuth Clients](#oauth-clients)
      - [`oauth_client_default`](#oauth_client_default)
      - [`oauth_client`](#oauth_client)
- [Limitations](#limitations)
  * [Operating System Support](#operating-system-support)
  * [Known Issues](#known-issues)
- [Development](#development)
  * [Using Augeas to edit XML configuration files](#using-augeas-to-edit-xml-configuration-files)
  * [Invoking the administrative REST API (pf-admin-api)](#invoking-the-administrative-rest-api-pf-admin-api)
    + [pf-admin-api idempotent REST API client](#pf-admin-api-idempotent-rest-api-client)
    + [oauth_jdbc_augeas script](#oauth_jdbc_augeas-script)

<!-- tocstop -->

## Description

This module installs and configures the
[PingFederate](https://www.pingidentity.com/en/products/pingfederate.html) server using
Puppet instead of the more typical interactive shell-script approach.

## Compatibility

This module has been tested with PingFederate 8.x - 9.x and related social adapters (in progress).

## Setup

### Beginning with pingfederate

PingFederate is a big, complex package with lots of configuration. The intent of this Puppet module is to
make it easier to automate installing and configuring the server, eliminating what are otheriwse a number of
manual steps.

## Usage

The module installs PingFederate, performs basic static configuration of the
server, that is, things that are changed prior to starting it up, and post-startup administration.
The static configuration includes the run.properties` and various configuration XML files, 
and installation of the license key.

The administrative configuraton is done to the point of being able to
build a completely configuration-as-code PingFederate instance that does real work.

If you have access to the RPMs (custom-built; not distributed by PingIdentity, but see
[this example SPEC file](examples/pingfederate.spec) and [this init.d script](examples/pingfederate-init)),
this module will install them, if not, install it the usual way by downloading and unzipping; you can still
use this module to manage the configuration.

### Basic Usage
#### with RPMS available
This example will only work if you use Hiera to override the default parameters.
```
include pingfederate
```

#### without RPMS
Install PingFederate per the [installation manual](https://documentation.pingidentity.com/pingfederate/pf83/index.shtml#gettingStartedGuide/concept/gettingStarted.html) and disable RPM installation:
```
  class {'pingfederate':
    install_dir    => '/usr/local/pingfederate-1',
    package_ensure => false,
  }
```

### Parameters
Using most of the defaults will just work to get the basic server installed and running. However, it will not do a heck of a lot. You'll need
to set a number of the following parameters.

#### Packaging
##### `install_dir`
  (string)
  Path to installation directory of PingFederate server.
  Default: `'/opt/pingfederate'`

##### `owner`
  (string)
  Filesystem owner. Make sure this matches whatever the packaging system uses.
  Default: `'pingfederate'`

##### `group`
  (string)
  Filesystem group. Make sure this matches whatever the packaging system uses.
  Default: `'pingfederate'`

##### `package_list`
  (array[string])
  Name(s) of package(s) that contains the PingFederate server.
  Default: `'pingfederate-server'`

##### `package_ensure`
  (string)
  Ensure that the package is installed. Values are the same as those used by the
  [Package type](https://docs.puppet.com/puppet/latest/types/package.html)
  such as present (also called installed), absent, purged, held, latest or a
  specfic version string.
  Default: `'installed'`

##### `package_java_ensure`
  (string)
  Ensure that the Java JRE package is installed.
  Default: `'installed'`

##### `package_java_redhat`
  (string)
  Name of the preferred Java JRE package under RHEL
  Default: `'java-1.8.0-oracle'`

##### `package_java_centos`
  (string)
  Name of the preferred Java JRE package under CentOS
  Default: `jre1.8.0_111`

#### Service
##### `service_name`
  (string) Service name. Default: `'pingfederate'`

##### `service_ensure`
  (string).
  Ensure it is running. Values are the same as those used by the
  [service resource](https://docs.puppet.com/puppet/latest/types/service.html#service-attribute-ensure).
  Default: `true`

#### Logging
##### `log_dir`
  (string) Directory for log files. Default: `${install_dir}/log`

##### `log_retain_days`
  (integer) Number of days to retain log files. Default: `30`

##### `log_files`
  (Array[map]) List of log4j RollingFile overrides. Map keys:
  - name: name of the logger
  - fileName: log file name.
  - filePattern: pattern for the rotated log file name

  Default: []

  Example:
  ```
  pingfederate::log_files:
    - name: FILE
      fileName: 'server.log'
      filePattern: 'server.log.%i'
    - name: SamlTransaction
      fileName: 'transaction.log'
      filePattern: 'transaction.log.%i'
    - name: SecurityAudit2File
      fileName: 'audit.log
      filePattern: 'audit.log.%i'
  ```
  Hint: add extra keys to this map for your own purposes. For example, `sumo: true` might be
  used to flag this file for ingestion into sumologic (configured in your local profile module).

##### `log_levels`
  (Array[map]) List of log4j log level overrides. Map elements:
  - name: name of the logger
  - level: log level (`DEBUG`, `INFO`, etc.)

  Default: []

  Example:
  ```
  pingfederate::log_levels:
    - name: org.sourceid
      level: DEBUG
    - name: com.pingidentity.appserver.jetty
      level: DEBUG
  ```

#### Providing the License Key
PingFederate is commercial licensed software and will not operate without a license key.
Provide this either in your invocation of the module or, preferably, via Hiera.

Provide either a license file or the content as a multiline string.

##### `license_content`
  (string) Content of the pflicense.lic file. Example:
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
    ...
    license_content => $lic,
    ...
  }
```

##### `license_file`
  (string) Path to the pflicense.lic file.

#### Run.properties

The following are used to configure `run.properties`. See the
[PingFederate documentation](https://documentation.pingidentity.com/pingfederate/pf83/index.shtml#adminGuide/concept/changingConfigurationParameters.html)
for an explanation. The defaults are as distributed by PingIdentity.

##### `admin_https_port`
  (integer) Default: `9999`

##### `admin_hostname`
  (string) No default.

##### `console_bind_address`
  (string) Default: `'0.0.0.0'`

##### `console_title`
  (string) Default: `'PingFederate'`

##### `console_session_timeout`
  (integer) Default: `30`

##### `console_login_mode`
  (string) Default `'multiple'`

##### `console_authentication`
  (string) Default: `'native'`

##### `admin_api_authentication`
  (string) Default: `'native'`

##### `http_port`
  (integer) Default: `-1` (none)

##### `https_port`
  (integer) Default: `9031`

##### `secondary_https_port`
  (integer) Default: `-1` (none)

##### `engine_bind_address`
  (string) Default: `'0.0.0.0'`
  
##### `monitor_bind_address`
  (string) Default: `'0.0.0.0'`
  
##### `log_event_detail`
  (boolean) Default: `false`

##### `heartbeat_system_monitoring`
  (boolean) Default: `false`

##### `operational_mode`
  (string) Default: `'STANDALONE'`

##### `cluster_node_index`
  (integer) Default `0`

##### `cluster_auth_pwd`
  (string) No default.

##### `cluster_encrypt`
  (boolean) Default: `false`

##### `cluster_bind_address`
  (string) Default: `'NON_LOOPBACK'`

##### `cluster_bind_port`
  (integer) Default `7600`

##### `cluster_failure_detection_bind_port`
  (integer) Default `7700`

##### `cluster_transport_protocol`
  (string) Default: `'tcp'`

##### `cluster_mcast_group_address`
  (string) Default: `'239.16.96.69'`

##### `cluster_mcast_group_port`
  (integer) Default `7601`
  
##### `cluster_tcp_discovery_initial_hosts`
  (array[string]) No default. Note that the `cluster_bind_port` must be the same on the other hosts as this one.
  
##### `cluster_diagnostics_enabled`
  (boolean) Default: `false`
  
##### `cluster_diagnostics_addr`
  (string) Default: `'224.0.75.75'`

##### `cluster_diagnostics_port`
  (integer) Default `7500`

#### Cross-Origin Resource Sharing (CORS)
CORS needs to be enabled as otherwise Javascript OAuth clients will throw an XHR error
when attempting [XMLHttpRequest (XHR)](https://en.wikipedia.org/wiki/XMLHttpRequest).
Most of these settings should be left with default values.

##### `cors_allowedOrigins`
  (string)
  Comma-separated list of allowed origins for CORS. Default `*`

  You might want to constrain the allowed origins (if you can figure out what the right list should be).

##### `cors_allowedMethods`
  (string)
  Allowed HTTP methods for CORS. Default `GET,OPTIONS,POST`

  Deprecation: No longer applicable for PingFederate version >= 9.0
  
##### `cors_allowedHeaders`
  (string)
  Allowed HTTP headers for CORS. Default `X-Requested-With,Content-Type,Accept,Origin,Authorization`

  Deprecation: No longer applicable for PingFederate version >= 9.0

##### `cors_filter_mapping`
  (string)
  Allowed URL filter mappings for CORS. Default `/*`

  Deprecation: No longer applicable for PingFederate version >= 9.0

#### OGNL expressions
##### `ognl_expressions_enable`
  (boolean)
  Enable [OGNL](https://en.wikipedia.org/wiki/OGNL) scripting. Default `true`

#### Administration

##### `adm_user`
  (string) Initial administrator user. Default: `'Administrator'` (and seems to be required).

##### `adm_pass`
  (string) Administrator user's password. The `adm_pass` and `adm_hash`
  must match. Default: `'p@Ssw0rd'` 

##### `adm_hash`
  (string) Hash of administrator user's password. Must match the password. (*I don't
  currently know how to generate this, so make sure to copy it when you change
  the password*)

##### `adm_api_baseURL`
  (string) Base URL of the pf-admin-api.
  Default: `"https://${facts['fqdn']}:${admin_https_port}/pf-admin-api/v1"`

##### `service_api_baseURL`
  (string) Base URL for the various services. Set this to your load-balancer's URL.

  Default: `"https://${facts['fqdn']}:${https_port}"`
  
#### Native SAML2 IdP
These are the native SAML2 IdP settings used for native *console_authentication* and
*admin_api_authentication*. The *adm_user* and *adm_pass* are used for HTTP Basic Auth.

##### `saml2_local_entityID`
  (string)
  SAML 2 EntityID for the native local IdP (that provides the *adm_user* authentication).
  Default: `"${facts['hostname']}-ping:urn:saml2"`

##### `saml1_local_issuerID`
  (string)
  SAML 1 issuerID for the native local IdP.
  Default: `${facts['hostname']}-ping:urn:saml1`

##### `wsfed_local_realm`
  (string) Default: `"${facts['hostname']}-ping:urn:wsfed"`

##### `http_forwarded_for_header`
  (string) HTTP header identifying the IP address of the end-host when coming in via proxy.
  You should set these if using a load-balancer, otherwise the source IP address logged will
  be that of the load-balancer rather than the actual client.
  Default: undefined. Example: `X-Forwarded-For`

##### `http_forwarded_host_header`
  (string) HTTP header identifying the name of the end-host when coming in via proxy.
  Default: undefined. Example: `X-Forwarded-Host`

#### SAML 2.0 SP Configuration
  N.B. The current capability of this module is to configure PingFederate as an SP so as to
  federate a SAML 2.0 IdP for purposes of the OAuth 2.0 authorization code flow. 

##### Authentication Policy Contracts
  `auth_policy_contract` (Array[map]) List of authentication policy contracts with these map keys:

###### `name` (string)
###### `core_attrs` (Array[string])
###### `extd_attrs` (Array[string])

#### SAML 2.0 Partner IdP Configuration
  `saml2_idp`: (Array[map]) Multiple partner IdPs can be configure by this module. Each array item has multiple map keys:

##### `url`
  (string)
  URL for the SAML2 IDP. For example: `https://shibboleth.example.com`

##### `post`
  (string)
  URL-portion for the POST method. Concatenated to the `url`. Default: `idp/profile/SAML2/POST/SSO`

##### `redirect`
  (string)
  URL-portion for the redirect. Concatenated to the `url`. Default: `idp/profile/SAML2/Redirect/SSO`

##### `entityID`
  (string)
  Entity ID for the SAML2 IDP. For example: `urn:mace:incommon:example.com` or `https://shibboleth.example.com/idp/shibboleth`

##### `name`
  (string)
  User-friendly name for the IdP. Displayed in the authentication selector screen.

##### `metadata`
  (string)
  SAML2 partner's metadata URL.

##### `virtual`
  (Array[string])
  Lost of virtual server entityIDs for the PingFederate SP. Used to override `saml2_local_entityID`.
  For example: `columbia-ping-mfa:urn:saml2`. The first entityID in the list becomes the
  defaultVirtualEntityID. Default: `[]`

##### `contact`
  (map)
  Contact info for the IdP operator. Default: `{'firstName' => '', 'lastName' => '', 'email' => ''}`

##### `profiles`
  (Array[string])
  List of allowed SAML2 IdP profiles. Default: `['SP_INITIATED_SSO']`

##### `auth_policy_contract`
  (string)
  Name of the Authentication Policy Contract to use.

##### `id_mapping`
  (string)
  How IdP gets mapped (RTFM). Default: `'ACCOUNT_MAPPING'`

##### `core_attrs`
  (Array[string])
  List of core attributes. Default: `['SAML_SUBJECT']`

##### `extd_attrs`
  (Array[string])
  List of extended attributes. Default: `[]`

##### `attr_map`
  (Array[map])
  List of attribute mappings with keys _name_, _type_, _value_. Default: `[]`
  Example: 
  ```
  pingfederate::saml2_idp:
    - ...
      attr_map:
        - name: pingAffiliation
          type: EXPRESSION
          value: >-
            #result = #this.get(\"urn:oid:1.3.6.1.4.1.5923.1.1.1.1.9\"),
            #result = (#result? #result.toString() : \"\")
            .replace(\"[\", \"[\\\"\")
            .replace(\"]\", \"\\\"]\")
            .replace(\",\", \"\\\",\\\"\")
            .replace(\" \", \"\")
        - name: subject
          type: ASSERTION
          value: SAML_SUBJECT
  ```

##### `oauth_map`
  (Array[map])
  List of attribute mappings from SAML2 to Oauth with keys _name_, _type_, _value_. Default: `[]`
  Example:
  ```
  pingfederate::saml2_idp:
    - ...
      oauth_map:
        - name: USER_KEY
          type: ASSERTION
          value: SAML_SUBJECT
        - name: USER_NAME
          type: ASSERTION
          value: SAML_SUBJECT
  ```

##### `cert_file`
  (string)
  File path to IdP certificate. NOT IMPLEMENTED.

##### `cert_content`
  (string)
  String containing IdP certificate. Example:
  ```
  pingfederate::saml2_idp:
    - ...
      cert_content: |
        -----BEGIN CERTIFICATE-----
        MIIDRzCCAi+gAwIBAgIUAb+rsLUvjwiVA2iVgiHAFGrtCPgwDQYJKoZIhvcNAQEF
        BQAwIjEgMB4GA1UEAxMXc2hpYmJvbGV0aC5jb2x1bWJpYS5lZHUwHhcNMTMwODIy
        MTQ1MzUzWhcNMzMwODIyMTQ1MzUzWjAiMSAwHgYDVQQDExdzaGliYm9sZXRoLmNv
        ...
        -----END CERTIFICATE-----
  ```

##### `saml2_oauth_token_map`
  (Array[map])
  Mapping of OAuth attributes to fields in the access token(?). Example:
  ```
    - ...
      saml2_oauth_token_map:
        - name: username
          type: OAUTH_PERSISTENT_GRANT
          value: USER_KEY
        - name: group
          type: OAUTH_PERSISTENT_GRANT
          value: group
        - name: uid
          type: OAUTH_PERSISTENT_GRANT
          value: USER_KEY
  ```

#### OAuth JDBC configuration
To enable use of an external JDBC data store, set *oauth_jdbc_type* to a value (see below).
If it is `undef` then the default internal XML-based datastore will be used.

##### `oauth_jdbc_type`
  (string) Type of JDBC
  [OAuth Client Datastore](https://documentation.pingidentity.com/pingfederate/pf83/index.shtml#concept_definingOauthClientDataStore.html)
  connector. One of `undef`, `mysql`,`sqlserver`,`oracle`,`other`. Default: `undef`. If `other`, you'll need to fill in the following as well.
  Otherwise they default to expected values for the given *oauth_jdbc_type* but can still be used to override the defaults. 
  N.B. currently only fully implemented for `mysql`.

##### `oauth_jdbc_db`
  (string)
  JDBC database name (also found in `oauth_jdbc_url`)
  Default: `'pingfed'`

##### `oauth_jdbc_user`
  (string)
  JDBC user name.
  Default: `'pingfed'`

##### `oauth_jdbc_pass`
  (string)
  JDBC password.
  Default: `'pingfed'`

##### `oauth_jdbc_host`
  (string)
  JDBC database host.
  Default: `localhost`

##### `oauth_jdbc_port`
  (string)
  JDBC database port.
  Default: `3306`.

##### `oauth_jdbc_driver`
  (string)
  Name of the JDBC driver class.
  Default: `com.mysql.jdbc.Driver`

##### `oauth_jdbc_package_list`
  (string)
  JDBC connector and command-line interface (CLI) pacakge(s).
  Default: `['mysql','mysql-connector-java']`

##### `oauth_jdbc_package_ensure`
  (string)
  Ensure that the package is installed.
  Default: `'installed'`

##### `oauth_jdbc_jar_dir`
  (string)
  Directory where the JDBC jar file can be found.
  Default: `/usr/share/java`

##### `oauth_jdbc_jar`
  (string)
  Name of the jar file.
  Default: `mysql-connector-java.jar`

##### `oauth_jdbc_url`
  (string)
  JDBC URL.
  Default: `jdbc:mysql://<host>:<port>/<database>`

##### `oauth_jdbc_validate`
  (string)
  JDBC validation test.
  Default: `SELECT 1 from dual`

##### `oauth_jdbc_create_cmd`
  (string)
  Command to execute to create the database schema.
  Set based on the *oauth_jdbc_type*

##### `oauth_jdbc_client_ddl_cmd`
  (string)
  Command to execute to initialize the OAuth Client Manager database schema.
  Set based on the *oauth_jdbc_type*

##### `oauth_jdbc_access_ddl_cmd`
  (string)
  Command to execute to initialize the OAuth Access database schema.
  Set based on the *oauth_jdbc_type*

##### `acct_jdbc_linking_ddl_cmd`
  (string)
  Command to execute to initialize the Account Linking database schema.
  Set based on the *oauth_jdbc_type*

#### OAuth client manager
The OAuth client manager API is used to add OAuth clients to the PingFederate service.
(This capability is required for MuleSoft AnyPoint API Manager functionality, for example.)
You should override the user name and/or password when invoking the pingfederate class.

##### `oauth_client_mgr_user`
  (string)
  Oauth client manager user name. Default `clientmgr`
  (If you need to have more than one client manager user, you'll need to enhance this module
  to deal with that.)

##### `oauth_client_mgr_pass`
  (string)
  Oauth client manager user password. Default `ProviderP@55`
  Make sure the password you supply meets the minimum password requirements or you may see this:
  ```
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns: (422, '')
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns: {
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:   "validationErrors": [
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:     {
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:       "fieldPath": "configuration.tables[0].rows[0].fields[1].value",
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:       "message": "Password must contain at least 8 characters, at least 1 numeric character, at least 1 uppercase and 1 lowercase letter, at least 2 alphabetic characters.",
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:       "errorId": "plugin_validation_error"
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:     }
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:   ],
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:   "message": "Validation error(s) occurred. Please review the error(s) and address accordingly.",
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns:   "resultId": "validation_error"
Notice: /Stage[main]/Pingfederate::Server_settings/Exec[pf-admin-api POST ${pcv}]/returns: }
  ```
#### OAuth server settings
##### `oauth_svc_scopes`
  (array of hashes) Allowable OAuth scopes. Each hash has the following keys:
  - name: (string) scope name 
  - description: (string) descriptive text that is displayed to the user for authorization_code flow.
  Here's an example in a Hiera YAML file:

  ```yaml
  pingfederate::oauth_svc_scopes:
    - name: read
      description: Can read stuff
    - name: write
      description: Can write stuff
  ```

##### `oauth_svc_scope_groups`
  (array of hashes) Groupings of OAuth scopes. Each hash has the following keys:
  - name: (string) scope group name 
  - description: (string) descriptive text that is displayed to the user for authorization_code flow.
  - scopes: (array[string]) Names of scopes defined in `oauth_svc_scopes`.
  Here's an example in a Hiera YAML file:

  ```yaml
  pingfederate::oauth_svc_scope_groups:
    - name: readwrite
      description: Can read and write stuff
      scopes:
        - read
        - write
  ```

##### `oauth_svc_grant_core_attrs`
  (array[string])
  Oauth server persistent grant contract core attributes. Default: `['USER_KEY','USER_NAME']`

##### `oauth_svc_grant_extd_attrs`
  (array[string])
  Oauth server persistent grant contract extended attributes.

#### OAuth scope selectors
  Authentication scope selectors are used to match requested oauth scopes to select
  an authentication provider (e.g. which [social identity adapter](#social-identity-adapters)
  or [IdP connection](#saml-20-partner-idp-configuration) to use for the Authorization Code flow).

##### `oauth_scope_selectors`
  (Array[map]) with keys _adapter_, _type_ and _scopes_, where _adapter_ is an IdP Adapter or
  IdP Connection name, _type_ is one of `IDP_ADAPTER` or `IDP_CONNECTION` and
  _scopes_ is a list of one or more [previosuly defined oauth scopes](#oauth-server-settings)
  in `oauth_svc_scopes` and `oauth_svc_scope_groups` that must match to trigger the given Authentication
  Selector.
  Default: `[]` Example:
  ```
  pingfederate::oauth_scope_selectors:
	- adapter: facebook
	  type: IDP_ADAPTER
	  scopes:
		- auth-facebook
	- adapter: google
	  type: IDP_ADAPTER
	  scopes:
		- auth-google
	- adapter: Columbia University Dev
	  type: IDP_CONNECTION
	  scopes:
		- auth-columbia
  ```

##### `oauth_scope_fail_no_selection`
  (boolean)
  Fail to login if no `oauth_scope_selector` was selected. If `false` an menu of available authentication
  options is presented to the user. If `false` no menu is presented. Default: `false`

#### OAuth Access Token Managers
##### `oauth_svc_acc_tok_mgr_id`
  (string)
  ID of the access token manager. No default.

##### `oauth_svc_acc_tok_mgr_core_attrs`
  (array[string])
  List of core attributes.
  No default.

##### `oauth_svc_acc_tok_mgr_extd_attrs`
  (array[string])
  List of extended attributes.
  No default.

#### OAuth OpenID Connect Policy Contracts
##### `oauth_oidc_policy_id`
  (string)
  The ID of the policy. No default.

##### `oauth_oidc_id_userinfo`
  (boolean)
  `true` to include `userinfo` in `id_token`. Default: `false`

##### `oauth_oidc_policy_core_map`
  (array of hashes) Mappings from token manager core attributes to OpenID Connect attributes.
  Each hash has the following keys:
  - name: Name of the source
  - type: type of the source: TOKEN or one of the other SourceTypeIdKey like TEXT, EXPRESSION and so on.
  - value: Name of the attribute
  Default: `[{name => 'sub', type => 'TOKEN', value =>'sub'}]`

##### `oauth_oidc_policy_extd_map`
  (array of hashes) Mappings from token manager core attributes to OpenID Connect attributes.
  Default: `[]`. Here's an example:
  ```
  ...
  oauth_oidc_policy_extd_map       => [{'name' => 'group', 'type' => 'TOKEN', 'value' => 'group'}],
  ...
  ```

##### `oauth_authn_policy_map`
  OAuth Authentication policy contract mappings. Default `[]`. Example:
  ```
  ...
  oauth_authn_policy_map           => [{'name' => 'USER_KEY', 'type' => 'AUTHENTICATION_POLICY_CONTRACT', 'value' => 'subject'},
                                       {'name' => 'USER_NAME', 'type' => 'AUTHENTICATION_POLICY_CONTRACT', 'value' => 'subject'},
                                       {'name' => 'group', 'type' => 'AUTHENTICATION_POLICY_CONTRACT', 'value' => 'affiliation'},
                                       ],
  ...
  ```

#### `social_adapter`
  (Map of maps) Social identity adapters have the following map keys.
  Example:
  ```
pingfederate::social_adapter:
  facebook:
    enable: true
    package_ensure: 1.3.2-5.el6
    app_id: 98765432112345
    app_secret: xxf2b942ebb849f7abc629576bfe8
    oauth_token_map:
      - name: username
        type: ADAPTER
        value: name
      - name: group
        type: TEXT
        value: facebook
      - name: uid
        type: ADAPTER
        value: id
    oauth_idp_map:
      - name: USER_KEY
        type: ADAPTER
        value: id
      - name: USER_NAME
        type: ADAPTER
        value: name
      - name: group
        type: TEXT
        value: facebook
   ```
###### key
  (string)
  Name of the adapter. One of: facebook, google, twitter, linkedin, windowslive.

###### `enable`
  (boolean)
  Set to true to enable the CIC adapter. Default: `false`

###### `package_list`
  (array[string])
  Name of package(s) that contains the adapter.
  Default: `'pingfederate-<name>-adapter'`
  
###### `package_ensure`
  (string)
  Ensure that the package is installed.
  Default: `'installed'`

###### `app_id`
  (string)
  application key or ID.

###### `app_secret`
  (string)
  Application secret.

###### `oauth_token_map`
  (Map) Mapping of attributes to oauth token attributes consisting of `name`,`type`,`value` triples.
  `type` is one of ADAPTER, TEXT, EXPRESSION, ...

###### `oauth_idp_map`
  (Map) Mapping of attributes to idp attributes consisting of `name`,`type`,`value` triples.
  `type` is one of ADAPTER, TEXT, EXPRESSION, ...

#### OAuth Clients
##### `oauth_client_default`
  (Map) Default values for each OAuth client. These values get overriden by the individual client
  definitions with these defaults (which you can override as you see fit):
  ```
pingfederate::oauth_client_default:
  redirectUris: []
  grantTypes: []
  name: ''
  description: ''
  logoUrl: ''
  validateUsingAllEligibleAtms: false
  refreshRolling: SERVER_DEFAULT
  persistentGrantExpirationType: SERVER_DEFAULT
  persistentGrantExpirationTime: 0
  persistentGrantExpirationTimeUnit: DAYS
  bypassApprovalPage: true
  restrictScopes: true
  restrictedScopes: []
  oidcPolicy:
    grantAccessSessionRevocationApi: false
    pingAccessLogoutCapable: false
    logoutUris: []
  clientAuth:
    type: SECRET
    secret: ''
    clientCertIssuerDn: ''
    clientCertSubjectDn: ''
  ```

##### `oauth_client`
  (Map of maps) for each OAuth client, keyed by a unique client identifier.
  See the `oauth_client_default` description for details.

  Example:
  ```
  demo_trusted_client:
    name: demo_trusted_client
    description: training demo trusted auth-none or auth-columbia client
    grantTypes:
      - IMPLICIT
      - AUTHORIZATION_CODE
      - CLIENT_CREDENTIALS
      - REFRESH_TOKEN
    bypassApprovalPage: false
    redirectUris:
      - http://localhost:5432/oauth2client
      - https://www.getpostman.com/oauth2/callback
    restrictedScopes:
      - auth-none
      - auth-columbia
      - demo-netphone-admin
      - create
      - read
      - update
      - delete
      - openid
      - profile
      - email
    clientAuth:
      type: SECRET
      secret: 73a7176Ab322549FCBEF46554d3381d5
  ```

## Limitations

### Operating System Support

This has only been tested on EL 6 with Java 1.8. It might work elsewhere. Let me know!

### Known Issues

Changes to certain configuration variables after an initial Puppet run 
do not properly get reflected in the PingFederate server state. The best way
to resolve these is to wipe PingFederate off the system and re-run Puppet:
```
$ sudo service pingfederate stop
$ sudo yum -y erase pingfederate-server
$ sudo rm -rf /opt/pingfederate*
$ sudo puppet agent -t ...
```

Known issues include:
- Changing `pingfederate::service_api_baseURL` does not properly remove references to the old URL.
- Setting a social media adapter like `pingfederate::facebook_adapter: true` and then setting it
`false` fails to properly remove the adapter references.
- A failed JDBC connection at initial configuration (e.g. database not running or no permission)
will not get fixed later, even if the database access is fixed.
- If you set some `pingfederate::log_levels` and then remove them, the last settings remain;
original values are not restored.
- Facebook adapter 2.x configuration is broken.

## Development

The package was built to use PingFederate as an OAuth2 Server with SAML and social identity federation for the
authorization code flow. PingFederate has many other features which are not yet configured here. 

Please fork and submit PRs on [github](https://github.com/n2ygk/puppet-pingfederate) as you add
fixes and features.

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

### Invoking the administrative REST API (pf-admin-api)
Most configuration is done via the
[PingFederate Administrative API](https://documentation.pingidentity.com/pingfederate/pf83/index.shtml#adminGuide/concept/pingFederateAdministrativeApi.html).

Unfortunately, one key configuration is done by editing XML files, using data returned from the API call. For example,
the process for adding a mysql data store for oauth client management consists of:

1. Install the appropriate JDBC connector jar file in `<pf-install>/server/default/lib`.

1. `POST https://localhost:9999/pf-admin-api/v1/dataStores` with a JSON map to configure the JDBC connector.

1. Edit `<pf-install>/server/default/conf/META-INF/hivemodule.xml` to enable the JDBC implementation.

1. Edit `<pf-install>server/default/data/config-store/org.sourceid.oauth20.domain.ClientManagerJdbcImpl.xml` to include the JNDI-name that was
returned by the POST.

#### pf-admin-api idempotent REST API client
[pf-admin-api.erb](templates/pf-admin-api.erb) is a templated Python script which invokes the REST API.
The script is templated to embed the default name of "this" server's configuration file as a default value.

Input data for POSTs done by pf-admin-api are also templated. Installing the JSON file is the trigger 
to Execing the pf-admin-api script. The script waits for the server to come up so can be used as 'waiter'
when the service has to be restarted, which unfortunately is necessary at a point in the 
configuration process (configuring the JDBC connector).

```
Usage: pf-admin-api [options] resource

Options:
  -h, --help            show this help message and exit
  -c CONFIG, --config=CONFIG
                        Name of configuration file [default:
                        /opt/pingfederate/local/etc/pf-admin-cfg.json]
  -m METHOD, --method=METHOD
                        HTTP method, one of GET,PUT,POST,PATCH,DELETE
                        [default: GET]
  -j JSON, --json=JSON  JSON file to POST
  -i ID, --id=ID        write resource id to file [default: none]
  -k IDKEY, --idkey=IDKEY
                        resource id primary key [default: id]
  -r RESPONSE, --response=RESPONSE
                        write succesful JSON response to file [default: -]
  -s SUBST, --subst=SUBST
                        --subst key=filename. Substitutes the given @@key@@
                        in the JSON document with the content of the named file.
                        May be repeated to substitute multple keys.
  --timeout=TIMEOUT     Seconds before timeout [default: 10]
  --retries=RETRIES     Number of retries [default: 5]
  --verify              verify SSL/TLS server certificate [default: False]
```

Here's an example of GET of the server version:

```bash
$ sudo /opt/pingfederate/local/bin/pf-admin-api version
(200, 'OK')
{
  "version": "8.2.2.0"
}
```

This shows up in the Puppet log as:

```
Notice: /Stage[main]/Pingfederate::Admin/Exec[pf-admin-api version]/returns: (200, 'OK')
Notice: /Stage[main]/Pingfederate::Admin/Exec[pf-admin-api version]/returns:   "version": "8.2.2.0"
Notice: /Stage[main]/Pingfederate::Admin/Exec[pf-admin-api version]/returns: executed successfully
```

And here's an idempotent POST. In this example, the POST had previously happened so it gets changed to a PUT
just in case there are some changed values in `dataStores.json`. This presupposes that `dataStores.json.out`
is present since it contains the *id* that was assigned by the initial POST. (A future improvement might be
to GET the collection and find the right *id*.)

```bash
$ sudo /opt/pingfederate/local/bin/pf-admin-api -m POST -j /opt/pingfederate/local/etc/dataStores.json -r /opt/pingfederate/local/etc/dataStores.json.out dataStores
Resource exists. Changing POST to PUT.
(200, 'OK')
```

This is just an example of GET of the dataStores collection:
```bash
$ sudo /opt/pingfederate/local/bin/pf-admin-api dataStores 
(200, 'OK')
{
  "items": [
    {
      "userName": "sa", 
      "encryptedPassword": "eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoia2RDODV1YnZhRyIsInZlcnNpb24iOiI4LjIuMi4wIn0..9PlaJ2A0UNIA-j2_k_e3yA.KgxQfRAnMxxxAiFKUrf-2Q.6DtxtZP15T_0fjVozcxNRw", 
      "connectionUrl": "jdbc:hsqldb:${pf.server.data.dir}${/}hypersonic${/}ProvisionerDefaultDB;hsqldb.lock_file=false", 
      "allowMultiValueAttributes": false, 
      "driverClass": "org.hsqldb.jdbcDriver", 
      "maskAttributeValues": false, 
      "type": "JDBC", 
      "id": "ProvisionerDS"
    }, 
    {
      "userName": "pingfed", 
      "encryptedPassword": "eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoia2RDODV1YnZhRyIsInZlcnNpb24iOiI4LjIuMi4wIn0..wsr556B1qLMDo5s7g_3oTw.OPGaQh0bsC6zzzCQBicVvQ.HHqz9Ad7mswBRE3J1IEFyg", 
      "connectionUrl": "jdbc:mysql://localhost/pingfed?autoReconnect=true", 
      "allowMultiValueAttributes": true, 
      "driverClass": "com.mysql.jdbc.Driver", 
      "maskAttributeValues": false, 
      "type": "JDBC", 
      "id": "JDBC-282B7303FBE88768437753B22951A424E7F12068", 
      "validateConnectionSql": "SELECT 1 from dual"
    }
  ]
}
```

And, if you want to use the script to use the admin API of a different PingFederate server, simply
create a configuration file:
```
$ cat pf.json
{
  "description": "configuration file for /opt/pingfederate/local/bin/pf-admin-api",
  "baseURL": "https://oauth.example.com:9999/pf-admin-api/v1",
  "user": "Administrator",
  "pass": "password123"
}
$ /opt/pingfederate/local/bin/pf-admin-api -c pf.json version
(200, 'OK')
{
  "version": "8.2.2.0"
}
```

Note that the --id file is useful with the `concat` module to concatenate IDs
into templated JSON or XML fragments.


#### oauth_jdbc_augeas script
[This](templates/oauth_jdbc_augeas.erb) script edits the XML files in an Exec notified by the API call rather
than having Puppet manage them. This is ugly but the only way to make it happen in one unit of work. (It's really the
fault of the app for not having a clean set of APIs that do everything.) It's kinda ugly, using augeas three times:
1. pulls the jndi-name out of the API result file created by pf-admin-api.
2. Edits several files in `<pf_install_dir>server/default/data/config-store`.

There's also an `oauth_jdbc_revert_augeas` script that reverts back to the built-in non-JDBC datastore.
