# CHANGELOG

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
