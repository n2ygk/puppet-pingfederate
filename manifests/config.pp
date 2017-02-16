# Class pingfederate::config
# Static configuration of the server.
# Edits run.properties, various XML config files, license acceptance,
# license key, etc. that can be installed prior to starting the server.
# Additional configuration happens after the server is running. See pingfederarte::admin.
class pingfederate::config inherits ::pingfederate {
  $defaults = {'path' => "${::pingfederate::install_dir}/bin/run.properties"}
  # The syntax required is for each list element is "hostname[port]".
  # The "right" way to get the port would be to use exported resources... For now, just use our value.
  if $::pingfederate::cluster_tcp_discovery_initial_hosts {
    $dharray = $::pingfederate::cluster_tcp_discovery_initial_hosts.map |$i| { "${i}[${::pingfederate::cluster_bind_port}]" }
    $dhstring = join($dharray,',')
  }
  else {
    $dhstring = undef
  }
  $settings = {
    '' => { # this Java properties file has no sections so the section name is ''
      'pf.admin.https.port'                    => $::pingfederate::admin_https_port,
      'pf.admin.hostname'                      => $::pingfederate::admin_hostname,
      'pf.console.bind.address'                => $::pingfederate::console_bind_address,
      'pf.console.title'                       => $::pingfederate::console_title,
      'pf.console.session.timeout'             => $::pingfederate::console_session_timeout,
      'pf.console.login.mode'                  => $::pingfederate::console_login_mode,
      'pf.console.authentication'              => $::pingfederate::console_authentication,
      'pf.admin.api.authentication'            => $::pingfederate::admin_api_authentication,
      'pf.http.port'                           => $::pingfederate::http_port,
      'pf.https.port'                          => $::pingfederate::https_port,
      'pf.secondary.https.port'                => $::pingfederate::secondary_https_port,
      'pf.engine.bind.address'                 => $::pingfederate::engine_bind_address,
      'pf.monitor.bind.address'                => $::pingfederate::monitor_bind_address,
      'pf.log.eventdetail'                     => $::pingfederate::log_eventdetail,
      'pf.heartbeat.system.monitoring'         => $::pingfederate::heartbeat_system_monitoring,
      'pf.operational.mode'                    => $::pingfederate::operational_mode,
      'pf.cluster.node.index'                  => $::pingfederate::cluster_node_index,
      'pf.cluster.auth.pwd'                    => $::pingfederate::cluster_auth_pwd,
      'pf.cluster.encrypt'                     => $::pingfederate::cluster_encrypt,
      'pf.cluster.bind.address'                => $::pingfederate::cluster_bind_address,
      'pf.cluster.bind.port'                   => $::pingfederate::cluster_bind_port,
      'pf.cluster.failure.detection.bind.port' => $::pingfederate::cluster_failure_detection_bind_port,
      'pf.cluster.transport.protocol'          => $::pingfederate::cluster_transport_protocol,
      'pf.cluster.mcast.group.address'         => $::pingfederate::cluster_mcast_group_address,
      'pf.cluster.mcast.group.port'            => $::pingfederate::cluster_mcast_group_port,
      'pf.cluster.tcp.discovery.initial.hosts' => $dhstring,
      'pf.cluster.diagnostics.enabled'         => $::pingfederate::cluster_diagnostics_enabled,
      'pf.cluster.diagnostics.addr'            => $::pingfederate::cluster_diagnostics_addr,
      'pf.cluster.diagnostics.port'            => $::pingfederate::cluster_diagnostics_port,
    }
  }
  create_ini_settings($settings, $defaults)

