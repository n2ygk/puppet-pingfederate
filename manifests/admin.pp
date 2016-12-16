# Class pingfederate::admin
# Runtime configuration of the server.
# Invokes pf-admin-api and edits various related XML config files.
# And may need to cause it to restart -- which is circular!
class pingfederate::admin inherits ::pingfederate {
  # This may take 30 seconds or so upon server startup. 
  # Waiting happens in bin/pf-admin-api (it retries on EConnRefused).
  exec {'pf-admin-api version':
    command => "${::pingfederate::install_dir}/local/bin/pf-admin-api version | grep version",
    user        =>  $::pingfederate::owner,
    logoutput   => true,
  }
  if $::pingfederate::oauth_jdbc_url {
    class {'::pingfederate::oauth_jdbc':}
  } ~>
  # ugh. This is what happens when trying to notify the service class causes a dependency loop.
  exec {'/sbin/service pingfederate restart':
    refreshonly => true,
  }
}

