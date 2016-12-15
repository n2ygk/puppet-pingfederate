# Class pingfederate::admin
# Runtime configuration of the server.
# Invokes pf-admin-api and edits various related XML config files.
# And may need to cause it to restart -- which is circular!
class pingfederate::admin inherits ::pingfederate {
  # This may take 30 seconds or so upon server startup. 
  # Waiting happens in bin/pf-admin-api (it retries on EConnRefused).
  exec {'pf-admin-api version':
    command => "${::pingfederate::install_dir}/local/bin/pf-admin-api version | grep -q version",
  }
  #
  # Configure the oauth JDBC service.
  #
  # The value of the fact named $::pingfederate::oauth_jdbc_url is the JNDI name.
  # Unfortunately the 'clean' way to do this is to invoke the pf-admin-api to add the database connector
  # and then edit two XML files, adding the JNDI-NAME to one of them, which requires restarting the service.
  # The 'dirty' way would be to just edit the datastore XML file that gets created by the pf-admin-api,
  # but who knows what other things that API might do?

  if "${facts[$::pingfederate::oauth_jdbc_url]}" != '' {
    $hive_file = "$::pingfederate::install_dir/server/default/conf/META-INF/hivemodule.xml"
    augeas{$hive_file:
      lens    => 'Xml.lns',
      incl    => $hive_file,
      context => "/files/${hive_file}",
      changes => ['set module/service-point[#attribute/id="ClientManager"][#attribute/interface="org.sourceid.oauth20.domain.ClientManager"]/invoke-factory/construct/#attribute/class "org.sourceid.oauth20.domain.ClientManagerJdbcImpl"']
    }
    $jdbc_file = "$::pingfederate::install_dir/server/default/data/config-store/org.sourceid.oauth20.domain.ClientManagerJdbcImpl.xml"
    augeas{$jdbc_file:
      lens    => 'Xml.lns',
      incl    => $jdbc_file,
      context => "/files/${jdbc_file}",
      changes => ["set c:config/c:item[#attribute/name=\"PingFederateDSJNDIName\"]/#text \"${facts[$::pingfederate::oauth_jdbc_url]}\""],
    }
  }
  # ugh. This is what happens when trying to notify the service class causes a dependency loop.
  exec {'/sbin/service pingfederate restart':}
}