  # install license acceptance file
  $license_accept =  @("ACCEPT")
                     <?xml version="1.0" encoding="UTF-8"?>
                     <con:config xmlns:con="http://www.sourceid.org/2004/05/config">
                         <con:map name="license-map">
                             <con:item name="initial-setup-done">true</con:item>
                             <con:item name="license-agreement-accepted">true</con:item>
                         </con:map>
                     </con:config>
                     | ACCEPT
  file {"${::pingfederate::install_dir}/server/default/data/config-store/com.pingidentity.page.Login.xml":
    ensure  => 'present',
    content => $license_accept,
    owner   => $::pingfederate::owner,
    group   => $::pingfederate::group,
    
  }
  # install license file
  $lic_file = "${::pingfederate::install_dir}/server/default/conf/pingfederate.lic"
  if $::pingfederate::license_file {
    file {$lic_file:
      ensure => 'present',
      source => $::pingfederate::license_file,
      owner  => $::pingfederate::owner,
      group  => $::pingfederate::group,
    }
  } elsif $::pingfederate::license_content {
    file {$lic_file:
      ensure  => 'present',
      content => $::pingfederate::license_content,
      owner   => $::pingfederate::owner,
      group   => $::pingfederate::group,
    }
  }
  # create initial administrator user so that we can invoke the rest APIs
  $adm_file = "$::pingfederate::install_dir/server/default/data/pingfederate-admin-user.xml"
  augeas{$adm_file:
    lens    => 'Xml.lns',
    incl    => $adm_file,
    context => "/files/${adm_file}",
    changes => ['set adm:administrative-users/#attribute/xmlns:adm "http://pingidentity.com/2006/01/admin-users"',
                'set adm:administrative-users/#attribute/multi-admin "true"',
                "set adm:administrative-users/adm:user/adm:user-name/#text \"${::pingfederate::adm_user}\"",
                'clear adm:administrative-users/adm:user/adm:salt',
                "set adm:administrative-users/adm:user/adm:hash/#text \"${::pingfederate::adm_hash}\"",
                'set adm:administrative-users/adm:user/adm:phone-number/#attribute/xsi:nil "true"',
                'set adm:administrative-users/adm:user/adm:phone-number/#attribute/xmlns:xsi "http://www.w3.org/2001/XMLSchema-instance"',
                'set adm:administrative-users/adm:user/adm:email-address/#attribute/xsi:nil "true"',
                'set adm:administrative-users/adm:user/adm:email-address/#attribute/xmlns:xsi "http://www.w3.org/2001/XMLSchema-instance"',
                'set adm:administrative-users/adm:user/adm:phone-number/#attribute/xsi:nil "true"',
                'set adm:administrative-users/adm:user/adm:phone-number/#attribute/xmlns:xsi "http://www.w3.org/2001/XMLSchema-instance"',
                'set adm:administrative-users/adm:user/adm:department/#attribute/xsi:nil "true"',
                'set adm:administrative-users/adm:user/adm:department/#attribute/xmlns:xsi "http://www.w3.org/2001/XMLSchema-instance"',
                'set adm:administrative-users/adm:user/adm:description/#text "Initial administrator user"',
                'set adm:administrative-users/adm:user/adm:admin-manager/#text "true"',
                'set adm:administrative-users/adm:user/adm:admin/#text "true"',
                'set adm:administrative-users/adm:user/adm:crypto-manager/#text "true"',
                'set adm:administrative-users/adm:user/adm:auditor/#text "false"',
                'set adm:administrative-users/adm:user/adm:active/#text "true"',
                'set adm:administrative-users/adm:user/adm:password-change-required/#text "false"']
  }

  # Create local built-in SAML2 IdP so the adm_user can login
  # N.B. This stuff gets changed when pf-admin-api calls are used to configured SPs and IdPs which can lead to
  # thrashing each time puppet runs if the exact same values are not synchronized.
  # XXX Don't configure this if CLUSTERED_ENGINE since this gets pushed from the CLUSTERED_CONSOLE???
  $saml_file = "$::pingfederate::install_dir/server/default/data/sourceid-saml2-local-metadata.xml"
  augeas{$saml_file:
    lens    => 'Xml.lns',
    incl    => $saml_file,
    context => "/files/${saml_file}",
    changes =>
    [
     "set EntityDescriptor/#attribute/entityID \"${::pingfederate::saml2_local_entityID}\"",
     'set EntityDescriptor/#attribute/cacheDuration "PT1440M"',
     "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/BaseURL \"${::pingfederate::service_api_baseURL}\"",
     "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/DynaFedID \"${::pingfederate::service_api_baseURL}\"",
     "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/Saml1xId \"${::pingfederate::saml1_local_issuerID}\"",
     "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/WsFedID \"${::pingfederate::wsfed_local_realm}\"",
     "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/CustomGlobalHttpHeaderName \"${::pingfederate::http_forwarded_for_header}\"",
     "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ForwardedHostHeaderName \"${::pingfederate::http_forwarded_host_header}\"",
     ]
  }

