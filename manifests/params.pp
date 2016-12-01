class pingfederate::params {
  # run.properties defaults
  $mode                                = "standalone" # clustered_console, clustered_engine, standalone
  $cluster_bind_address                = "0.0.0.0"
  $cluster_bind_port                   = "7600"
  $cluster_failure_detection_bind_port = "7700"
  $cluster_node_index                  = undef
  $cluster_encrypt                     = "false"
  $cluster_auth_pwd                    = undef
  $cluster_tcp_discovery_initial_hosts = undef
  $console_bind_address                = "0.0.0.0"
  $admin_https_port                    = "9999"    # not sure why this isn't called console_https_port
  $http_port                           = "-1"
  $https_port                          = "9031"
  $secondary_https_port                = "8888"
}
