# CHANGELOG

## 0.3.7 [unreleased]
- updates to README
- change `oauth_jdbc_augeas` to use dataStores.id instead of parsing jndi from the JSON file.
- PF version >= 9: configure CORS via oauth API instead of webdefault.xml

## 0.3.6 [July 15, 2018]
- correct oauth/clients creation to happen after oauth_jdbc configuration change.

## 0.3.4 [July 13, 2018]
- give up on trying to fix random toggling of embedded whitespace in XML comment.

## 0.3.3 [July 13, 2018]
- workaround mistmatch between pingfederate's gid in RPM vs. system which caused augtool to fail on xfer_attrs.

## 0.3.2 [July 12, 2018]
- pf editing puppet-managed XML was changing the "do not edit" comment, causing an unneccessary service restart in some cases.

## 0.3.1 [July 11, 2018]
- pf-admin-api POST -> PUT behavior

## 0.3.0 [July 10, 2018]
- Add oauth client configuration

## 0.2.13 [July 9, 2018]
- Make pf-admin-api default timeout=20

## 0.2.12 [July 6, 2018]
- Add configurable `oauth_oidc_id_userinfo`

## 0.2.11 [July 5, 2018]
- Bugfix: deep-merged `saml2_idp_default` not used where it should have been.

## 0.2.10 [June 18, 2018]
- Add configurable `oauth_scope_fail_no_selection`

## 0.2.9 [June 14, 2018]
- Make pf.log.dir configurable.

## Initial 0.1.0 release
