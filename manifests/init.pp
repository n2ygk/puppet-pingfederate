# == Class: pingfederate
#
# Install and configure PingFederate
#
# === Parameters
#
#
# === Examples
#
#  class { 'pingfederate':
#    operational_mode   => "clustered_console",
#    cluster_node_index => 2,
#  }
#
# === Authors
#
# Alan Crosswell <alan@columbia.edu>
#
# === Copyright
#
# Copyright 2016 The Trustees of Columbia University in the City of New York
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
  # add-on packages: social media oauth adapters
  $facebook_adapter                    = $::pingfederate::params::facebook_adapter,
  $facebook_package_list               = $::pingfederate::params::facebook_package_list,
  $facebook_package_ensure             = $::pingfederate::params::facebook_package_ensure,
  $google_adapter                      = $::pingfederate::params::google_adapter,
  $google_package_list                 = $::pingfederate::params::google_package_list,
  $google_package_ensure               = $::pingfederate::params::google_package_ensure,
  $linkedin_adapter                    = $::pingfederate::params::linkedin_adapter,
  $linkedin_package_list               = $::pingfederate::params::linkedin_package_list,
  $linkedin_package_ensure             = $::pingfederate::params::linkedin_package_ensure,
  $twitter_adapter                     = $::pingfederate::params::twitter_adapter,
  $twitter_package_list                = $::pingfederate::params::twitter_package_list,
  $twitter_package_ensure              = $::pingfederate::params::twitter_package_ensure,
  $windowslive_adapter                 = $::pingfederate::params::windowslive_adapter,
  $windowslive_package_list            = $::pingfederate::params::windowslive_package_list,
  $windowslive_package_ensure          = $::pingfederate::params::windowslive_package_ensure,
  # ensure the service is up
  $service_name                        = $::pingfederate::params::service_name,
  $service_ensure                      = $::pingfederate::params::service_ensure,
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
  $log_event_detail                    = $::pingfederate::params::log_event_detail,
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
  ) inherits ::pingfederate::params {

  validate_re($operational_mode,['^STANDALONE$','^CLUSTERED_CONSOLE$','^CLUSTERED_ENGINE$'])
  if $cluster_bind_address != 'NON_LOOPBACK' {
    validate_ip_address($cluster_bind_address)
  }
  validate_integer($cluster_bind_port,65535,1)
  validate_integer($cluster_failure_detection_bind_port,65535,1)
  validate_integer($cluster_node_index,undef,0)
  validate_bool($cluster_encrypt)
  if $cluster_encrypt {
    validate_string($cluster_auth_pwd)
  }
  # Example: host1[7600],10.0.1.4[7600],host7[1033],10.0.9.45[2231] 
  validate_string($cluster_tcp_discovery_initial_hosts)
  validate_ip_address($console_bind_address)
  validate_integer($admin_https_port,65535,1)
  validate_integer($http_port,65535,-1)
  validate_integer($https_port,65535,-1)
  validate_integer($secondary_https_port,65535,-1)

  # need to do more validation

  anchor { 'pingfederate::begin': } ->
  class { '::pingfederate::install': } ->
  class { '::pingfederate::config': } ~>
  class { '::pingfederate::service': } ->
  anchor { 'pingfederate::end': }
}
