# == Class: pingfederate
#
# Install and configure PingFederate
#
# === Parameters
#
# See README.md
#
# === Examples
#
# See README.md
#
# === Authors
#
# Alan Crosswell <alan@columbia.edu>
#
# === Copyright
#
# Copyright (c) 2016 The Trustees of Columbia University in the City of New York
#
class pingfederate (
  $install_dir                         = $::pingfederate::params::install_dir,
  # main server package
  $package_list                        = $::pingfederate::params::package_list,
  $package_ensure                      = $::pingfederate::params::package_ensure,
  $package_java_list                   = $::pingfederate::params::package_java_list,
  $package_java_ensure                 = $::pingfederate::params::package_java_ensure,
  $package_java_redhat                 = $::pingfederate::params::package_java_redhat,
  $package_java_centos                 = $::pingfederate::params::package_java_centos,
  # ensure the service is up
  $service_name                        = $::pingfederate::params::service_name,
  $service_ensure                      = $::pingfederate::params::service_ensure,
  # license key file: provide either the content or source file URL
  $license_content                     = $::pingfederate::params::license_content,
  $license_file                        = $::pingfederate::params::license_file,
  $owner                               = $::pingfederate::params::owner,
  $group                               = $::pingfederate::params::group,
  # various run.properties (there are a few more; add them as you need them):
  $admin_https_port                    = $::pingfederate::params::admin_https_port,
  $admin_hostname                      = $::pingfederate::params::admin_hostname,
  $console_bind_address                = $::pingfederate::params::console_bind_address,
  $console_title                       = $::pingfederate::params::console_title,
  $console_session_timeout             = $::pingfederate::params::console_session_timeout,
  $console_login_mode                  = $::pingfederate::params::console_login_mode,
  $console_authentication              = $::pingfederate::params::console_authentication,
  $admin_api_authentication            = $::pingfederate::params::admin_api_authentication,
  $http_port                           = $::pingfederate::params::http_port,
  $https_port                          = $::pingfederate::params::https_port,
  $secondary_https_port                = $::pingfederate::params::secondary_https_port,
  $engine_bind_address                 = $::pingfederate::params::engine_bind_address,
  $monitor_bind_address                = $::pingfederate::params::monitor_bind_address,
  $log_eventdetail                     = $::pingfederate::params::log_eventdetail,
  $heartbeat_system_monitoring         = $::pingfederate::params::heartbeat_system_monitoring,
  $operational_mode                    = $::pingfederate::params::operational_mode,
  $cluster_node_index                  = $::pingfederate::params::cluster_node_index,
  $cluster_auth_pwd                    = $::pingfederate::params::cluster_auth_pwd,
  $cluster_encrypt                     = $::pingfederate::params::cluster_encrypt,
  $cluster_bind_address                = $::pingfederate::params::cluster_bind_address,
  $cluster_bind_port                   = $::pingfederate::params::cluster_bind_port,
  $cluster_failure_detection_bind_port = $::pingfederate::params::cluster_failure_detection_bind_port,
  $cluster_transport_protocol          = $::pingfederate::params::cluster_transport_protocol,
  $cluster_mcast_group_address         = $::pingfederate::params::cluster_mcast_group_address,
  $cluster_mcast_group_port            = $::pingfederate::params::cluster_mcast_group_port,
  $cluster_tcp_discovery_initial_hosts = $::pingfederate::params::cluster_tcp_discovery_initial_hosts,
  $cluster_diagnostics_enabled         = $::pingfederate::params::cluster_diagnostics_enabled,
  $cluster_diagnostics_addr            = $::pingfederate::params::cluster_diagnostics_addr,
  $cluster_diagnostics_port            = $::pingfederate::params::cluster_diagnostics_port,
  # administration
  $adm_user                            = $::pingfederate::params::adm_user,
  $adm_pass                            = $::pingfederate::params::adm_pass,
  $adm_hash                            = $::pingfederate::params::adm_hash,
  $adm_api_baseURL                     = $::pingfederate::params::adm_api_baseURL,
  # API: serverSettings & XML: sourceid-saml2-local-metadata.xml (local SAML IdP configuration)
  $service_api_baseURL                 = $::pingfederate::params::service_api_baseURL,
  $saml2_local_entityID                = $::pingfederate::params::saml2_local_entityID,
  $saml1_local_issuerID                = $::pingfederate::params::saml1_local_issuerID,
  $wsfed_local_realm                   = $::pingfederate::params::wsfed_local_realm,
  # API: authenticationPolicyContracts (SAML2 SP configuration)
  $saml2_sp_auth_policy_name           = $::pingfederate::params::saml2_sp_auth_policy_name,
  $saml2_sp_auth_policy_core_attrs     = $::pingfederate::params::saml2_sp_auth_policy_core_attrs,
  $saml2_sp_auth_policy_extd_attrs     = $::pingfederate::params::saml2_sp_auth_policy_extd_attrs,
  # API: sp/idpConnections (SAML2 partner IdP)
  $saml2_idp_url                       = $::pingfederate::params::saml2_idp_url,
  $saml2_idp_entityID                  = $::pingfederate::params::saml2_idp_entityID,
  $saml2_idp_post                      = $::pingfederate::params::saml2_idp_post,
  $saml2_idp_redirect                  = $::pingfederate::params::saml2_idp_redirect,
  $saml2_idp_contact                   = $::pingfederate::params::saml2_idp_contact,
  $saml2_idp_profiles                  = $::pingfederate::params::saml2_idp_profiles,
  $saml2_idp_id_mapping                = $::pingfederate::params::saml2_idp_id_mapping,
  $saml2_idp_core_attrs                = $::pingfederate::params::saml2_idp_core_attrs,
  $saml2_idp_extd_attrs                = $::pingfederate::params::saml2_idp_extd_attrs,
  $saml2_idp_attr_map                  = $::pingfederate::params::saml2_idp_attr_map,
  $saml2_idp_oauth_map                 = $::pingfederate::params::saml2_idp_oauth_map,
  $saml2_idp_cert_file                 = $::pingfederate::params::saml2_idp_cert_file,
  $saml2_idp_cert_content                  = $::pingfederate::params::saml2_idp_cert_content,
  $saml2_oauth_token_map               = $::pingfederate::params::saml2_oauth_token_map,
  # XML: etc/webdefault.xml (Enable Cross-Origin Resource Sharing -- CORS)
  $cors_allowedOrigins                 = $::pingfederate::params::cors_allowedOrigins,
  $cors_allowedMethods                 = $::pingfederate::params::cors_allowedMethods,
  $cors_filter_mapping                 = $::pingfederate::params::cors_filter_mapping,
  # XML: server/default/data/config-store/org.sourceid.common.ExpressionManager.xml (OGNL expressions)
  $ognl_expressions_enable             = $::pingfederate::params::ognl_expressions_enable,
  # API: dataStores: OAuth JDBC database (configured iff oauth_jdbc_type is defined)
  $oauth_jdbc_type                     = $::pingfederate::params::oauth_jdbc_type,
  $oauth_jdbc_package_list             = $::pingfederate::params::oauth_jdbc_package_list,
  $oauth_jdbc_package_ensure           = $::pingfederate::params::oauth_jdbc_package_ensure,
  $oauth_jdbc_jar_dir                  = $::pingfederate::params::oauth_jdbc_jar_dir,
  $oauth_jdbc_jar                      = $::pingfederate::params::oauth_jdbc_jar,
  $oauth_jdbc_driver                   = $::pingfederate::params::oauth_jdbc_driver,
  $oauth_jdbc_host                     = $::pingfederate::params::oauth_jdbc_host,
  $oauth_jdbc_port                     = $::pingfederate::params::oauth_jdbc_port,
  $oauth_jdbc_db                       = $::pingfederate::params::oauth_jdbc_db,
  $oauth_jdbc_url                      = $::pingfederate::params::oauth_jdbc_url,
  $oauth_jdbc_user                     = $::pingfederate::params::oauth_jdbc_user,
  $oauth_jdbc_pass                     = $::pingfederate::params::oauth_jdbc_pass,
  $oauth_jdbc_validate                 = $::pingfederate::params::oauth_jdbc_validate,
  $oauth_jdbc_create_cmd               = $::pingfederate::params::oauth_jdbc_create_cmd,
  $oauth_jdbc_ddl_cmd                  = $::pingfederate::params::oauth_jdbc_ddl_cmd,
  # API: passwordCredentialValidators (for OAuth client manager)
  $oauth_client_mgr_user               = $::pingfederate::params::oauth_client_mgr_user,
  $oauth_client_mgr_pass               = $::pingfederate::params::oauth_client_mgr_pass,
  # API: oauth/authServerSettings
  $oauth_svc_grant_core_attrs          = $::pingfederate::params::oauth_svc_grant_core_attrs,
  $oauth_svc_grant_extd_attrs          = $::pingfederate::params::oauth_svc_grant_extd_attrs,
  # API: oauth/accessTokenManagers
  $oauth_svc_acc_tok_mgr_id            = $::pingfederate::params::oauth_svc_acc_tok_mgr_id,
  $oauth_svc_acc_tok_mgr_core_attrs    = $::pingfederate::params::oauth_svc_acc_tok_mgr_core_attrs,
  $oauth_svc_acc_tok_mgr_extd_attrs    = $::pingfederate::params::oauth_svc_acc_tok_mgr_extd_attrs,
  # API: oauth/openIdConnect_policies
  $oauth_oidc_policy_id                = $::pingfederate::params::oauth_oidc_policy_id,
  $oauth_oidc_policy_core_map          = $::pingfederate::params::oauth_oidc_policy_core_map,
  $oauth_oidc_policy_extd_map          = $::pingfederate::params::oauth_oidc_policy_extd_map,
  # API: oauth/authenticationPolicyContractMappings
  $oauth_authn_policy_map              = $::pingfederate::params::oauth_authn_policy_map,
  # add-on packages: social media oauth adapters
  # facebook
  $facebook_adapter                    = $::pingfederate::params::facebook_adapter,
  $facebook_package_list               = $::pingfederate::params::facebook_package_list,
  $facebook_package_ensure             = $::pingfederate::params::facebook_package_ensure,
  # API: idp/adapters
  $facebook_app_id                     = $::pingfederate::params::facebook_app_id,
  $facebook_app_secret                 = $::pingfederate::params::facebook_app_secret,
  # API: oauth/idpAdapterMappings
  $facebook_oauth_idp_map              = $::pingfederate::params::facebook_oauth_idp_map,
  # API: oauth/accessTokenMappings
  $facebook_oauth_token_map            = $::pingfederate::params::facebook_oauth_token_map,
  # google
  $google_adapter                      = $::pingfederate::params::google_adapter,
  $google_package_list                 = $::pingfederate::params::google_package_list,
  $google_package_ensure               = $::pingfederate::params::google_package_ensure,
  # linkedin
  $linkedin_adapter                    = $::pingfederate::params::linkedin_adapter,
  $linkedin_package_list               = $::pingfederate::params::linkedin_package_list,
  $linkedin_package_ensure             = $::pingfederate::params::linkedin_package_ensure,
  # twitter
  $twitter_adapter                     = $::pingfederate::params::twitter_adapter,
  $twitter_package_list                = $::pingfederate::params::twitter_package_list,
  $twitter_package_ensure              = $::pingfederate::params::twitter_package_ensure,
  # windowslive
  $windowslive_adapter                 = $::pingfederate::params::windowslive_adapter,
  $windowslive_package_list            = $::pingfederate::params::windowslive_package_list,
  $windowslive_package_ensure          = $::pingfederate::params::windowslive_package_ensure,
  ) inherits ::pingfederate::params {

  validate_re($operational_mode,['^STANDALONE$','^CLUSTERED_CONSOLE$','^CLUSTERED_ENGINE$'])
  if $cluster_bind_address != 'NON_LOOPBACK' {
    validate_ip_address($cluster_bind_address)
  }
  validate_integer($cluster_bind_port,65535,1)
  validate_integer($cluster_failure_detection_bind_port,65535,1)
  validate_integer($cluster_node_index,undef,0)
  validate_bool($cluster_encrypt)
  if str2bool($cluster_encrypt) {
    validate_string($cluster_auth_pwd)
  }
  # Example: host1[7600],10.0.1.4[7600],host7[1033],10.0.9.45[2231] 
  validate_string($cluster_tcp_discovery_initial_hosts)
  validate_ip_address($console_bind_address)
  validate_integer($admin_https_port,65535,1)
  validate_integer($http_port,65535,-1)
  validate_integer($https_port,65535,-1)
  validate_integer($secondary_https_port,65535,-1)

  # Setup the OAuth JDBC settings, if requested (oauth_jdbc_type is defined)
  # If overriding settings are not provided, the defaults are filled in based on the type.
  if $::pingfederate::oauth_jdbc_type {
    validate_re($oauth_jdbc_type,['^mysql$','^sqlserver$','^oracle$','^other$'])
    # The following defaults based on database type (mysql, mssql, oracle) can still be overidden.
    $script_dir = "${::pingfederate::install_dir}/server/default/conf/oauth-client-management/sql-scripts/"
    case $::pingfederate::oauth_jdbc_type {
      'mysql': {
        $def_pkgs     = ['mysql','mysql-connector-java']
        $def_jar_dir  = '/usr/share/java'
        $def_jar      = 'mysql-connector-java.jar'
        $def_validate = 'SELECT 1 from dual'
        $def_driver   = 'com.mysql.jdbc.Driver'
        $portstr      = if $::pingfederate::oauth_jdbc_port { ":${::pingfederate::oauth_jdbc_port}" } else { '' }
        $def_url      = "jdbc:mysql://${oauth_jdbc_host}${portstr}/${oauth_jdbc_db}"
        $script       = 'oauth-client-management-mysql.sql'
        $def_create   = "/usr/bin/mysqladmin --wait                    \
                         --connect_timeout=30                          \
                         --host=${::pingfederate::oauth_jdbc_host}     \
                         --port=${::pingfederate::oauth_jdbc_port}     \
                         --user=${::pingfederate::oauth_jdbc_user}     \
                         --password=\"${::pingfederate::oauth_jdbc_pass}\" \
                         create ${::pingfederate::oauth_jdbc_db}       \
                         | /bin/awk '/database exists/{exit 0}/./{exit 1}' " # allow database exists error or no output
        $def_cmd      = "/usr/bin/mysql --wait --connect_timeout=30    \
                         --host=${::pingfederate::oauth_jdbc_host}     \
                         --port=${::pingfederate::oauth_jdbc_port}     \
                         --user=${::pingfederate::oauth_jdbc_user}     \
                         --password=\"${::pingfederate::oauth_jdbc_pass}\" \
                         --database=${::pingfederate::oauth_jdbc_db}   \
                         < ${script_dir}/${script}                     \
                         | /bin/awk '/ERROR 1050/{exit 0}/./{exit 1}'  " # allow 1050 (table already exists) or no output
      }
      'sqlserver': {
        # TBD
        fail("Config code for database type ${::pingfederate::oauth_jdbc_type} incomplete.")
      }
      'oracle': {
        # TBD
        fail("Config code for database type ${::pingfederate::oauth_jdbc_type} incomplete.")
      }
      'other': {                # everything must be set in $::pingfederate::oauth_jdbc_*
        $def_pkgs     = undef
        $def_jar_dir  = undef
        $def_jar      = undef
        $def_validate = undef
        $def_driver   = undef
        $def_url      = undef
        $def_create   = undef
        $def_cmd      = undef
      }
      default: { fail("Don't know to configure for database type ${::pingfederate::oauth_jdbc_type}.") }
    }

    # (optionally) override defaults from above
    $o_pkgs     = if $::pingfederate::oauth_jdbc_package_list { $::pingfederate::oauth_jdbc_package_list } else { $def_pkgs }
    $o_jar_dir  = if $::pingfederate::oauth_jdbc_jar_dir { $::pingfederate::oauth_jdbc_jar_dir } else { $def_jar_dir }
    $o_jar      = if $::pingfederate::oauth_jdbc_jar { $::pingfederate::oauth_jdbc_jar } else { $def_jar }
    $o_validate = if $::pingfederate::oauth_jdbc_validate { $::pingfederate::oauth_jdbc_validate } else { $def_validate }
    $o_driver   = if $::pingfederate::oauth_jdbc_driver { $::pingfederate::oauth_jdbc_driver } else { $def_driver }
    $o_url      = if $::pingfederate::oauth_jdbc_url { $::pingfederate::oauth_jdbc_url } else { $def_url }
    $o_create   = if $::pingfederate::oauth_jdbc_create_cmd { $::pingfederate::oauth_jdbc_create_cmd } else { $def_create }
    $o_cmd      = if $::pingfederate::oauth_jdbc_ddl_cmd { $::pingfederate::oauth_jdbc_ddl_cmd } else { $def_cmd }
  }

  # need to do more validation...

  # Install the package(s), configure the pre-runtime settings, start the service, and administer the post-startup settings.
  anchor { 'pingfederate::begin': } ->
  class { '::pingfederate::install': } ->
  class { '::pingfederate::config': } ~>
  class { '::pingfederate::service': } ->
  class { '::pingfederate::admin': } ->
  anchor { 'pingfederate::end': }

}
