# Class pingfederate::admin
# Runtime configuration of the server.
# Invokes pf-admin-api and edits various related XML config files.
# And may need to cause it to restart -- which is circular!
class pingfederate::admin inherits ::pingfederate {
  $restart ="/sbin/service ${::pingfederate::service_name} restart"

  # This may take 30 seconds or so upon server startup. 
  # Waiting happens in bin/pf-admin-api (it retries on EConnRefused).
  # Expect the result to look like {"version":"8.2.2.0"} and fail if not.
  exec {'pf-admin-api version':
    command => "${::pingfederate::install_dir}/local/bin/pf-admin-api version | grep version",
    user        =>  $::pingfederate::owner,
    logoutput   => true,
  }
  class {'::pingfederate::oauth_jdbc':} ~> Exec[$restart]
  
  # ugh. This is what happens when trying to notify the service class causes a dependency loop:
  # You can't notify the service, instead having to go behind its back.
  exec {$restart:
    refreshonly => true,
  }
}

