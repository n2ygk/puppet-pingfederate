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
```xml
<?xml version="1.0" encoding="UTF-8"?>
<con:config xmlns:con="http://www.sourceid.org/2004/05/config">
    <con:map name="license-map">
        <con:item name="license-agreement-accepted">true</con:item>
    </con:map>
</con:config>
```

```bash
diff -r -b pingfederate-8.2.2/pingfederate/server/default/data/config-store/org.sourceid.config.CoreConfig.xml
```

## Installing the license file

It looks like the only documented method is a click-through upload, but
just dropping the file in `/opt/pingfederate/server/default/conf/pingfederate.lic`
will do the same thing.
See the [docs](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/task/toIinstallReplacementLicenseKeyUsingAdministrativeConsole.html).

## Initial settings
_pingfederate/server/default/data/sourceid-saml2-local-metadata.xml_

## Initial administrator user credentials
_pingfederate/server/default/data/pingfederate-admin-user.xml_

This is set after clicking `Next` through PingOne Account, License, Basic Information, Enable Roles, Administrator Account. These credentials
are required in order to do HTTP Basic Auth for the pf-admin REST API:

## Commandline/API tools
### Configcopy commandline tools
_pingfederate/bin/configcopy_templates/README.txt_

See [configcopy](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/concept/automatingConfigurationMigration.html) in


### pf admin api
See https://localhost:9999/pf-admin-api/api-docs/ for self-documented configuration APIs.


https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/concept/pingFederateAdministrativeApi.html


