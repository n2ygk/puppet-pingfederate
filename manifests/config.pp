# Class pingfederate::config
# Static configuration of the server.
# Edits run.properties, various XML config files, license acceptance,
# license key, etc. that can be installed prior to starting the server.
# Additional configuration happens after the server is running. See pingfederarte::admin.
class pingfederate::config inherits ::pingfederate {
  # apparently the augeas-1.4 Properties.lens doesn't work!
  # this throws a parser error:
  # augeas{'run.properties':
  #   lens    => 'Properties.lns',
  #   incl    => "$::pingfederate::install_dir/bin/run.properties",
  #   changes => ['set "abc.def" "2345"']
  #}

  # use inifile for this and augeas for the XML files
  $defaults = {'path' => "${::pingfederate::install_dir}/bin/run.properties"}
  # this Java properties file has no sections so the section name is ''
  $settings = {
    '' => {
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
      'pf.cluster.tcp.discovery.initial.hosts' => join($::pingfederate::cluster_tcp_discovery_initial_hosts,',')
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

  # create local built-in SAML2 IdP so the adm_user can login
  # N.B. This stuff gets changed when pf-admin-api calls are used to configured SPs and IdPs.
  # Make sure you sync up all the attributes.
  $saml_file = "$::pingfederate::install_dir/server/default/data/sourceid-saml2-local-metadata.xml"
  # XXX or, just don't manage these fields via Augeas!
  # $EnableWsFedSP = 'true' if ${::pingfederate::wsfed_local_realm} else 'false'
  # if $::pingfederate::saml2_local_entityID {
  #   $EnableSaml20IdP = 'true'
  #   $EnableSaml20Sp = 'true'
  # }
  # if $::pingfederate::saml1_local_issuerID {  
  #   $EnableSaml11Rp = "true"
  #   $EnableSaml10Rp = 'true'
  #   $EnableSpWsTrustSts = 'true'
  #   $EnableIdpDynaFed = 'true'
  # }
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
     ]
    # XXX don't set things that get changed from elsewhere and the defaults are fine.
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/Saml1xSrcId ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableWsFedIdP "false"',
     # "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableWsFedSp \"${EnableWsFedSP}\"",
     # "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableSaml20IdP \"${EnableSaml20IdP}\"",
     # "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableSaml20Sp  \"${EnableSaml20Sp}\"",
     # "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableSaml11Rp \"${EnableSaml11Rp}\"",
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableSaml11Ap "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableSaml10Rp "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableSaml10Ap "false"',
     # "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableSpWsTrustSts \"${EnableSpWsTrustSts}\"",
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableInboundProvisioning "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableIdpWsTrustSts "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableX509Discovery "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableIdpDiscovery "false"',
     # "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableIdpDynaFed \"${EnableIdpDynaFed\"",
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableSpDynaFed "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/DisableAutomaticConnectionValidation "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/DataStoreValidationInterval "300"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/CustomGlobalHttpHeaderName ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ClientIpHeaderIndex "last"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ForwardedHostHeaderName ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ForwardedHostHeaderIndex "last"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ProxyTerminatesHttpsConns "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/MetadataSigningKeyAlias ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/MetadataSigningAlgorithm ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/MetadataSigningKeyMD5Fingerprint ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ConfirmIdpSlo "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ClientCertSSLHeaderName ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ClientCertChainSSLHeaderName ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/EnableOIDCSp "false"',
     # 'clear EntityDescriptor/Extensions/sid:SourceIDExtension/sid:ApplicationURLs',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:IdpDiscovery/#attribute/CommonDomainServer "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:IdpDiscovery/#attribute/IdPCommonDomainClient "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:IdpDiscovery/#attribute/SPCommonDomainClient "false"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:IdpDiscovery/#attribute/WriteCookiePath "/writecookie.cdc"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:IdpDiscovery/#attribute/ReadCookiePath "/readcookie.cdc"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:IdpDiscovery/sid:CommonDomainClient/#attribute/CommonDomainServiceBaseUrl ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:IdpDiscovery/sid:CommonDomainService/#attribute/CommonDomain ""',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:IdpDiscovery/sid:CommonDomainService/#attribute/CookieLifeDays "365"',
     # 'set EntityDescriptor/Extensions/sid:SourceIDExtension/sid:ErrPageMsg/#text "errorDetail.idpSsoFailure"']
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
                
}
