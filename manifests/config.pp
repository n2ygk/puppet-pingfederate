# https://docs.puppet.com/puppet/3.8/reference/experiments_future.html#enabling-the-future-parser
class pingfederate::config inherits ::pingfederate {
  # apparently the augeas-1.4 Properties.lens doesn't work!
  # augeas{'run.properties':
  #   lens    => 'Properties.lns',
  #   incl    => "$::pingfederate::install_dir/bin/run.properties",
  #   changes => ['set "abc.def" "2345"']
  #}

  # so use inifile for this and augeas for the XML files

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
      'pf.log.event.detail'                    => $::pingfederate::log_event_detail,
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
      'pf.cluster.tcp.discovery.initial.hosts' => $::pingfederate::cluster_tcp_discovery_initial_hosts,
      'pf.cluster.diagnostics.enabled'         => $::pingfederate::cluster_diagnostics_enabled,
      'pf.cluster.diagnostics.addr'            => $::pingfederate::cluster_diagnostics_addr,
      'pf.cluster.diagnostics.port'            => $::pingfederate::cluster_diagnostics_port,
    }
  }
  create_ini_settings($settings, $defaults)

}
