# Class pingfederate::oauth_jdbc
#
# Configure the oauth JDBC service only if oauth_jdbc_type is set.
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
class pingfederate::oauth_jdbc inherits ::pingfederate {
  # the jar file has to be on the classpath so it's installed in pingfederate::install.
  $ds = "${::pingfederate::install_dir}/local/etc/dataStores.json"
  file {$ds:
    ensure   => 'present',
    mode     => 'u=r,go=',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/dataStores.json.erb'),
  } ~> 
  if $::pingfederate::o_cmd {
    exec {"oauth_jdbc DDL ${::pingfederate::o_url}":
      command => $::pingfederate::o_cmd,
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
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

