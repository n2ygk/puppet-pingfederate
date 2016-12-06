# Notes on automating configuration.

## Initial installation settings
### run.properties
Initial settings.
Just a straightforward edit of /opt/pingfederate/bin/run.properties

## After initial startup: settings in /opt/pingfederate/server/default/data/config-store/
The following are created as a result of initial startup and clicking through the console at https://localhost:9999/pingfederate/app

```bash
Only in pingfederate-saved/pingfederate/server/default/data/config-store: com.pingidentity.crypto.jwk.MasterKeySet.xml
Only in pingfederate-saved/pingfederate/server/default/data/config-store: com.pingidentity.page.Login.xml
Only in pingfederate-saved/pingfederate/server/default/data/config-store: InternalState.xml
Only in pingfederate-saved/pingfederate/server/default/data/config-store: org.sourceid.common.InternalStateManager.xml
diff -r -b pingfederate-8.2.2/pingfederate/server/default/data/config-store/org.sourceid.config.CoreConfig.xml
Only in pingfederate-saved/pingfederate/server/default/data/module: provisioner-notify.txt
Only in pingfederate-saved/pingfederate/server/default/data: pf.jwk
Only in pingfederate-saved/pingfederate/server/default/data: ping-ssl-client-trust-cas.jks
Only in pingfederate-saved/pingfederate/server/default/data: ping-ssl-server.jks
```

Many of these are dynamically generated random keys that we don't need to worry about setting.

### Accepting the PingIdentity agreement
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

### Installing the license file

It looks like the only documented method is a click-through upload, but
just dropping the file in `/opt/pingfederate/server/default/conf/pingfederate.lic`
will do the same thing.
See the [docs](https://documentation.pingidentity.com/pingfederate/pf82/index.shtml#adminGuide/task/toIinstallReplacementLicenseKeyUsingAdministrativeConsole.html).

### Initial administrator user credentials
_pingfederate/server/default/data/pingfederate-admin-user.xml_
This is set after clicking `Next` through PingOne Account, License, Basic Information, Enable Roles, Administrator Account. These credentials
are required in order to do HTTP Basic Auth for the pf-admin REST API:

## pf admin api
See https://localhost:9999/pf-admin-api/api-docs/ for self-documented configuration APIs.


