# Class pingfederate::admin
# Runtime configuration of the server.
# Invokes pf-admin-api and edits various related XML config files.
# And may need to cause it to restart -- which is circular!
class pingfederate::admin inherits ::pingfederate {
  # in clustered_engine mode the admin API is disabled as the cluster console pushes the admin configs
  if $::pingfederate::operational_mode != 'CLUSTERED_ENGINE' {
    $restart ="/sbin/service ${::pingfederate::service_name} restart"
    # This may take 30 seconds or so upon server startup. 
    # Waiting happens in bin/pf-admin-api (it retries on EConnRefused).
    # Expect the result to look like {"version":"8.2.2.0"} and fail if not.
    exec {'pf-admin-api version':
      command => "${::pingfederate::install_dir}/local/bin/pf-admin-api version | grep version",
      user        =>  $::pingfederate::owner,
      logoutput   => true,
    }  ->
    class {'::pingfederate::server_settings':} ->
    class {'::pingfederate::oauth_jdbc_datastore':} ~> 
    exec {$restart:               # ugh
      refreshonly => true,
    }
    if $::pingfederate::operational_mode == 'CLUSTERED_CONSOLE' {
      exec {'pf-admin-api cluster replicate':
        subscribe => Exec[$restart],
        command => "${::pingfederate::install_dir}/local/bin/pf-admin-api cluster/status | grep -q '\"replicationRequired\": false' || ${::pingfederate::install_dir}/local/bin/pf-admin-api -m POST --timeout=60 cluster/replicate",
        user        =>  $::pingfederate::owner,
        logoutput   => true,
        refreshonly => true,
      }
    }
  }
}