  # enable OGNL expressions
  $ognl_file = "$::pingfederate::install_dir/server/default/data/config-store/org.sourceid.common.ExpressionManager.xml"
  augeas{$ognl_file:
    lens    => 'Xml.lns',
    incl    => $ognl_file,
    context => "/files/${ognl_file}",
    changes => ['set config/item/#attribute/name/ "evaluateExpressions"',
                "set config/item/#text \"${::pingfederate::ognl_expressions_enable}\""]
  }

  # enable CORS
  if $::pingfederate::cors_allowedOrigins {
      $cors_file = "$::pingfederate::install_dir/etc/webdefault.xml"
      augeas{$cors_file:
        lens    => 'Xml.lns',
        incl    => $cors_file,
        context => "/files/${cors_file}",
        changes => ['set web-app/filter/filter-name/#text "cross-origin"',
                    'set web-app/filter/filter-class/#text "org.eclipse.jetty.servlets.CrossOriginFilter"',
                    'set web-app/filter/init-param[1]/param-name/#text "allowedOrigins"',
                    "set web-app/filter/init-param[1]/param-value/#text \"${::pingfederate::cors_allowedOrigins}\"",
                    'set web-app/filter/init-param[2]/param-name/#text "allowedMethods"',
                    "set web-app/filter/init-param[2]/param-value/#text \"${::pingfederate::cors_allowedMethods}\"",
                    'set web-app/filter-mapping/filter-name/#text "cross-origin"',
                    "set web-app/filter-mapping/url-pattern/#text \"${::pingfederate::cors_filter_mapping}\""]
      }
  }

  # configure JDBC implementation
  $hive_file = "$::pingfederate::install_dir/server/default/conf/META-INF/hivemodule.xml"
  if $::pingfederate::oauth_jdbc_type {
    augeas{$hive_file:
      lens    => 'Xml.lns',
      incl    => $hive_file,
      context => "/files/${hive_file}",
      changes => ['set module/service-point[#attribute/id="ClientManager"][#attribute/interface="org.sourceid.oauth20.domain.ClientManager"]/invoke-factory/construct/#attribute/class "org.sourceid.oauth20.domain.ClientManagerJdbcImpl']
    }
  }
  else {                        # (revert JDBC back to) XML file implementation
    augeas{$hive_file:
      lens    => 'Xml.lns',
      incl    => $hive_file,
      context => "/files/${hive_file}",
      changes => ['set module/service-point[#attribute/id="ClientManager"][#attribute/interface="org.sourceid.oauth20.domain.ClientManager"]/invoke-factory/construct/#attribute/class "org.sourceid.oauth20.domain.ClientManagerXmlFileImpl"']
    }
  }

  # Configure log4j2 to set logging levels. Easier to just do a cron job to delete old files!
  # https://docs.pingidentity.com/bundle/pf_sm_managePingfederateLogs_pf83/page/pf_c_log4j2LoggingServiceAndConfiguration.html
  # Want to set logfile rollover to daily with file retention to $log_retain_days.
  # XXX max only works for %i filePattern! Recode all the date-based logs to %i? Too much work!
  $log4_file = "$::pingfederate::install_dir/server/default/conf/log4j2.xml"
  augeas{$log4_file:
    lens    => 'Xml.lns',
    incl    => $log4_file,
    context => "/files/${log4_file}",
    changes =>
    [
     "set Configuration/Loggers/Logger[#attribute/name=\"httpclient.wire.content\"]/#attribute/level ${pingfederate::log_httpclient}",
     "set Configuration/Loggers/Logger[#attribute/name=\"org.sourceid\"]/#attribute/level ${pingfederate::log_org_sourceid}",
     ]
  }
}
