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
      'pf.log.dir'                             => $::pingfederate::log_dir,
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

  mkdir::p {$::pingfederate::log_dir:
    owner => $::pingfederate::owner,
    group => $::pingfederate::group,
    mode  => '0750',
  }

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
  $adm_file = "${::pingfederate::install_dir}/server/default/data/pingfederate-admin-user.xml"
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
  $saml_file = "${::pingfederate::install_dir}/server/default/data/sourceid-saml2-local-metadata.xml"
  augeas{$saml_file:
    lens    => 'Xml.lns',
    incl    => $saml_file,
    context => "/files/${saml_file}",
    changes =>
    [
      "set EntityDescriptor/#attribute/entityID \"${::pingfederate::saml2_local_entityid}\"",
      'set EntityDescriptor/#attribute/cacheDuration "PT1440M"',
      "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/BaseURL \"${::pingfederate::service_api_baseurl}\"",
      "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/DynaFedID \"${::pingfederate::service_api_baseurl}\"",
      "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/Saml1xId \"${::pingfederate::saml1_local_issuerid}\"",
      "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/WsFedID \"${::pingfederate::wsfed_local_realm}\"",
      "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/CustomGlobalHttpHeaderName\
        \"${::pingfederate::http_forwarded_for_header}\"",
      "set EntityDescriptor/Extensions/sid:SourceIDExtension/#attribute/ForwardedHostHeaderName\
        \"${::pingfederate::http_forwarded_host_header}\""]
  }

  # enable OGNL expressions
  $ognl_file = "${::pingfederate::install_dir}/server/default/data/config-store/org.sourceid.common.ExpressionManager.xml"
  augeas{$ognl_file:
    lens    => 'Xml.lns',
    incl    => $ognl_file,
    context => "/files/${ognl_file}",
    changes => ['set config/item/#attribute/name/ "evaluateExpressions"',
                "set config/item/#text \"${::pingfederate::ognl_expressions_enable}\""]
  }

  # enable CORS (for version < 9.0; in >= 9.0, this is now an oauth configuration setting)
  # This adds a new CrossOriginFilter and enables the OPTIONS method in the security-constraint
  # Adding OPTIONS involves appending a new entry to web-resource-collection for url-pattern="/*"
  # and changing the documentation of that node to indicate OPTIONS is now permitted.
  if $::pingfederate::cors_allowedorigins and $::pingfederate::package_ensure < '9' {
      $cors_file = "$::{pingfederate::install_dir}/etc/webdefault.xml"
      augeas{$cors_file:
        lens    => 'Xml.lns',
        incl    => $cors_file,
        context => "/files/${cors_file}",
        changes => [
                    'set web-app/filter/filter-name/#text "cross-origin"',
                    'set web-app/filter/filter-class/#text "org.eclipse.jetty.servlets.CrossOriginFilter"',
                    'set web-app/filter/init-param[1]/param-name/#text "allowedOrigins"',
                    "set web-app/filter/init-param[1]/param-value/#text \"${::pingfederate::cors_allowedorigins}\"",
                    'set web-app/filter/init-param[2]/param-name/#text "allowedMethods"',
                    "set web-app/filter/init-param[2]/param-value/#text \"${::pingfederate::cors_allowedmethods}\"",
                    'set web-app/filter/init-param[3]/param-name/#text "allowedHeaders"',
                    "set web-app/filter/init-param[3]/param-value/#text \"${::pingfederate::cors_allowedheaders}\"",
                    'set web-app/filter-mapping/filter-name/#text "cross-origin"',
                    "set web-app/filter-mapping/url-pattern/#text \"${::pingfederate::cors_filter_mapping}\"",
                    @(END/L),
                    set web-app/security-constraint/web-resource-collection\
                    /url-pattern[./#text="/*"]/../http-method[#text="OPTIONS" and (last()+1)]/#text "OPTIONS"
                    |-END
                    @(END/L),
                    set web-app/security-constraint/web-resource-collection\
                    /url-pattern[./#text="/*"]/../web-resource-name/#text\
                      "Enable all methods except for TRACE (OPTIONS was added for OAuth 2.0 XHR)"
                    |-END
                    ]
      }
  }

  # configure JDBC implementation
  $hive_file = "${::pingfederate::install_dir}/server/default/conf/META-INF/hivemodule.xml"
  if $::pingfederate::oauth_jdbc_type {
    augeas{$hive_file:
      lens    => 'Xml.lns',
      incl    => $hive_file,
      context => "/files/${hive_file}",
      changes => [
        @(END/L)
        set module/service-point[#attribute/id="ClientManager"][#attribute/interface="org.sourceid.oauth20.domain.ClientManager"]\
        /invoke-factory/construct/#attribute/class "org.sourceid.oauth20.domain.ClientManagerJdbcImpl"
        |-END
      ],
    }
  }
  else {                        # (revert JDBC back to) XML file implementation
    augeas{$hive_file:
      lens    => 'Xml.lns',
      incl    => $hive_file,
      context => "/files/${hive_file}",
      changes => [
                  @(END/L)
                  set module/service-point[#attribute/id="ClientManager"]\
                  [#attribute/interface="org.sourceid.oauth20.domain.ClientManager"]\
                  /invoke-factory/construct/#attribute/class "org.sourceid.oauth20.domain.ClientManagerXmlFileImpl"
                  |-END
                  ]
    }
  }

  # Configure log4j2 and Jetty to set logging levels.
  # Want to set logfile rollover to daily with file retention to $log_retain_days.

  # This is all highly dependent on how PingFederate delivers their log4j2.xml file.
  # <Configuration ...>
  #     <Appenders>
  #         <RollingFile name="FILE" fileName="${sys:pf.log.dir}/server.log"
  #                      filePattern="${sys:pf.log.dir}/server.log.%i" ignoreExceptions="false">
  #             <PatternLayout>
  #                 <!-- Uncomment this if you want to use UTF-8 encoding instead
  #                     of system's default encoding.
  #                 <charset>UTF-8</charset> -->
  #                 <pattern>%d %X{trackingid} %-5p [%c] %m%n</pattern>
  #             </PatternLayout>
  #             <Policies>
  #                 <SizeBasedTriggeringPolicy
  #                         size="10000 KB" />
  #             </Policies>
  #             <DefaultRolloverStrategy max="5" />
  #         </RollingFile>
  #         <!-- ... -->
  #     </Appenders>
  #     <!-- ... -->
  #     <Loggers>
  #         <Logger name="httpclient.wire.content" level="INFO" />
  #         <Logger name="com.pingidentity.pf.email" level="INFO" />
  #         <Logger name="org.sourceid" level="DEBUG" />
  #         <!-- ... -->
  #     </Loggers>
  #     <!-- ... -->
  # </Configuration>

  # log level settings. List of maps keyed by name and level.
  $log4_loggers = $::pingfederate::log_levels.map |$i| {
    "set Configuration/Loggers/Logger[#attribute/name=\"${i['name']}\"]/#attribute/level ${i['level']}"
  }

  # List of RollingFile settings to override. Set each to daily rollover and retain $log_retain_days copies
  # List of maps keyed by name, fileName, filePattern.
  # Sets the fileName, filePattern, removes any extant Policies, adds daily CronTriggeringPolicy and max retension days.
  $log4_rollers = $::pingfederate::log_files.map |$i| {
    [
      "set Configuration/Appenders/RollingFile[#attribute/name=\"${i['name']}\"]/#attribute/fileName \${sys:pf.log.dir}/${i['fileName']}", # lint:ignore:140chars
      "set Configuration/Appenders/RollingFile[#attribute/name=\"${i['name']}\"]/#attribute/filePattern \${sys:pf.log.dir}/${i['filePattern']}", # lint:ignore:140chars
      "rm Configuration/Appenders/RollingFile[#attribute/name=\"${i['name']}\"]/Policies",
      "set Configuration/Appenders/RollingFile[#attribute/name=\"${i['name']}\"]/CronTriggeringPolicy/#attribute/schedule \"0 0 0 * * ?\"", # lint:ignore:140chars
      "set Configuration/Appenders/RollingFile[#attribute/name=\"${i['name']}\"]/DefaultRolloverStrategy/#attribute/max ${::pingfederate::log_retain_days}", # lint:ignore:140chars
    ]
  }

  $log4_do = flatten($log4_loggers) + flatten($log4_rollers)
  $log4_file = "${::pingfederate::install_dir}/server/default/conf/log4j2.xml"
  augeas{$log4_file:
    lens    => 'Xml.lns',
    incl    => $log4_file,
    context => "/files/${log4_file}",
    changes => $log4_do,
  }

  ###
  # udpdates to configure these parts of jetty-admin.xml:
  #  - RequestLog retainDays
  #  - org.eclipse.jetty.server.Request.maxFormContentSize
  #  - org.eclipse.jetty.server.Request.maxFormKeys
  ###

  $jetty_adm_file = "$::pingfederate::install_dir/etc/jetty-admin.xml"

  # Here's a portion of the really ugly nested XML doc:
  # <Configure id="AdminServer" class="org.eclipse.jetty.server.Server">
  #     <Set name="handler">
  #         <New id="Handlers" class="org.eclipse.jetty.server.handler.HandlerCollection">
  #             <Set name="handlers">
  #                 <Array type="org.eclipse.jetty.server.Handler">
  #                     <Item>
  #                         <New id="Contexts" class="org.eclipse.jetty.server.handler.ContextHandlerCollection"/>
  #                     </Item>
  #                     <Item>
  #                         <New id="RequestLog" class="org.eclipse.jetty.server.handler.RequestLogHandler">
  #                               <Set name="requestLog">
  #                                 <New id="RequestLogImpl" class="org.eclipse.jetty.server.NCSARequestLog">
  #                                        <Set name="filename"><SystemProperty name="pf.log.dir" default="."/>/yyyy_mm_dd.request2.log</Set>
  #                                        <Set name="filenameDateFormat">yyyy_MM_dd</Set>
  #                                        <Set name="retainDays">90</Set>
  #                                        <Set name="append">true</Set>
  #                                        <Set name="extended">true</Set>
  #                                        <Set name="logCookies">false</Set>
  #                                        <Set name="LogTimeZone">GMT</Set>
  #                                 </New>
  #                               </Set>
  #                         </New>
  #                     </Item>
  #                 </Array>
  #             </Set>
  #         </New>
  #     </Set>
  #     <!-- ... -->
  #     <Call name="setAttribute">
  #         <Arg>org.eclipse.jetty.server.Request.maxFormContentSize</Arg>
  #         <Arg>1000000</Arg>
  #     </Call>
  #     <Call name="setAttribute">
  #         <Arg>org.eclipse.jetty.server.Request.maxFormKeys</Arg>
  #         <Arg>20000</Arg>
  #     </Call>
  # </Configure>
  # All these entries already exist in the delivered file, so just need to edit the values.
  # each of $adm_cfgN is a single-line set command.
  $adm_cfg1 = @("EoF"/L)
    set Configure[#attribute/id="AdminServer"]\
    /Set[#attribute/name="handler"]\
    /New[#attribute/id="Handlers"]\
    /Set[#attribute/name="handlers"]\
    /Array[#attribute/type="org.eclipse.jetty.server.Handler"]\
    /Item\
    /New[#attribute/id="RequestLog"]\
    /Set[#attribute/name="requestLog"]\
    /New[#attribute/id="RequestLogImpl"]\
    /Set[#attribute/name="retainDays"]/#text ${::pingfederate::log_retain_days}
    |-EoF
  $adm_cfg2 = @("EoF"/L)
    set Configure[#attribute/id="AdminServer"]\
    /Call[#attribute/name="setAttribute"]\
    /Arg[#text="org.eclipse.jetty.server.Request.maxFormContentSize"]\
    /../Arg[2]/#text ${::pingfederate::jetty_max_form_content_size}
    |-EoF
  $adm_cfg3 = @("EoF"/L)
    set Configure[#attribute/id="AdminServer"]\
    /Call[#attribute/name="setAttribute"]\
    /Arg[#text="org.eclipse.jetty.server.Request.maxFormKeys"]\
    /../Arg[2]/#text ${::pingfederate::jetty_max_form_keys}
    |-EoF
  augeas{$jetty_adm_file:
    lens    => 'Xml.lns',
    incl    => $jetty_adm_file,
    context => "/files/${jetty_adm_file}",
    changes => [ "${adm_cfg1}",
                 "${adm_cfg2}",
                 "${adm_cfg3}" ]
  }

  ###
  # udpdates to configure these parts of jetty-runtime.xml:
  #  - RequestLog retainDays
  #  - org.eclipse.jetty.server.Request.maxFormContentSize
  #  - org.eclipse.jetty.server.Request.maxFormKeys
  ###

  $jetty_run_file = "$::pingfederate::install_dir/etc/jetty-runtime.xml"
  $run_cfg1 = @("EoF"/L)
    set Configure[#attribute/id="RuntimeServer"]\
    /Set[#attribute/name="handler"]\
    /New[#attribute/id="Handlers"]\
    /Set[#attribute/name="handlers"]\
    /Array[#attribute/type="org.eclipse.jetty.server.Handler"]\
    /Item\
    /New[#attribute/id="RequestLog"]\
    /Set[#attribute/name="requestLog"]\
    /New[#attribute/id="RequestLogImpl"]\
    /Set[#attribute/name="retainDays"]/#text ${::pingfederate::log_retain_days}
    |-EoF
  augeas{$jetty_run_file:
    lens    => 'Xml.lns',
    incl    => $jetty_run_file,
    context => "/files/${jetty_run_file}",
    changes => [ "${run_cfg1}" ]
  }

  # Unlike above, org...maxFormContentSize & maxFormKeys are NOT present in the delivered
  # file. So we need to use onlyif to add them if missing or edit them if present.

  # if <Configure...><Call name="setAttribute">... is missing:
  $run_set_attr_missing = @("EoF"/L)
    match Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"] size == 0
    |-EoF
  $run_add_set_attr =  @("EoF"/L)
    set Configure[#attribute/id="RuntimeServer"]/Call[last()+1]/#attribute/name "setAttribute"
    |-EoF
  augeas{"${jetty_run_file}_set_attr_missing":
    lens    => 'Xml.lns',
    incl    => $jetty_run_file,
    context => "/files/${jetty_run_file}",
    onlyif  => $run_set_attr_missing,
    changes => [ "${run_add_set_attr}" ],
    before => Augeas["${jetty_run_file}_max_form_size_missing"]
  }

  # if <Configure...><Call name="setAttribute"><Arg>org...maxFormContentSize</Arg> is missing:
  $run_form_size_missing = @("EoF"/L)
    match Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"]\
    /Arg[#text="org.eclipse.jetty.server.Request.maxFormContentSize"] size == 0
    |-EoF
  $run_set_form_size1 = @("EoF"/L)
    set Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"]\
    /Arg/#text "org.eclipse.jetty.server.Request.maxFormContentSize"
    |-EoF
  # set the first arg (org....) only if it's missing
  augeas{"${jetty_run_file}_max_form_size_missing":
    lens    => 'Xml.lns',
    incl    => $jetty_run_file,
    context => "/files/${jetty_run_file}",
    onlyif  => $run_form_size_missing,
    changes => [ "${run_set_form_size1}" ],
    before => Augeas["${jetty_run_file}_set_max_form_size"]
  }
  # set the second arg (${::ping...}) unconditionaly as now it's guaranteed to be present.
  $run_set_form_size2 = @("EoF"/L)
    set Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"]\
    /Arg[#text="org.eclipse.jetty.server.Request.maxFormContentSize"]\
    /../Arg[2]/#text ${::pingfederate::jetty_max_form_content_size}
    |-EoF
  augeas{"${jetty_run_file}_set_max_form_size":
    lens    => 'Xml.lns',
    incl    => $jetty_run_file,
    context => "/files/${jetty_run_file}",
    changes => [ "${run_set_form_size2}" ]
  }

  # repeat for org.eclipse.jetty.server.Request.maxFormKeys:
  # we have one <Call id="setAttribute"> and want to add a second if it's not already there.
  $run_set_form_keys_missing = @("EoF"/L)
    match Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"]\
    /Arg[#text="org.eclipse.jetty.server.Request.maxFormKeys"] size == 0
    |-EoF
  $run_add_set_attr2 = @("EoF"/L)
    set Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"]/../Call[last()+1]/#attribute/name "setAttribute"
    |-EoF
  augeas{"${jetty_run_file}_run_add_set_attr2":
    lens    => 'Xml.lns',
    incl    => $jetty_run_file,
    context => "/files/${jetty_run_file}",
    onlyif  => $run_set_form_keys_missing,
    changes => [ "${run_add_set_attr2}" ],
    before  => Augeas["${jetty_run_file}_max_form_keys_missing"]
  }
  # if <Configure...><Call name="setAttribute"><Arg>org...maxFormKeys</Arg> is missing:
  $run_form_keys_missing = @("EoF"/L)
    match Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"]\
    /Arg[#text="org.eclipse.jetty.server.Request.maxFormKeys"] size == 0
    |-EoF
  $run_set_form_keys1 = @("EoF"/L)
    set Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"][last()]\
    /Arg/#text "org.eclipse.jetty.server.Request.maxFormKeys"
    |-EoF
  # set the first arg (org....) only if it's missing
  augeas{"${jetty_run_file}_max_form_keys_missing":
    lens    => 'Xml.lns',
    incl    => $jetty_run_file,
    context => "/files/${jetty_run_file}",
    onlyif  => $run_form_keys_missing,
    changes => [ "${run_set_form_keys1}" ],
    before => Augeas["${jetty_run_file}_set_max_form_keys"]
  }
  # set the second arg (${::ping...}) unconditionaly as now it's guaranteed to be present.
  $run_set_form_keys2 = @("EoF"/L)
    set Configure[#attribute/id="RuntimeServer"]\
    /Call[#attribute/name="setAttribute"]\
    /Arg[#text="org.eclipse.jetty.server.Request.maxFormKeys"]\
    /../Arg[2]/#text ${::pingfederate::jetty_max_form_keys}
    |-EoF
  augeas{"${jetty_run_file}_set_max_form_keys":
    lens    => 'Xml.lns',
    incl    => $jetty_run_file,
    context => "/files/${jetty_run_file}",
    changes => [ "${run_set_form_keys2}" ]
  }

  ###
  # Fix up oauth AS to optional return the scope if when the RFC says not to
  ###
  # <z:config xmlns:z="http://www.sourceid.org/2004/05/config">
  #   <!-- <z:item name="always-return-scope-for-authz-code">false</z:item> -->
  # </z:config>

  # augeas appears to fail to work properly with an "empty" XML file so just use file:
  $oauth_scope_settings_file = "$::pingfederate::install_dir/server/default/data/config-store/oauth-scope-settings.xml"
  $oauth_scope_settings_content = @("EoF"/L)
    <?xml version="1.0" encoding="UTF-8"?>
    <z:config xmlns:z="http://www.sourceid.org/2004/05/config">
      <z:item name="always-return-scope-for-authz-code">${::pingfederate::oauth_return_scope_always}</z:item>
    </z:config>
    |-EoF
  file {$oauth_scope_settings_file:
    ensure  => 'present',
    content => $oauth_scope_settings_content,
    owner   => $::pingfederate::owner,
    group   => $::pingfederate::group,
  }

  # unable to get this to work even though testing in augtool is fine:
  # $oauth_scope_settings_missing = @("EoF"/L)
  #   match /z:config/z:item[name="always-return-scope-for-authz-code"] size == 0
  #   |-EoF
  # $oauth_scope_settings_attr = @("EoF"/L)
  #   set /z:config[1]/z:item[1]/#attribute/name "always-return-scope-for-authz-code"
  #   |-EoF
  # augeas{$oauth_scope_settings_file:
  #   lens    => 'Xml.lns',
  #   incl    => $oauth_scope_settings_file,
  #   context => "/files/${oauth_scope_settings_file}",
  #   onlyif  => $oauth_scope_settings_missing,
  #   changes => [ "$oauth_scope_settings_attr" ],
  #   before  => Augeas["${oauth_scope_settings_file}_set"]
  # }
  # $oauth_scope_settings_val = @("EoF"/L)
  #   set /z:config/z:item[name="always-return-scope-for-authz-code"]/#text \
  #   ${::pingfederate::oauth_return_scope_always}
  #   |-EoF
  # augeas{"${oauth_scope_settings_file}_set":
  #   lens    => 'Xml.lns',
  #   incl    => $oauth_scope_settings_file,
  #   context => "/files/${oauth_scope_settings_file}",
  #   changes => [ "$oauth_scope_settings_val" ],
  # }
}
