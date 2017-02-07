# Notes on automating configuration.

## Initial installation settings
### run.properties
Initial settings.
Just a straightforward edit of /opt/pingfederate/bin/run.properties

## What changes
### Diff between initial install and puppet config
```
[root@localhost opt]# diff -rb pingfederate-unconf pingfederate-conf1 |egrep ^diff\|Only
Only in pingfederate-conf1/pingfederate/bin: pingfederate.pid
diff -rb pingfederate-unconf/pingfederate/bin/run.properties pingfederate-conf1/pingfederate/bin/run.properties
Only in pingfederate-conf1/pingfederate: log
Only in pingfederate-conf1/pingfederate/server/default/conf: pingfederate.lic
Only in pingfederate-conf1/pingfederate/server/default/data/config-store: com.pingidentity.crypto.jwk.MasterKeySet.xml
Only in pingfederate-conf1/pingfederate/server/default/data/config-store: com.pingidentity.page.Login.xml
Only in pingfederate-conf1/pingfederate/server/default/data/config-store: InternalState.xml
Only in pingfederate-conf1/pingfederate/server/default/data/config-store: org.sourceid.common.InternalStateManager.xml
diff -rb pingfederate-unconf/pingfederate/server/default/data/config-store/org.sourceid.config.CoreConfig.xml pingfederate-conf1/pingfederate/server/default/data/config-store/org.sourceid.config.CoreConfig.xml
diff -rb pingfederate-unconf/pingfederate/server/default/data/config-store/org.sourceid.saml20.domain.mgmt.impl.SslServerPkCertManagerImpl.xml pingfederate-conf1/pingfederate/server/default/data/config-store/org.sourceid.saml20.domain.mgmt.impl.SslServerPkCertManagerImpl.xml
Only in pingfederate-conf1/pingfederate/server/default/data/config-store: org.sourceid.util.license.Data.xml
Only in pingfederate-conf1/pingfederate/server/default/data/module: provisioner-notify.txt
Only in pingfederate-conf1/pingfederate/server/default/data: pf.jwk
diff -rb pingfederate-unconf/pingfederate/server/default/data/pingfederate-admin-user.xml pingfederate-conf1/pingfederate/server/default/data/pingfederate-admin-user.xml
Only in pingfederate-conf1/pingfederate/server/default/data: ping-ssl-client-trust-cas.jks
Only in pingfederate-conf1/pingfederate/server/default/data: ping-ssl-server.jks
Only in pingfederate-conf1/pingfederate/server/default: tmp
Only in pingfederate-conf1/pingfederate: work
```

### After walking through the configuration pages

```
[root@localhost opt]# diff -rb pingfederate-conf[12] | egrep ^diff\|Only
diff -rb pingfederate-conf1/pingfederate/log/2016_12_09.request2.log pingfederate-conf2/pingfederate/log/2016_12_09.request2.log
diff -rb pingfederate-conf1/pingfederate/log/admin.log pingfederate-conf2/pingfederate/log/admin.log
diff -rb pingfederate-conf1/pingfederate/log/init.log pingfederate-conf2/pingfederate/log/init.log
diff -rb pingfederate-conf1/pingfederate/log/provisioner.log pingfederate-conf2/pingfederate/log/provisioner.log
diff -rb pingfederate-conf1/pingfederate/log/server.log pingfederate-conf2/pingfederate/log/server.log
diff -rb pingfederate-conf1/pingfederate/server/default/data/config-store/com.pingidentity.page.Login.xml pingfederate-conf2/pingfederate/server/default/data/config-store/com.pingidentity.page.Login.xml
diff -rb pingfederate-conf1/pingfederate/server/default/data/config-store/InternalState.xml pingfederate-conf2/pingfederate/server/default/data/config-store/InternalState.xml
diff -rb pingfederate-conf1/pingfederate/server/default/data/config-store/org.sourceid.common.InternalStateManager.xml pingfederate-conf2/pingfederate/server/default/data/config-store/org.sourceid.common.InternalStateManager.xml
diff -rb pingfederate-conf1/pingfederate/server/default/data/config-store/org.sourceid.config.CoreConfig.xml pingfederate-conf2/pingfederate/server/default/data/config-store/org.sourceid.config.CoreConfig.xml
diff -rb pingfederate-conf1/pingfederate/server/default/data/config-store/org.sourceid.saml20.domain.mgmt.impl.SslServerPkCertManagerImpl.xml pingfederate-conf2/pingfederate/server/default/data/config-store/org.sourceid.saml20.domain.mgmt.impl.SslServerPkCertManagerImpl.xml
Only in pingfederate-conf2/pingfederate/server/default/data/local: p1-conn-factory-local-state.xml
diff -rb pingfederate-conf1/pingfederate/server/default/data/module/saas-provisioner.xml pingfederate-conf2/pingfederate/server/default/data/module/saas-provisioner.xml
diff -rb pingfederate-conf1/pingfederate/server/default/data/oauth-authz-server-settings.xml pingfederate-conf2/pingfederate/server/default/data/oauth-authz-server-settings.xml
diff -rb pingfederate-conf1/pingfederate/server/default/data/pf.jwk pingfederate-conf2/pingfederate/server/default/data/pf.jwk
diff -rb pingfederate-conf1/pingfederate/server/default/data/pingfederate-admin-user.xml pingfederate-conf2/pingfederate/server/default/data/pingfederate-admin-user.xml
diff -rb pingfederate-conf1/pingfederate/server/default/data/sourceid-saml2-local-metadata.xml pingfederate-conf2/pingfederate/server/default/data/sourceid-saml2-local-metadata.xml
```

