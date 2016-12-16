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
  #
  # Configure the oauth JDBC service.
  #
  # Unfortunately the 'clean' way to do this is to invoke the pf-admin-api to add the database connector
  # and then edit two XML files, adding the JNDI-NAME to one of them, which requires restarting the service.
  # The 'dirty' way would be to just edit the datastore XML file that gets created by the pf-admin-api,
  # but who knows what other things that API might do?
  # TODO: initialize the database using scripts at server/default/conf/oauth-client-management/sql-scripts/

  # This file is input to the pf-admin-api POST to define a new JDBC datastore.
  # If it appears for the first time (or changes), that triggers invoking the API.
  $ds = "${::pingfederate::install_dir}/local/etc/dataStores.json"
  # TODO: pf-admin-api POST is not idempotent. Fix it.
  file {$ds:
    ensure   => 'present',
    mode     => 'u=r,go=',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/dataStores.json.erb')
  } ~> 
  exec {'pf-admin-api POST dataStores':
    command     => "${::pingfederate::install_dir}/local/bin/pf-admin-api -m POST -j ${ds} dataStores | tee ${ds}.out",
    creates     => "${ds}.out",
    refreshonly => true,
    user        =>  $::pingfederate::owner,
    logoutput   => true,
  } ~>
  exec {'oauth_jdbc_augeas':
    command     => "${::pingfederate::install_dir}/local/bin/oauth_jdbc_augeas",
    refreshonly => true,
    user        =>  $::pingfederate::owner,
    logoutput   => true,
  }    

  # ugh. This is what happens when trying to notify the service class causes a dependency loop.
  exec {'/sbin/service pingfederate restart':
    refreshonly => true,
  }
}

