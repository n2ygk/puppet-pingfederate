# Class pingfederate::oauth_jdbc
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
class pingfederate::oauth_jdbc inherits ::pingfederate {
  $ds = "${::pingfederate::install_dir}/local/etc/dataStores.json"
  # TODO: pf-admin-api POST is not idempotent. Fix it.
  file {$ds:
    ensure   => 'present',
    mode     => 'u=r,go=',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/dataStores.json.erb')
  } ~> 
  exec {'pf-admin-api POST dataStores': # TODO: make idempotent (e.g. do a GET before POST, PUT or something)
    command     => "${::pingfederate::install_dir}/local/bin/pf-admin-api -m POST -j ${ds} -r ${ds}.out dataStores",
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
}
