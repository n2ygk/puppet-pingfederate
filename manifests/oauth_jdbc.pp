# Class pingfederate::oauth_jdbc
#
# Configure the oauth JDBC service.
#
# Unfortunately the 'clean' way to do this is to invoke the pf-admin-api to add the database connector
# and then edit two XML files, adding the JNDI-NAME to one of them, which requires restarting the service.
# The 'dirty' way would be to just edit the datastore XML file that gets created by the pf-admin-api,
# but who knows what other things that API might do?
#
# The --json file is input to the pf-admin-api POST to define a new JDBC datastore.
# If it appears for the first time (or changes), that triggers invoking the API.
# The --response file is the response from the POST.
# It is also used on subsequent invocations to get the 'id' in order to do a GET/PUT
# to update the existing resource (e.g. for a password change).
#
# TODO: initialize an empty database using scripts at server/default/conf/oauth-client-management/sql-scripts/
#
class pingfederate::oauth_jdbc inherits ::pingfederate {
  $ds = "${::pingfederate::install_dir}/local/etc/dataStores.json"
  file {$ds:
    ensure   => 'present',
    mode     => 'u=r,go=',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/dataStores.json.erb')
  } ~> 
  exec {"oauth_jdbc DDL ${::pingfederate::oauth_jdbc_url}":
    command => "${::pingfederate::oauth_jdbc_cli} < ${::pingfederate::oauth_jdbc_ddl}",
    refreshonly => true,
    user        =>  $::pingfederate::owner,
    returns     => [0,1],       # allow an error like "ERROR 1050 (42S01) at line 1: Table 'pingfederate_oauth_clients' already exists"
    logoutput   => true,
  } ~>
  exec {'pf-admin-api POST dataStores':
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
