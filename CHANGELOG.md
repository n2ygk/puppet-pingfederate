# CHANGELOG
## 0.6.1 [April 11, 2019]
- Bugfix: Attempting to set `pingfederate::oauth_jdbc_access_ddl_cmd` did not work.

## 0.6.0 [January 11, 2019]
- Added OAuth2 Client Auth support for no secret (NONE) and Private Key JWT.
- pf-admin-api renames the input `file.json` to `file.json.fail` on error.

## 0.5.2 [September 26, 2018]
- Added defaults for MS sqlserver `oauth_jdbc_type`.
- Added `oauth_jdbc_nexus` which allows installing the jdbc JAR file via `archive::nexus`
  and `oauth_jdbc_maven` which installs from a maven repository URL via `archive`.

## 0.4.1 [August 2, 2018]
- Added `oauth_oidc_policy_scope_attr_map` which allows customizing which claims are returned by given scopes

## 0.4.0 [July 25, 2018]
- Change several arrays of hashes to hash of hashes to facilitate [hiera yaml key merging](https://puppet.com/docs/puppet/5.0/hiera_merging.html):
  - social_adapter
  - oauth_client

## 0.3.8 [July 17, 2018]
- Support for Facebook cloud identity connector 2.0

## 0.3.7 [July 16, 2018]
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
