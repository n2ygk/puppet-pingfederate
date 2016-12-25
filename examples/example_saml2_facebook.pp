# This is best on my actual working configuration, with a few key values changed.
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
       Signature=302C02141B7xxxx55996EB354FAEDC5211E14E3BC2B4964602144EEBD282F20EF2B77AA8A87DCB17BE533A537720
       | LICENSE
# ugh it is impossible to get this damn quoting right. It gets double-interpolated. Once by puppet and again by JSON parser.
$map_group = join(['#result=#this.get(\'urn:oid:1.3.6.1.4.1.5923.1.1.1.1.9\').toString()', # get the PingAffiliation extended attribute value
                   '#result=#result.replace(\"[\", \'[\\\\\"\')',                            # replace [ with [\"
                   '#result=#result.replace(\"]\", \'\\\\\"]\')',                            # replace ] with "]
                   '#result=#result.replace(\",\", \'\\\\\",\\\\\"\')',                        # replace , with ","
                   '#result=#result.replace(\" \", \"\")'],',  ')                          # compress out whitespace, join stmts with ',  '
$cert_str =  @(x509File)
             -----BEGIN CERTIFICATE-----
             MIIDZjCCAk6gAwIBAgIVAJfrwoV8xxxxXzQxy/P+tTmLVdd2MA0GCSqGSIb3DQEB
             BQUAMCkxJzAlBgNVBAMTHnNoaWJib2xldGgtZGV2LmNjLmNvbHVtYmlhLmVkdTAe
             Fw0xMzA1MTcxNTA0MjhaFw0zMzA1MTcxNTA0MjhaMCkxJzAlBgNVBAMTHnNoaWJi
             b2xldGgtZGV2LmNjLmNvbHVtYmlhLmVkdTCCASIwDQYJKoZIhvcNAQEBBQADggEP
             ADCCAQoCggEBAJ0C0taW9a9Ifp5quu28ogl7In9uu5CXgoDV8MKcE7WtbW8dCh98
             h17SIsbZKvFxJqj4xTskGefW7qli6m7aa8sxR47RXrPmkFxUEndg01eQE0OaYl6E
             6E7OfN2f8yL6PO0/rFA3FF9wImpTuUo2jcMk0LEES1sjKc4CjOpOhNmf//x20LmN
             n5h8yPYhGxjUcT4pDXQlKPaGuPY+lheOKW4AukyjBWkRvCzpxbohC8DlRtsUUznm
             mVhlaIsQNcjx7GsjbL7BPAjomyWEgOU6GLaS8XIRe5tER8o2cj4pPttmQ8BhNY3V
             ZSUqVinszbuL+m1+LctfN5mWgvmSzYLKL6ECAwEAAaOBhDCBgTBgBgNVHREEWTBX
             gh5zaGliYm9sZXRoLWRldi5jYy5jb2x1bWJpYS5lZHWGNWh0dHBzOi8vc2hpYmJv
             bGV0aC1kZXYuY2MuY29sdW1iaWEuZWR1L2lkcC9zaGliYm9sZXRoMB0GA1UdDgQW
             BBQrL3ArXajqiuTyb0y8+/0voOBA3zANBgkqhkiG9w0BAQUFAAOCAQEAUiOmFYXr
             IdxqrTpOe9QgkFd2fSb+6h14gecI7iL/wHJVPeN+VO84+7eRBUkDdTJbikmA8ByS
             CBKkMChGxTeNLkReJat7XaKs8AkK7fm7xxxxxliR/nqd/ccY2NCPlySg/uFH/tzZ
             8OYF08Id2Zl8iPBOmIo9yG1XPNusLYlSepQcQRceGMz3bHYK0QJz9puBoY2sgTU1
             16eKuP4Qihb94t+wojt+7GWQ2c5LU6gzuIiZPyXg+S8QGma0M7/0tx6diJwR5kLU
             AK8pgiKg6MLZLa4NU04EGK39M2kH31UrAo2J12U/jYwyS8iRI5c+JqaqVlKMyT94
             KnBx39pwbQzyaw==
             -----END CERTIFICATE-----
             | x509File
