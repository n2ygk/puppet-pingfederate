# Class pingfederate::admin
# Runtime configuration of the server.
# Invokes pf-admin-api and edits various related XML config files.
# Needs to wait for the service to be running
# And may need to cause it to restart -- which is circular!
class pingfederate::admin inherits ::pingfederate {
  include wait_for
  wait_for {'pf-admin-api':
    query => "/usr/bin/wget -q -4 -O - --auth-no-challenge --user ${::pingfederate::adm_user} --password ${::pingfederate::adm_pass} --tries 10 --retry-connrefused --no-check-certificate --header X-XSRF-Header:1 ${::pingfederate::adm_api_baseURL}/version",
    regex => '.*version.*',
    polling_frequency => 10,
    max_retries => 5,
    exit_code => 0,
  }
  # just testing how to use external facts (see facts.d/)
  notify{"here's the JNDI: ${facts[$::pingfederate::oauth_jdbc_url]}":}
}

