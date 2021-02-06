# pingfederate
## Description

This module installs and configures the
[PingFederate](https://www.pingidentity.com/en/products/pingfederate.html) server using
Puppet instead of the more typical interactive shell-script approach.

## Compatibility

This module has only been tested with Puppet 4.

This module has been tested with PingFederate 8.x - 9.1 and related social adapters (in progress).

## Table of Contents

<!-- TOC generated with: `markdown-toc --maxdepth 4 -i README.md` -->

<!-- toc -->

- [Setup](#setup)
  * [Beginning with pingfederate](#beginning-with-pingfederate)
- [Usage](#usage)
  * [Basic Usage](#basic-usage)
    + [with RPMS available](#with-rpms-available)
    + [without RPMS](#without-rpms)
  * [Puppet Module Configuration](#puppet-module-configuration)
    + [Packages](#packages)
    + [Service](#service)
    + [Logging](#logging)
    + [Jetty web server settings](#jetty-web-server-settings)
    + [Providing the License Key](#providing-the-license-key)
    + [Run.properties](#runproperties)
    + [Cross-Origin Resource Sharing (CORS)](#cross-origin-resource-sharing-cors)
    + [OGNL expressions](#ognl-expressions)
    + [Administration](#administration)
    + [Server SSL/TLS Certificate](#server-ssltls-certificate)
    + [Native SAML2 IdP](#native-saml2-idp)
    + [SAML 2.0 SP Configuration](#saml-20-sp-configuration)
    + [SAML 2.0 Partner IdP Configuration](#saml-20-partner-idp-configuration)
    + [OAuth JDBC configuration](#oauth-jdbc-configuration)
    + [OAuth client manager](#oauth-client-manager)
    + [OAuth server settings](#oauth-server-settings)
    + [OAuth returned scope](#oauth-returned-scope)
    + [OAuth scope selectors](#oauth-scope-selectors)
    + [OAuth Access Token Manager](#oauth-access-token-manager)
    + [OAuth OpenID Connect Policy Contract](#oauth-openid-connect-policy-contract)
    + [Social Identity Adapters](#social-identity-adapters)
    + [OAuth Clients](#oauth-clients)
- [Limitations](#limitations)
  * [Operating System Support](#operating-system-support)
  * [Known Issues](#known-issues)
- [Development](#development)
  * [git clone to make puppet-lint happy](#git-clone-to-make-puppet-lint-happy)
  * [Using Augeas to edit XML configuration files](#using-augeas-to-edit-xml-configuration-files)
  * [Invoking the administrative REST API (pf-admin-api)](#invoking-the-administrative-rest-api-pf-admin-api)
    + [oauth_jdbc_augeas script](#oauth_jdbc_augeas-script)
  * [TODO List](#todo-list)

<!-- tocstop -->

## Setup

### Beginning with pingfederate

PingFederate is a big, complex package with lots of configuration. The intent of this Puppet module is to
make it easier to automate installing and configuring the server, eliminating what are otheriwse a number of
manual steps.

## Usage

The module installs PingFederate, performs basic static configuration of the
server, that is, things that are changed prior to starting it up, and post-startup administration.
The static configuration includes the `run.properties` and various configuration XML files, 
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

### Puppet Module Configuration
Using most of the defaults will just work to get the basic server installed and running.
However, it will not do a heck of a lot. You'll need to set a number of the following parameters.

#### Packages
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

#### Jetty web server settings

There are a small number of web server settings that may need to be changed from the defaults.
Currently there are only these two which are used to
[configure form content limits](https://www.eclipse.org/jetty/documentation/current/configuring-form-size.html):

##### `jetty_max_form_content_size`
  (Integer)

  Sets the max form size. This is used to resolve the [form too large error](https://support.pingidentity.com/s/article/Form-too-large-error-in-server-log).

  Default: 1000000

  Example:
  ```
  pingfederate::jetty_max_form_content_size: 5000000
  ```

##### `jetty_max_form_keys`
  (Integer)

  Sets the [max form keys]. This is used to resolve the
  [maxFormKeys limit exceeded error](https://support.pingidentity.com/s/article/Admin-UI-with-many-elements-can-yield-maxFormKeys-limit-exceeded-keys-1000).

  Default: 20000

  Example:
  ```
  pingfederate::jetty_max_form_keys: 50000
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
[PingFederate documentation](https://documentation.pingidentity.com/pingfederate/pf/index.shtml#adminGuide/concept/changingConfigurationParameters.html)
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

##### `cors_allowedorigins`
  (string)
  Comma-separated list of allowed origins for CORS. Default `*`

  You might want to constrain the allowed origins (if you can figure out what the right list should be).

##### `cors_allowedmethods`
  (string)
  Allowed HTTP methods for CORS. Default `GET,OPTIONS,POST`

  Deprecation: No longer applicable for PingFederate version >= 9.0
  
##### `cors_allowedheaders`
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

##### `adm_api_baseurl`
  (string) Base URL of the pf-admin-api.
  Default: `"https://${facts['fqdn']}:${admin_https_port}/pf-admin-api/v1"`

##### `service_api_baseurl`
  (string) Base URL for the various services. Set this to your load-balancer's URL.

  Default: `"https://${facts['fqdn']}:${https_port}"`
  
#### Server SSL/TLS Certificate
Use these settings to import a server SSL certificate (optionally signed by a chain of CAs).
You can use `openssl` to create these certs and CSRs but make sure to use the
same `ssl_cert_passphrase`.

TODO: document with full openssl examples.

##### `ssl_cert_passphrase`
  (string)
  The passphrase used to protect the private key.
  ```
  pingfederate::ssl_cert_passphrase: ThePassword
  ```

##### `ssl_cert_content`
  (string)
  Base 64 encoded string containing PKCS12 TLS certificate. Example:
  ```
  pingfederate::ssl_cert_content: |
    MIIKPwIBAzCCCfgGCSqGSIb3DQEHAaCCCekEggnlMIIJ4TCCBWUGCSqGSIb3DQEHAaCCBVYEggVS
    MIIFTjCCBUoGCyqGSIb3DQEMCgECoIIE+zCCBPcwKQYKKoZIhvcNAQwBAzAbBBQWj4ebhqdFy6yp
    ...
    AgMBhqA=
  ```

  Produce this string like this and then insert it into your YAML.
  ```
  $ base64 -b 76 170D457373C.p12 | sed -e 's/^/  /'
  ```

##### `ssl_cert_csr_content`
  (string)
  PEM encoded string containing signed cert with CA chain.
  ```
  pingfederate::ssl_cert_csr_content: |
    -----BEGIN CERTIFICATE-----
    MIIENjCCAx6gAwIBAgIBATANBgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJTRTEUMBIGA1UEChML
    QWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRydXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYD
    ...
    -----END CERTIFICATE-----
  ```

  This file is provided by your CA as a Certificate (w/ chain), PEM encoded.

  Produce this string like this and then insert it into your YAML:
  ```
  sed -e 's/^/  /' pem_encoded.cer
  ```

#### Native SAML2 IdP
These are the native SAML2 IdP settings used for native *console_authentication* and
*admin_api_authentication*. The *adm_user* and *adm_pass* are used for HTTP Basic Auth.

##### `saml2_local_entityid`
  (string)
  SAML 2 EntityID for the native local IdP (that provides the *adm_user* authentication).
  Default: `"${facts['hostname']}-ping:urn:saml2"`

##### `saml1_local_issuerid`
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
  Lost of virtual server entityIDs for the PingFederate SP. Used to override `saml2_local_entityid`.
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
  [OAuth Client Datastore](https://documentation.pingidentity.com/pingfederate/pf/index.shtml#concept_definingOauthClientDataStore.html)
  connector. One of `undef`, `mysql`,`sqlserver`,`oracle`,`other`. Default: `undef`. If `other`, you'll need to fill in the following as well.
  Otherwise they default to expected values for the given *oauth_jdbc_type* but can still be used to override the defaults. 
  N.B. currently only fully implemented for `mysql` and `sqlserver`.

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
  Default: Set based on the *oauth_jdbc_type*
  - mysql: `com.mysql.jdbc.Driver`
  - sqlserver: `com.microsoft.sqlserver.jdbc.SQLServerDriver`

##### `oauth_jdbc_package_list`
  (string)
  JDBC connector and command-line interface (CLI) pacakge(s). See also [`oauth_jdbc_maven`](#oauth_jdbc_maven)
  and [`oauth_jdbc_nexus`](#oauth_jdbc_nexus) for alternative ways to find the JDBC connector JAR.
  Default: Set based on the *oauth_jdbc_type*
  - mysql: `['mysql','mysql-connector-java']`
  - sqlserver: none

##### `oauth_jdbc_package_ensure`
  (string)
  Ensure that the package is installed.
  Default: `'installed'`

##### `oauth_jdbc_nexus`
  (map)
  Identifies the nexus repo that contains the JDBC connector (when it's not available as a package).
  Has three keys that roughly correspond to those used by `archive::nexus`: `url`, `repo` and `gav`
  (groupId:appId:version). Default: none.

  Example:
  ```
          use_v3 => true,
          url    => 'https://user:pass@nexus.example.com/
          repo   => 'central',
          gav    => 'com.microsoft.sqlserver:mssql-jdbc:7.0.0.jre8',
  ```

##### `oauth_jdbc_maven`
  (string)
  Identifies the maven URL for the JDBC connector (when it's not available as a package or in nexus).

  Default: Set based on the *oauth_jdbc_type*
  - mysql: `http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.12/mysql-connector-java-8.0.12.jar`
  - sqlserver: `http://central.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/7.0.0.jre8/mssql-jdbc-7.0.0.jre8.jar`

##### `oauth_jdbc_jar_dir`
  (string)
  Directory where the JDBC jar file can be found after being installed from a package or JAR repo.
  Default: `/usr/share/java`

##### `oauth_jdbc_jar`
  (string)
  Name of the jar file.
  Default: Set based on the *oauth_jdbc_type*
  - mysql: `mysql-connector-java.jar`
  - sqlserver: `mssql-jdbc-7.0.0.jre8.jar`

##### `oauth_jdbc_url`
  (string)
  JDBC URL.

  Default: 
  - mysql: `jdbc:mysql://<host>:<port>/<database>?autoReconnect=true`
  - sqlserver: `jdbc:sqlserver://<host>:<port>;databaseName=<database>`

##### `oauth_jdbc_validate`
  (string)
  JDBC validation test. Set based on the *oauth_jdbc_type*.

  Default: 
  - mysql: `SELECT 1 from dual`
  - sqlserver: `SELECT getdate()`
  
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
#### OAuth client settings
##### `oauth_client_metadata`
  (array of hashes) OAuth Client Metadata. Each hash has the following keys:
  - parameter: (string) The metadata name.
  - description: (string) The metadata description.
  - multiValued: (boolean) If the field should allow multiple values.

##### `oauth_dynamic_cient_registration`
  (map) OAuth Dynamic Client Registration (RFC 7691) settings. (These are directly mapped to the API parameters).
  - initialAccessTokenScope: (string): Access Token scope required to allow dynamic client registration.
  - restrictCommonScopes: (boolean) Restrict common scopes.
  - restrictedCommonScopes: (array[string]): The common scopes to restrict.
  - allowedExclusiveScopes (array[string]): The exclusive scopes to allow.
  - requestPolicyRef: (link) The CIBA request policy.
  - enforceReplayPrevention: (boolean) Enforce replay prevention.
  - requireSignedRequests: (boolean) Require signed requests.
  - defaultAccessTokenManagerRef: (link) The default access token manager for this client.
  - persistentGrantExpirationType: (string) `INDEFINITE_EXPIRY` or `SERVER_DEFAULT` or `OVERRIDE_SERVER_DEFAULT`. Defaults to `SERVER_DEFAULT`.
  - persistentGrantExpirationTime: (integer) The persistent grant expiration time.
  - persistentGrantExpirationTimeUnit: (strng) = `MINUTES` or `DAYS` or `HOURS`. The persistent grant expiration time unit.
  - persistentGrantIdleTimeoutType: (string) `INDEFINITE_EXPIRY` or `SERVER_DEFAULT` or `OVERRIDE_SERVER_DEFAULT`. Defaults to `SERVER_DEFAULT`.
  - persistentGrantIdleTimeout: (integer) The persistent grant idle timeout.
  - persistentGrantIdleTimeoutTimeUnit:(string) `MINUTES` or `DAYS` or `HOURS`
  - clientCertIssuerType: (string) = `NONE` or `TRUST_ANY` or `CERTIFICATE`
  - clientCertIssuerRef: (link): Client TLS Certificate Issuer DN.
  - refreshRolling: (string) = `SERVER_DEFAULT` or `DONT_ROLL` or `ROLL`. Defaults to `SERVER_DEFAULT`.
  - oidcPolicy: (string): Open ID Connect Policy settings.
  - policyRefs: (array[link]) The client registration policies.
  - deviceFlowSettingType: (string) `SERVER_DEFAULT` or `OVERRIDE_SERVER_DEFAULT`
  - userAuthorizationUrlOverride: (string): The URL is used as `verification_url` and `verification_url_complete` values in a device flow authorization request.
  - pendingAuthorizationTimeoutOverride: (integer) The `device_code` and `user_code` timeout, in seconds.
  - devicePollingIntervalOverride: (integer) The amount of time client should wait between polling requests, in seconds.
  - bypassActivationCodeConfirmationOverride: (boolean) Indicates if the Activation Code Confirmation page should be bypassed if `verification_url_complete` is used by the end user to authorize a device.
  - requireProofKeyForCodeExchange: (boolean) Determines whether Proof Key for Code Exchange (PKCE) is required for the dynamically created client.
  - cibaPollingInterval: (integer) The minimum amount of time in seconds that the Client must wait between polling requests to the token endpoint. The default is 3 seconds.
  - cibaRequireSignedRequests: (boolean) Determines whether CIBA signed requests are required for this client.

  Here's an example in a Hiera YAML file:

  ```yaml
  pingfederate::oauth_dynamic_client_registration:
	allowedExclusiveScopes: []
	cibaPollingInterval: 3
	cibaRequireSignedRequests: false
	clientCertIssuerType: NONE
	deviceFlowSettingType: SERVER_DEFAULT
	enforceReplayPrevention: false
	initialAccessTokenScope: dyn-client
	persistentGrantExpirationType: SERVER_DEFAULT
	persistentGrantIdleTimeoutType: SERVER_DEFAULT
	policyRefs: []
	refreshRolling: SERVER_DEFAULT
	requireProofKeyForCodeExchange: false
	requireSignedRequests: false
	restrictCommonScopes: true
	restrictedCommonScopes:
	- address
	- create
	- delete
	- email
	- openid
	- profile
	- read
	- update
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

#### OAuth returned scope
The response `scope` for an Access Token request per
[RFC 6749 section 4.1](https://tools.ietf.org/html/rfc6749#section-5.1)
is "OPTIONAL, if identical to the scope requested by the client; otherwise, REQUIRED."

##### `oauth_return_scope_always`
  (boolean)
  Set to `true` to always return the granted scopes in the response, even if identical.
  Default: `false` Example:
  ```
  pingfederate::oauth_return_scope_always: true
  ```
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

#### OAuth Access Token Manager
Currently only a single Access Token Manager may be configured. If you need more, please [submit a PR](#development)!

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

#### OAuth OpenID Connect Policy Contract
Currently only a single OIDC Policy Contract may be configured. If you need more, please please [submit a PR](#development)!

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

##### `oauth_oidc_policy_scope_attr_map`
  (hash of hashes)(PingFederate version 9+ only) Mappings of OpenID scopes to claims returned for those scopes.
  Default: `{}`. In PF versions before 9, mappings are fixed per the
  [OpenID connect](http://openid.net/specs/openid-connect-core-1_0.html#ScopeClaims) standard (for profile, address,
  phone, and email scopes). Here's an example:
  ```
  oauth_oidc_policy_scope_attr_map  => {
     'profile' => ['given_name', 'family_name', 'name'],
     'email'   => ['email'],
     'address' => ['address'],
	 'https://apis.example.com/scope/group' => ['https://apis.example.com/claim/group'], # a custom claim and scope to select it
  },
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

#### Social Identity Adapters
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
  jwksSettings:
    jwks: ''
    jwksUrl: ''
  clientAuth:
    type: SECRET
    secret: ''
    clientCertIssuerDn: ''
    clientCertSubjectDn: ''
    enforceReplayPrevention: false
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

###### `clientAuth` types
`clientAuth` type can be one of 'NONE', 'SECRET', 'CERTIFICATE', or 'PRIVATE_KEY_JWT'.

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
- Changing `pingfederate::service_api_baseurl` does not properly remove references to the old URL.
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

### git clone to make puppet-lint happy

`puppet-lint`
[changed](https://ask.puppet.com/question/35269/is-puppet-lint-busted-with-respect-to-autoload-module-layout/)
to *require* the containing directory name to be `pingfederate` even though that's not the name of the repo.
Make sure to clone like this or puppet-lint will complain:

```
git clone git@github.com:n2ygk/puppet-pingfederate.git pingfederate
cd pingfederate
```

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
[PingFederate Administrative API](https://documentation.pingidentity.com/pingfederate/pf/index.shtml#adminGuide/pingFederateAdministrativeApi.html).

Unfortunately, one key configuration is done by editing XML files, using data returned from the API call. For example,
the process for adding a mysql data store for oauth client management consists of:

1. Install the appropriate JDBC connector jar file in `<pf-install>/server/default/lib`.

1. `POST https://localhost:9999/pf-admin-api/v1/dataStores` with a JSON map to configure the JDBC connector.

1. Edit `<pf-install>/server/default/conf/META-INF/hivemodule.xml` to enable the JDBC implementation.

1. Edit `<pf-install>server/default/data/config-store/org.sourceid.oauth20.domain.ClientManagerJdbcImpl.xml` to include the JNDI-name that was
returned by the POST.

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

If an API call returns an error (response status >= 400) then the input json file
(e.g. `oauth_clients_demo_client.json`) will be renamed with a `.fail` extension
(e.g. `oauth_clients_demo_client.json.fail`). This will help trigger a subsequent
Puppet run (after what cause the error has been resolved).

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

### TODO List

- Allow for multiple Access Token Managers
  - Configure for different token lifetimes.
  - Generally fix all instances of singleton configurations to allow for multiples.
- Support Puppet 5+
