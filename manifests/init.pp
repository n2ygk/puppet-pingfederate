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
  # log4j2 logging:
  $log_dir                             = $::pingfederate::params::log_dir,
  $log_retain_days                     = $::pingfederate::params::log_retain_days,
  $log_files                           = $::pingfederate::params::log_files,
  $log_levels                          = $::pingfederate::params::log_levels,
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
  $adm_api_baseurl                     = $::pingfederate::params::adm_api_baseurl,
  # API: serverSettings & XML: sourceid-saml2-local-metadata.xml (local SAML IdP configuration)
  $service_api_baseurl                 = $::pingfederate::params::service_api_baseurl,
  $saml2_local_entityid                = $::pingfederate::params::saml2_local_entityid,
  $saml1_local_issuerid                = $::pingfederate::params::saml1_local_issuerid,
  $wsfed_local_realm                   = $::pingfederate::params::wsfed_local_realm,
  $http_forwarded_for_header           = $::pingfederate::params::http_forwarded_for_header,
  $http_forwarded_host_header          = $::pingfederate::params::http_forwarded_host_header,
  # API: list of authenticationPolicyContracts (SAML2 SP configuration)
  $auth_policy_contract                = $::pingfederate::params::auth_policy_contract,
  $auth_policy_contract_default        = $::pingfederate::params::auth_policy_contract_default,
  # API: sp/idpConnections (SAML2 partner IdP)
  $saml2_idp                           = $::pingfederate::params::saml2_idp,
  #  defaults for missing values in the map(s)
  $saml2_idp_default                   = $::pingfederate::params::saml2_idp_default,
  # social media adapters
  $social_adapter                      = $::pingfederate::params::social_adapter,
  $social_adapter_default              = $::pingfederate::params::social_adapter_default,
  # XML: etc/webdefault.xml (Enable Cross-Origin Resource Sharing -- CORS)
  $cors_allowedorigins                 = $::pingfederate::params::cors_allowedorigins,
  $cors_allowedmethods                 = $::pingfederate::params::cors_allowedmethods,
  $cors_allowedheaders                 = $::pingfederate::params::cors_allowedheaders,
  $cors_filter_mapping                 = $::pingfederate::params::cors_filter_mapping,
  # XML: server/default/data/config-store/org.sourceid.common.ExpressionManager.xml (OGNL expressions)
  $ognl_expressions_enable             = $::pingfederate::params::ognl_expressions_enable,
  # API: dataStores: OAuth JDBC database (configured iff oauth_jdbc_type is defined)
  $oauth_jdbc_type                     = $::pingfederate::params::oauth_jdbc_type,
  $oauth_jdbc_package_list             = $::pingfederate::params::oauth_jdbc_package_list,
  $oauth_jdbc_package_ensure           = $::pingfederate::params::oauth_jdbc_package_ensure,
  $oauth_jdbc_jar_dir                  = $::pingfederate::params::oauth_jdbc_jar_dir,
  $oauth_jdbc_jar                      = $::pingfederate::params::oauth_jdbc_jar,
  $oauth_jdbc_maven                    = $::pingfederate::params::oauth_jdbc_maven,
  $oauth_jdbc_nexus                    = $::pingfederate::params::oauth_jdbc_nexus,
  $oauth_jdbc_driver                   = $::pingfederate::params::oauth_jdbc_driver,
  $oauth_jdbc_host                     = $::pingfederate::params::oauth_jdbc_host,
  $oauth_jdbc_port                     = $::pingfederate::params::oauth_jdbc_port,
  $oauth_jdbc_db                       = $::pingfederate::params::oauth_jdbc_db,
  $oauth_jdbc_url                      = $::pingfederate::params::oauth_jdbc_url,
  $oauth_jdbc_user                     = $::pingfederate::params::oauth_jdbc_user,
  $oauth_jdbc_pass                     = $::pingfederate::params::oauth_jdbc_pass,
  $oauth_jdbc_validate                 = $::pingfederate::params::oauth_jdbc_validate,
  $oauth_jdbc_create_cmd               = $::pingfederate::params::oauth_jdbc_create_cmd,
  $oauth_jdbc_client_ddl_cmd           = $::pingfederate::params::oauth_jdbc_client_ddl_cmd,
  $oauth_jdbc_access_ddl_cmd           = $::pingfederate::params::oauth_jdbc_access_ddl_cmd,
  # drag in acct linking datastore while we are at it...
  $acct_jdbc_linking_ddl_cmd           = $::pingfederate::params::acct_jdbc_linking_ddl_cmd,
  # API: passwordCredentialValidators (for OAuth client manager)
  $oauth_client_mgr_user               = $::pingfederate::params::oauth_client_mgr_user,
  $oauth_client_mgr_pass               = $::pingfederate::params::oauth_client_mgr_pass,
  # API: oauth/authServerSettings
  $oauth_svc_scopes                    = $::pingfederate::params::oauth_svc_scopes,
  $oauth_svc_scope_groups              = $::pingfederate::params::oauth_svc_scope_groups,
  $oauth_svc_grant_core_attrs          = $::pingfederate::params::oauth_svc_grant_core_attrs,
  $oauth_svc_grant_extd_attrs          = $::pingfederate::params::oauth_svc_grant_extd_attrs,
  # API: authenticationSelectors
  $oauth_scope_selectors               = $::pingfederate::params::oauth_scope_selectors,
  $oauth_scope_fail_no_selection       = $::pingfederate::params::oauth_scope_fail_no_selection,
  # API: oauth/accessTokenManagers
  $oauth_svc_acc_tok_mgr_id            = $::pingfederate::params::oauth_svc_acc_tok_mgr_id,
  $oauth_svc_acc_tok_mgr_core_attrs    = $::pingfederate::params::oauth_svc_acc_tok_mgr_core_attrs,
  $oauth_svc_acc_tok_mgr_extd_attrs    = $::pingfederate::params::oauth_svc_acc_tok_mgr_extd_attrs,
  # API: oauth/openIdConnect_policies
  $oauth_oidc_policy_id                = $::pingfederate::params::oauth_oidc_policy_id,
  $oauth_oidc_id_userinfo              = $::pingfederate::params::oauth_oidc_id_userinfo,
  $oauth_oidc_policy_core_map          = $::pingfederate::params::oauth_oidc_policy_core_map,
  $oauth_oidc_policy_extd_map          = $::pingfederate::params::oauth_oidc_policy_extd_map,
  $oauth_oidc_policy_scope_attr_map    = $::pingfederate::params::oauth_oidc_policy_scope_attr_map,
  # API: oauth/authenticationPolicyContractMappings
  $oauth_authn_policy_map              = $::pingfederate::params::oauth_authn_policy_map,
  # API: oauth/clients
  $oauth_client                        = $::pingfederate::params::oauth_client,
  $oauth_client_default                = $::pingfederate::params::oauth_client_default,
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
  if $cluster_tcp_discovery_initial_hosts {
    validate_array($cluster_tcp_discovery_initial_hosts)
  }
  validate_ip_address($console_bind_address)
  validate_integer($admin_https_port,65535,1)
  validate_integer($http_port,65535,-1)
  validate_integer($https_port,65535,-1)
  validate_integer($secondary_https_port,65535,-1)

  # Setup the OAuth JDBC settings, if requested (oauth_jdbc_type is defined)
  # Do this for both oauth client management and access grants in the same database (MYSQL example shown):
  # .../server/default/conf/oauth-client-management/sql-scripts/oauth-client-management-mysql.sql
  # .../server/default/conf/access-grant/sql-scripts/access-grant-*-mysql.sql (2 scripts!)
  # .../server/default/conf/account-linking/sql-scripts/account-linking-mysql.sql
  # If overriding settings are not provided, the defaults are filled in based on the type.
  if $::pingfederate::oauth_jdbc_type {
    validate_re($oauth_jdbc_type,['^mysql$','^sqlserver$','^oracle$','^other$'])
    # The following defaults based on database type (mysql, mssql, oracle) can still be overidden.
    $oauth_client_script_dir = "${::pingfederate::install_dir}/server/default/conf/oauth-client-management/sql-scripts/"
    $oauth_access_script_dir = "${::pingfederate::install_dir}/server/default/conf/access-grant/sql-scripts/"
    $acct_linking_script_dir = "${::pingfederate::install_dir}/server/default/conf/account-linking/sql-scripts/"
    case $::pingfederate::oauth_jdbc_type {
      'mysql': {
        $def_pkgs              = ['mysql','mysql-connector-java']
        $def_jar_dir           = '/usr/share/java'
        $def_jar               = 'mysql-connector-java.jar'
        $def_nexus             = undef # JAR is contained in an RPM package
        $def_maven             = 'http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.12/mysql-connector-java-8.0.12.jar'
        $def_validate          = 'SELECT 1 from dual'
        $def_driver            = 'com.mysql.jdbc.Driver'
        $portstr               = if $::pingfederate::oauth_jdbc_port { ":${::pingfederate::oauth_jdbc_port}" } else { '' }
        $def_url               = "jdbc:mysql://${oauth_jdbc_host}${portstr}/${oauth_jdbc_db}?autoReconnect=true"
        $oauth_client_script   = 'oauth-client-management-mysql.sql'
        $oauth_access_script1  = 'access-grant-mysql.sql'
        $oauth_access_script2  = 'access-grant-attribute-mysql.sql'
        $acct_linking_script   = 'account-linking-mysql.sql'
        # allow database exists error or no output
        $def_create            = @("END"/L)
          /usr/bin/mysqladmin \
            --wait \
            --connect_timeout=30 \
            --host=${::pingfederate::oauth_jdbc_host} \
            --port=${::pingfederate::oauth_jdbc_port} \
            --user=${::pingfederate::oauth_jdbc_user} \
            --password=\"${::pingfederate::oauth_jdbc_pass}\" \
            create ${::pingfederate::oauth_jdbc_db} \
          | /bin/awk '/database exists/{exit 0}/./{exit 1}'
          |-END
        # allow 1050 (table already exists) or no output
        $def_oauth_client_cmd  = @("END"/L)
          /usr/bin/mysql \
            --wait --connect_timeout=30 \
            --host=${::pingfederate::oauth_jdbc_host} \
            --port=${::pingfederate::oauth_jdbc_port} \
            --user=${::pingfederate::oauth_jdbc_user} \
            --password=\"${::pingfederate::oauth_jdbc_pass}\" \
            --database=${::pingfederate::oauth_jdbc_db} \
            < ${oauth_client_script_dir}/${oauth_client_script} \
          | /bin/awk '/ERROR 1050/{exit 0}/./{exit 1}'
          |-END
        # kludge to deal with a back-level mysql < 5.6
        $def_oauth_access_cmd  = @("END"/L)
          /bin/cat ${oauth_access_script_dir}/${oauth_access_script1} ${oauth_access_script_dir}/${oauth_access_script2} \
          | /bin/sed -e 's/default CURRENT_TIMESTAMP//' \
          | /usr/bin/mysql \
            --wait --connect_timeout=30 \
            --host=${::pingfederate::oauth_jdbc_host} \
            --port=${::pingfederate::oauth_jdbc_port} \
            --user=${::pingfederate::oauth_jdbc_user} \
            --password=\"${::pingfederate::oauth_jdbc_pass}\" \
            --database=${::pingfederate::oauth_jdbc_db} \
          | /bin/awk '/ERROR 1050/{exit 0}/./{exit 1}'
          |-END
        $def_acct_linking_cmd  = @("END"/L)
          /usr/bin/mysql \
            --wait --connect_timeout=30 \
            --host=${::pingfederate::oauth_jdbc_host} \
            --port=${::pingfederate::oauth_jdbc_port} \
            --user=${::pingfederate::oauth_jdbc_user} \
            --password=\"${::pingfederate::oauth_jdbc_pass}\" \
            --database=${::pingfederate::oauth_jdbc_db} \
            < ${acct_linking_script_dir}/${acct_linking_script} \
          | /bin/awk '/ERROR 1050/{exit 0}/./{exit 1}'
          |-END
      }
      'sqlserver': {
        $def_jar_dir           = '/usr/share/java'
        $v                     = '7.0.0.jre8'
        $def_jar               = "mssql-jdbc-${v}.jar"
        $def_pkgs              = undef # no RPM pkg for the JAR, need to use nexus repo
        $def_nexus             = undef
        $def_maven             = "http://central.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/${v}/${def_jar}"
        $def_driver            = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
        $def_validate          = 'SELECT getdate()'
        $portstr               = if $::pingfederate::oauth_jdbc_port { ":${::pingfederate::oauth_jdbc_port}" } else { '' }
        $def_url               = "jdbc:sqlserver://${oauth_jdbc_host}${portstr};databaseName=${oauth_jdbc_db}"
        $oauth_client_script   = 'oauth-client-management-sqlserver.sql'
        $oauth_access_script1  = 'access-grant-sqlserver.sql'
        $oauth_access_script2  = 'access-grant-attribute-sqlserver.sql'
        $acct_linking_script   = 'account-linking-sqlserver.sql'
        $sqlcmd_nodb           =  @("END"/L)
          /opt/mssql-tools/bin/sqlcmd \
            -l 30 \
            -S ${::pingfederate::oauth_jdbc_host},${::pingfederate::oauth_jdbc_port} \
            -U ${::pingfederate::oauth_jdbc_user} \
            -P ${::pingfederate::oauth_jdbc_pass}
          |-END
        $sqlcmd                = "${sqlcmd_nodb} -d ${::pingfederate::oauth_jdbc_db}"
        # allow database exists error or no output
        $def_create            = @("END"/L)
          ${sqlcmd_nodb} -Q \"create database ${::pingfederate::oauth_jdbc_db}\" \
          | /bin/awk '/Msg 1801,/{exit 0}/Msg 262,/{exit 0}/./{exit 1}'
          |-END
        # allow 2714 (table already exists) or no output
        $def_oauth_client_cmd  = @("END"/L)
          ${sqlcmd} -i ${oauth_client_script_dir}/${oauth_client_script} \
          | /bin/awk '/Msg 2714/{exit 0}/./{exit 1}'
          |-END
        $def_oauth_access_cmd  = @("END"/L)
          ${sqlcmd} -i ${oauth_access_script_dir}/${oauth_access_script1} \
          && ${sqlcmd} -i ${oauth_access_script_dir}/${oauth_access_script2} \
          | /bin/awk '/Msg 2714/{exit 0}/./{exit 1}'
          |-END
        $def_acct_linking_cmd  = @("END"/L)
          ${sqlcmd} -i ${acct_linking_script_dir}/${acct_linking_script} \
          | /bin/awk '/Msg 2714/{exit 0}/./{exit 1}'
          |-END
      }
      'oracle': {
        # TBD
        fail("Config code for database type ${::pingfederate::oauth_jdbc_type} incomplete.")
      }
      'other': {               # everything must be set in $::pingfederate::oauth_jdbc_*
        $def_pkgs              = undef
        $def_jar_dir           = undef
        $def_jar               = undef
        $def_nexus             = undef
        $def_maven             = undef
        $def_validate          = undef
        $def_driver            = undef
        $def_url               = undef
        $def_create            = undef
        $def_oauth_client_cmd  = undef
        $def_oauth_access_cmd  = undef
        $def_acct_linking_cmd  = undef
      }
      default: { fail("Don't know to configure for database type ${::pingfederate::oauth_jdbc_type}.") }
    }

    # (optionally) override defaults from above
    $o_pkgs     = if $::pingfederate::oauth_jdbc_package_list { $::pingfederate::oauth_jdbc_package_list } else { $def_pkgs }
    $o_jar_dir  = if $::pingfederate::oauth_jdbc_jar_dir { $::pingfederate::oauth_jdbc_jar_dir } else { $def_jar_dir }
    $o_jar      = if $::pingfederate::oauth_jdbc_jar { $::pingfederate::oauth_jdbc_jar } else { $def_jar }
    $o_nexus    = if $::pingfederate::oauth_jdbc_nexus { $::pingfederate::oauth_jdbc_nexus } else { $def_nexus }
    $o_maven    = if $::pingfederate::oauth_jdbc_maven { $::pingfederate::oauth_jdbc_maven } else { $def_maven }
    $o_validate = if $::pingfederate::oauth_jdbc_validate { $::pingfederate::oauth_jdbc_validate } else { $def_validate }
    $o_driver   = if $::pingfederate::oauth_jdbc_driver { $::pingfederate::oauth_jdbc_driver } else { $def_driver }
    $o_url      = if $::pingfederate::oauth_jdbc_url { $::pingfederate::oauth_jdbc_url } else { $def_url }
    $o_create   = if $::pingfederate::oauth_jdbc_create_cmd { $::pingfederate::oauth_jdbc_create_cmd } else { $def_create }
    $o_c_cmd    = if $::pingfederate::oauth_jdbc_client_ddl_cmd { $::pingfederate::oauth_jdbc_client_ddl_cmd }
                  else { $def_oauth_client_cmd }
    $o_a_cmd    = if $::pingfederate::oauth_jdbc_access_ddl_cmd { $::pingfederate::oauth_jdbc_access_ddl_cmd }
                  else { $def_oauth_access_cmd }
    $a_l_cmd    = if $::pingfederate::acct_jdbc_linking_ddl_cmd { $::pingfederate::acct_jdbc_ddl_linking_cmd }
                  else { $def_acct_linking_cmd }
  }

  # need to do more validation...

  # Install the package(s), configure the pre-runtime settings, start the service, and administer the post-startup settings.
  anchor { 'pingfederate::begin': }
  -> class { '::pingfederate::install': }
  -> class { '::pingfederate::config': }
  ~> class { '::pingfederate::service': }
  -> class { '::pingfederate::admin': }
  -> anchor { 'pingfederate::end': }

}