class { '::pingfederate':
  license_content                  => $lic,
  #adm_user                        => 'pingadmin',
  oauth_jdbc_type                  => 'mysql',
  oauth_jdbc_user                  => 'pingfed',
  oauth_jdbc_pass                  => 'password',
  oauth_jdbc_db                    => 'pingfed',
  oauth_jdbc_host                  => 'localhost',
  saml2_sp_auth_policy_name        => 'API', # name of our API auth service
  saml2_sp_auth_policy_extd_attrs  => ['pingAffiliation'],
  oauth_svc_grant_extd_attrs       => ['group'],
  oauth_svc_acc_tok_mgr_id         => 'CUapis',
  oauth_svc_acc_tok_mgr_extd_attrs => ['uid','group','username'],
  oauth_oidc_policy_id             => 'CUoidcApis',
  oauth_oidc_policy_core_map       => [{'name' =>'sub', 'type' => 'TOKEN', 'value' => 'username'}],
  oauth_oidc_policy_extd_map       => [{'name' => 'group', 'type' => 'TOKEN', 'value' => 'group'}],
  oauth_authn_policy_map           => [{'name' => 'USER_KEY', 'type' => 'AUTHENTICATION_POLICY_CONTRACT', 'value' => 'subject'},
                                       {'name' => 'USER_NAME', 'type' => 'AUTHENTICATION_POLICY_CONTRACT', 'value' => 'subject'},
                                       {'name' => 'group', 'type' => 'AUTHENTICATION_POLICY_CONTRACT', 'value' => 'pingAffiliation'},
                                       ],
  facebook_adapter                 => true,
  facebook_app_id                  => '1141518492609366',
  facebook_app_secret              => '99bd671e89381082a3f2f2743cad4635',
  facebook_oauth_token_map         => [{'name' => 'username', 'type' => 'ADAPTER', 'value' => 'name'}, # maybe these two maps are really one
                                       {'name' => 'group', 'type' => 'TEXT', 'value' => 'facebook'},
                                       {'name' => 'uid', 'type' => 'ADAPTER', 'value' => 'id'}
                                       ],
  facebook_oauth_idp_map           => [{'name' => 'USER_KEY', 'type' => 'ADAPTER', 'value' => 'id'},
                                       {'name' => 'USER_NAME', 'type' => 'ADAPTER', 'value' => 'name'},
                                       {'name' => 'group', 'type' => 'TEXT', 'value' => 'group'},
                                       ],
  saml2_idp_url                    => 'https://shibboleth-dev.cc.columbia.edu',
  saml2_idp_contact                => {'firstName' => 'CUIT', 'lastName' => 'IDM', 'email' => 'cuit-idm-tech@columbia.edu'},
  saml2_idp_extd_attrs             => ['urn:oid:1.3.6.1.4.1.5923.1.1.1.1.9'],
  saml2_idp_attr_map               => [{'name' => 'pingAffiliation', 'type' => 'EXPRESSION', 'value' => $map_group},
                                       {'name' => 'subject', 'type' => 'ASSERTION', 'value' => 'SAML_SUBJECT'}
                                       ],
  saml2_idp_oauth_map              => [{'name' => 'USER_KEY', 'type' => 'ASSERTION', 'value' => 'SAML_SUBJECT'},
                                       {'name' => 'USER_NAME', 'type' => 'ASSERTION', 'value' => 'SAML_SUBJECT'},
                                       {'name' => 'group', 'type' => 'EXPRESSION', 'value' => $map_group}
                                       ],
  saml2_oauth_token_map            => [{'name' => 'username', 'type' => 'OAUTH_PERSISTENT_GRANT', 'value' => 'USER_KEY'},
                                       {'name' => 'group', 'type' => 'OAUTH_PERSISTENT_GRANT', 'value' => 'group'},
                                       {'name' => 'uid', 'type' => 'OAUTH_PERSISTENT_GRANT', 'value' => 'USER_KEY'}
                                       ],
  saml2_idp_cert_str               => $cert_str,
}

