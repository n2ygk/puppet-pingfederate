# Class pingfederate::oauth_jdbc_datastore
#
# Configure the oauth JDBC datastore only if oauth_jdbc_type is set.
# The JDBC JAR files and database DDL initialization were done in install.pp
#
# Unfortunately the 'clean' way to do this is to invoke the pf-admin-api to add the database connector
# and then edit two XML files, adding the JNDI-NAME to one of them, which requires restarting the
# service.
#
# The --json file is input to the pf-admin-api POST to define a new JDBC datastore.
# If it appears for the first time (or changes), that triggers invoking the API.
# The --response file is the response from the POST.
# It is also used on subsequent invocations to get the 'id' in order to do a GET/PUT
# to update the existing resource (e.g. for a password change).
#
# Note that the admin API tries to connect to the database to confirm it is available.
#
class pingfederate::oauth_jdbc_datastore inherits ::pingfederate {
  if $::pingfederate::oauth_jdbc_type {
    $ds = "${::pingfederate::install_dir}/local/etc/dataStores.json"
    file { $ds:
      ensure   => 'present',
      mode     => 'u=r,go=',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template('pingfederate/dataStores.json.erb'),
    } ~>
    exec {'pf-admin-api POST dataStores':
      command     => "${::pingfederate::install_dir}/local/bin/pf-admin-api -m POST -j ${ds} -r ${ds}.out dataStores", # || rm -f ${ds}
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    } ~>
    exec {'oauth_jdbc_augeas':
      subscribe   => File["${::pingfederate::install_dir}/local/bin/oauth_jdbc_augeas"],
      command     => "${::pingfederate::install_dir}/local/bin/oauth_jdbc_augeas",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
  else { # make sure datastore configs get reverted if the oauth_jdbc_type is (becomes) undef.
    # TODO: refactor as direct augeas edit here since there's nothing variable
    exec {'oauth_jdbc_revert_augeas': # this executes every puppet run. Need to add a notifier.
      command     => "${::pingfederate::install_dir}/local/bin/oauth_jdbc_revert_augeas",
      #refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
}

