# Class pingfederate::admin
# Runtime configuration of the server.
# Invokes pf-admin-api and edits various related XML config files.
# Needs to wait for the service to be running
# And may need to cause it to restart -- which is circular!
class pingfederate::admin inherits ::pingfederate {
  include wait_for
  # this may take 30 seconds or so upon server startup
  wait_for {'pf-admin-api':
    query => "/usr/bin/wget -q -4 -O - --auth-no-challenge --user ${::pingfederate::adm_user} --password ${::pingfederate::adm_pass} --tries 10 --retry-connrefused --no-check-certificate --header X-XSRF-Header:1 ${::pingfederate::adm_api_baseURL}/version",
    regex => '.*version.*',
    polling_frequency => 10,
    max_retries => 5,
    exit_code => 0,
  }
  # just testing how to use external facts (see ../facts.d/)
  #notify{"here's the JNDI: ${facts[$::pingfederate::oauth_jdbc_url]}":}
  # configure the oauth JDBC service. Need to figure out how to trigger things...
  # The value of the fact named $::pingfederate::oauth_jdbc_url is the JNDI name.
  # anchor {'pingfederate-oauth-jdbc':}
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
      #this causes a dependency graph loop, but how to get this to work?
      #notify  => Service[$::pingfederate::service_name]
    }
  }
  # ugh
  exec {'/sbin/service pingfederate restart':}
}