## Accepting the PingIdentity agreement
_com.pingidentity.page.Login.xml_
```bash
diff -r -b pingfederate-8.2.2/pingfederate/server/default/data/config-store/org.sourceid.config.CoreConfig.xml
```

This accepts the license agreement _and_ indicates that the initial setup is complete:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<con:config xmlns:con="http://www.sourceid.org/2004/05/config">
    <con:map name="license-map">
        <con:item name="initial-setup-done">true</con:item>
        <con:item name="license-agreement-accepted">true</con:item>
    </con:map>
</con:config>
```

## Installing the license file

It looks like the only documented method is a click-through upload, but
just dropping the file in `/opt/pingfederate/server/default/conf/pingfederate.lic`
will do the same thing.
See the [docs](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/task/toIinstallReplacementLicenseKeyUsingAdministrativeConsole.html).

## Initial runtime settings
This is set after clicking `Next` through PingOne Account, License, Basic Information,
Enable Roles, Administrator Account. These credentials are required in order to do HTTP
Basic Auth for the pf-admin REST API. I _think (hope)_ the rest can be done from the API
once this is configured. Might also need to use this for setting up the external (Shibboleth)
IdP.

### Native login setup
_pingfederate/server/default/data/sourceid-saml2-local-metadata.xml_

For `pf.console.authentication=native`, the built-in "local" SAML2 IdP is defined.

## Initial administrator user credentials
_pingfederate/server/default/data/pingfederate-admin-user.xml_


## Commandline/API tools
### Configcopy commandline tools
_pingfederate/bin/configcopy_templates/README.txt_

See [configcopy](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/concept/automatingConfigurationMigration.html)
a these might be useful. I have not used them though.


### pf admin api
See https://localhost:9999/pf-admin-api/api-docs/ for self-documented configuration APIs.


https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/concept/pingFederateAdministrativeApi.html

## Non-UI/API Configuration of various XML files
A number of PingFederate configurations are done by directly editing the XML files and are documented as such.
Simply use the Puppet Augeas module to edit these.

These are some of the XML files that need editing:
```bash
$ find . -name *.bak
./etc/webdefault.xml.bak
./server/default/conf/META-INF/hivemodule.xml.bak
./server/default/data/config-store/org.sourceid.oauth20.domain.ClientManagerJdbcImpl.xml.bak
./server/default/data/config-store/org.sourceid.common.ExpressionManager.xml.bak
$
```

### Enabling OGNL
_/pingfederate/server/default/data/config-store/org.sourceid.common.ExpressionManager.xml_

OGNL scripting maybe need to be
[enabled](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#concept_enablingAndDisablingExpressions.html)
in order to rewrite, for example, data returned from a SAML IdP that is passed along to an OAuth 2 resource server as
part of token validation.

### Allowing CORS
_/pingfederate/etc/webdefault.xml_
See the [W3C CORS](https://www.w3.org/TR/cors/) recommendation.

I found that [this approach](http://community.unboundid.com/t5/Data-Broker/Configuring-CORS-in-Ping-Federate-so-that-Data-Broker-s-Sample/ta-p/324)
works. There's probably a more secure url-pattern that I should use.

```XML
<web-app>
  ...
  <!-- enable CORS for all endpoints and allow all origins -->
    <filter>
	    <filter-name>cross-origin</filter-name>
        <filter-class>org.eclipse.jetty.servlets.CrossOriginFilter</filter-class>
	    <init-param>
		     <param-name>allowedOrigins</param-name>
		     <param-value>*</param-value>
		</init-param>
		<init-param>
		     <param-name>allowedMethods</param-name>
		     <param-value>GET,OPTIONS,POST</param-value>
		</init-param>
	</filter>
	<filter-mapping>
	    <filter-name>cross-origin</filter-name>
	    <url-pattern>/*</url-pattern>
	</filter-mapping>
</web-app>
```

### Configuring runtime state management services
Mostly used to configure JDBC connectors for OAuth 2.0 client management and the like.

#### ping OAuth Client Manager service using mysql JDBC
See [defining an OAuth Client Datastore](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#concept_definingOauthClientDataStore.html)
for instructions.

Need to `cp /usr/share/java/mysql-connector-java-5.1.17.jar /opt/pingfederate/server/default/lib/` (via Puppet of course)
which depends on mysql-connector-java. The mysql datastore has to be up and properly configured in order to add it using
the pf-admin-api. See sample setup (also to be puppetized):

```bash
sudo yum install -y mysql-utilities mysql-server mysql mysql-connector-java
sudo mysqld start
/usr/bin/mysqladmin --user=root -h localhost.localdomain password 'new-password'
/usr/bin/mysqladmin --user=root --password=new-password -h localhost.localdomain create pingfed
mysql -u root -p pingfed
mysql> create user 'pingfed' identified by 'foobar';
mysql> grant all on pingfed.* to 'pingfed';
mysql -u pingfed -p pingfed </opt/pingfederate/server/default/conf/oauth-client-management/sql-scripts/oauth-client-management-mysql.sql
```

_server/default/conf/META-INF/hivemodule.xml_

```XML
<module id="com.pingfederatehive" version="1.0.1">
	...
    <service-point id="ClientManager" interface="org.sourceid.oauth20.domain.ClientManager">
        <invoke-factory>
            <construct class="org.sourceid.oauth20.domain.ClientManagerJdbcImpl"/>
        </invoke-factory>
    </service-point>	
```

This one is set from the pf-admin-api with a 
`POST https://localhost:9999/pf-admin-api/v1/dataStores` with these something like these form paramters:
```JSON
{
  "type": "JDBC",
  "maskAttributeValues": "false",
  "connectionUrl": "jdbc:mysql://localhost/pingfed?autoReconnect=true",
  "driverClass": "com.mysql.jdbc.Driver",
  "userName": "pingfed",
  "password": "foobar",
  "validateConnectionSql": "SELECT 1 from dual",
  "allowMultiValueAttributes": "true"
}```			 

REPONSE:
```JSON
{
  "type": "JDBC",
  "id": "JDBC-29709F2FB27DF343C7D9DC9008AF921850F94436",
  "maskAttributeValues": false,
  "connectionUrl": "jdbc:mysql://localhost/pingfed?autoReconnect=true",
  "driverClass": "com.mysql.jdbc.Driver",
  "userName": "pingfed",
  "encryptedPassword": "eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoibXZxbGRIdXhleiIsInZlcnNpb24iOiI4LjIuMi4wIn0..kt0NgojDO5rH_RzgG2zPxQ.Yv8qd8d3qQXx-5aE8k0NiA.2r6zgFEgOZ5WKn0VyuqbRg",
  "validateConnectionSql": "SELECT 1 from dual",
  "allowMultiValueAttributes": true
}
```

As such, the server needs to be running before this can happen and so we can get the system-assigned ID.

Once we have that, edit the XML files. This is kind of a circular dependency as editing the XML files will
require a server restart. I guess we get to 
use [wait_for](https://forge.puppet.com/basti1302/wait_for)
combined with [this sourceforge answer](http://stackoverflow.com/questions/8244663/puppet-wait-for-a-service-to-be-ready)
for both the mysql database to be ready as well as the pf-admin-api.

_server/default/data/pingfederate-jdbc-ds.xml_

The first `local-tx-datasource`, below, is the JDBC connection for OAuth 2.0.
The second, currently shown as hypersonic, also may need to be convereted to JDBC.

```XML
<?xml version="1.0" encoding="UTF-8"?>
<datasources>
    <local-tx-datasource maskAttributeValues="false">
        <description>jdbc:mysql://localhost/pingfed?autoReconnect=true</description>
        <jndi-name>JDBC-77D1C677602129964A4EB33124AF3CFB8D9E2475</jndi-name>
        <connection-url>jdbc:mysql://localhost/pingfed?autoReconnect=true</connection-url>
        <driver-class>com.mysql.jdbc.Driver</driver-class>
        <user-name>pingfed</user-name>
        <password>eyJhbGciOiJkaXIiLCJlxxxxOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoieFE4b3Vac2NYSiIsInZlcnNpb24iOiI4LjIuMi4wIn0..CKEcsCKPBzHvNbcbvfGLpg.zx8uTapX1TOs6McL6K1atw.krVkVEjV3x4enEeOAxBvCg</password>
        <check-valid-connection-sql>SELECT 1 from dual</check-valid-connection-sql>
        <ping-db-type>Custom</ping-db-type>
        <allow-multi-value-attributes>true</allow-multi-value-attributes>
    </local-tx-datasource>
    <local-tx-datasource maskAttributeValues="false">
        <description>jdbc:hsqldb:${pf.server.data.dir}${/}hypersonic${/}ProvisionerDefaultDB;hsqldb.lock_file=false</description>
        <jndi-name>ProvisionerDS</jndi-name>
        <connection-url>jdbc:hsqldb:${pf.server.data.dir}${/}hypersonic${/}ProvisionerDefaultDB;hsqldb.lock_file=false</connection-url>
        <driver-class>org.hsqldb.jdbcDriver</driver-class>
        <user-name>sa</user-name>
        <password>eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoieFE4b3Vac2NYSiIsInZlcnNpb24iOiI4LjIuMi4wIn0..pGVO-2n0Y9VjpKaFVmn0mw.0XBaUyWxXJZVfNxND4pzEA.7qTXM5ppDiBje1mJ4jMmAQ</password>
        <ping-db-type>Custom</ping-db-type>
        <allow-multi-value-attributes>false</allow-multi-value-attributes>
    </local-tx-datasource>
</datasources>
```

_server/default/data/config-store/org.sourceid.oauth20.domain.ClientManagerJdbcImpl.xml_

The JNDIName from above needs to be inserted here.

```XML
<?xml version="1.0" encoding="UTF-8"?>
<c:config xmlns:c="http://www.sourceid.org/2004/05/config">
    <c:item name="PingFederateDSJNDIName">JDBC-77D1C677602129964A4EB33124AF3CFB8D9E2475</c:item>
</c:config>
```

## Figuring out which admin API resources need to be updated

Starting with a known working manually-configured server 'A' (e.g. configured via clicking
through the web UI), compare it to our current Puppetized server 'B' by walking through all the
resources using [this script](a-b.sh) which just does a GET of each resource. The resource list
is heuristically arranged in order of what needs to be fixed first (e.g. serverSettings goes first)
and the script only outputs resources that differ. Some of those differences are just normal things
based on the hostname and so on, while others are real differences that need to be addressed.

```bash
$ sh a-b.sh >a-b.diff
$ head -20 a-b.diff
*** /tmp/A-serverSettings	2016-12-18 17:34:27.740007996 +0000
--- /tmp/B-serverSettings	2016-12-18 17:34:27.871007996 +0000
***************
*** 4,5 ****
!       "enableOauth": true, 
!       "enableOpenIdConnect": true
--- 4,5 ----
!       "enableOauth": false, 
!       "enableOpenIdConnect": false
***************
*** 9,12 ****
!       "enableSaml11": true, 
!       "enableSaml10": true, 
!       "enable": true, 
!       "enableWsTrust": true, 
--- 9,12 ----
!       "enableSaml11": false, 
!       "enableSaml10": false, 
!       "enable": false, 
!       "enableWsTrust": false, 


```

Then, resource at a time, template a new JSON file:

```bash
$ /opt/pingfederate/local/bin/pf-admin-api -c a.json serverSettings >templates/serverSettings.json.erb
```

### List of templated json settings resources
See the following checklist of resources that are set via templated JSON files.

#### Be careful not to over-specify
Adding some API calls changed settings in /opt/pingfederate/server/default/data/sourceid-saml2-local-metadata.xml
which Puppet then reverted via the augeas type. It turns out I was setting attributes that I don't care about (e.g. to
false or empty). Those then later got changed as a side-effect of the API calls. The fix was to have augeas only touch
what it needs to change. Lesson learned.

#### Mappings require IDs from other API JSON responses
Not that the *...Mappings* resources are a bit complicated. They need to take a unique resource ID returned
by one API call and insert it as a reference in another PUT/POST JSON document. I was hoping maybe augeas
could allow the <VALUE> to come from another place in the tree, but it looks like VALUEs are constants. 
Perhaps the [concat](https://forge.puppet.com/puppetlabs/concat)
module can be used for assembling the pieces. (I already did this a different kludgy way in
the [templates/oauth_jdbc_augeas.erb](templates/oauth_jdbc_augeas.erb) shell script.
Maybe [augeasfacter](https://github.com/hercules-team/augeasfacter) will help -- although that 
requires the value to pre-exist the current puppet run -- so probably not.

#### Checklist
This checklist only shows those resources that need to be configured. Some others like keyPairs, etc.
are automatical set to random values on each installation and don't need to be explicitly configured.

- serverSettings [done]
- dataStores [done]
  See [above](#ping-oauth-client manager-service-using-mysql-jdbc).
- passwordCredentialValidators [done]
  My purpose for setting up this PingFederate server is to use it with MuleSoft's AnyPoint Platform for client
  management. They use the deprecated pf-ws API `https://localhost:9031/pf-ws/rest/oauth/clients` which requires
  its own
  [simple password credential store](https://documentation.pingidentity.com/display/PF610/Configuring+the+Simple+Credential+Validator#ConfiguringtheSimpleCredentialValidator-1046710).
- authenticationPolicyContracts [done]
  See [this erb template](templates/authenticationPolicyContracts.json.erb) for an example of using a multivalued array.
- oauth/authServerSettings [done]
  There are a few parameters still hardcoded with default values.
- oauth/accessTokenManagers [done]
- oauth/openIdConnect/policies [done]
  This one demonstrates using an array of hashes in the erb template.
- oauth/openIdConnect/settings [done]
  This references a policy set in oauth/openIdConnect/policies so has to 'require' it.
- idp/adapters
  - Facebook [done]
	Social login. Includes contract mappings. Needs to 
	GET idp/adapters/com.pingidentity.adapters.idp.facebook.FacebookAuthenticationAdapter
	in order to fill in the POST template file. Probably needs a Python script. For now, just
	hardcode what I need.
  - still need to do this the other social IdP's.	
- sp/idpConnections [done]
  This PF server is an SP peering with the Shibboleth SAML2 IdP. The UI has an import feature which
  reads the IdP metadata XML and parses it into the various JSON API parameters. So a cool way to
  do this would be to mimic the same process, converting the XML to JSON. Maybe later. KISS for now.
  The cert metadata(certView) is ignored on POST and PUT we don't have to provide it; just the x509File.
- oauth/authenticationPolicyContractMappings [done]
- oauth/idpAdapterMappings [done]
- oauth/accessTokenMappings [done]
  Templates: `oauth_accessTokenMappings_saml2_*.json erb` and `oauth_accessTokenMappings_facebook.json.erb`.
  For each IdP (saml2, facebook, etc.) there's a mapping between IdP-sourced attributes and what to put
  in the oauth access token. The saml2 IdP has a dynamically-assigned ID so it's a pain to insert, having to
  use fragments as done in sp/idpConnections whereas the social adapters allow us to statically assign the ID.

