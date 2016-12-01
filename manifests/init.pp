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
#    mode => "clustered_console",
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
  $mode                                = $::pingfederate::params::mode                                ,
  $cluster_bind_address                = $::pingfederate::params::cluster_bind_address                ,
  $cluster_bind_port                   = $::pingfederate::params::cluster_bind_port                   ,
  $cluster_failure_detection_bind_port = $::pingfederate::params::cluster_failure_detection_bind_port ,
  $cluster_node_index                  = $::pingfederate::params::cluster_node_index                  ,
  $cluster_encrypt                     = $::pingfederate::params::cluster_encrypt                     ,
  $cluster_auth_pwd                    = $::pingfederate::params::cluster_auth_pwd                    ,
  $cluster_tcp_discovery_initial_hosts = $::pingfederate::params::cluster_tcp_discovery_initial_hosts ,
  $console_bind_address                = $::pingfederate::params::console_bind_address                ,
  $admin_https_port                    = $::pingfederate::params::admin_https_port                    ,
  $http_port                           = $::pingfederate::params::http_port                           ,
  $https_port                          = $::pingfederate::params::https_port                          ,
  $secondary_https_port                = $::pingfederate::params::secondary_https_port                ,
  ) inherits ::pingfederate::params {
  
  validate_ip_address($cluster_bind_address)
  validate_integer($cluster_bind_port,65535,1)
  validate_integer($cluster_failure_detection_bind_port,65535,1)
  validate_integer($cluster_node_index,undef,0)
  # check $mode for clustering settings...
  validate_bool($cluster_encrypt)
  if $cluster_encrypt {
    validate_string($cluster_auth_pwd)
  }

  anchor { 'pingfederate::begin': } ->
  class { '::pingfederate::install': } ->
  class { '::pingfederate::config': } ~>
  class { '::pingfederate::service': } ->
  anchor { 'pingfederate::end': }
 
}
