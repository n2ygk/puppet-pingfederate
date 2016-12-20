#!/bin/sh
# do A-B comparison of resources on two different pf servers
a=a.json
b=b.json
# skipping over configArchive and connectionMetadata which are POSTs or files rather than JSON responses.
# wish there were a metadata URL listing all the resources -- actually there is: `api-docs`
# source these resources based on order they need to be configured.
resources='
serverSettings
serverSettings/notifications
serverSettings/emailServer
cluster/status
dataStores/descriptors
dataStores
passwordCredentialValidators/descriptors
passwordCredentialValidators
authenticationPolicyContracts
oauth/authServerSettings
oauth/accessTokenManagers/settings
oauth/accessTokenManagers/descriptors
oauth/accessTokenManagers
oauth/openIdConnect/settings
oauth/openIdConnect/policies
sp/adapters/descriptors
sp/adapters
sp/defaultUrls
sp/idpConnections
sp/targetUrlMappings
idp/adapters/descriptors
idp/adapters
idp/defaultUrls
idp/spConnections
idpToSpAdapterMapping
oauth/accessTokenMappings
oauth/authenticationPolicyContractMappings
oauth/idpAdapterMappings
oauth/resourceOwnerCredentialsMappings
authenticationPolicies/settings
authenticationPolicies/default
authenticationSelectors/descriptors
authenticationSelectors
kerberos/realms/settings
kerberos/realms
keyPairs/keyAlgorithms
keyPairs/signing
keyPairs/sslClient
keyPairs/sslServer
keyPairs/sslServer/settings
metadataUrls
certificates/ca
session/settings
session/authenticationSessionPolicies/global
session/authenticationSessionPolicies
'
for r in $resources; do
    aname=`echo A-$r | sed -e 's:/:_:g'`
    bname=`echo B-$r | sed -e 's:/:_:g'`
    /opt/pingfederate/local/bin/pf-admin-api -c $a $r >/tmp/$aname
    /opt/pingfederate/local/bin/pf-admin-api -c $b $r >/tmp/$bname
    diff -C 0 /tmp/$aname /tmp/$bname
    #rm -f /tmp/$aname /tmp/$bname
done
