# Class pingfederate::server_settings
#
# Configure the server settings via the admin API
#
class pingfederate::server_settings inherits ::pingfederate {
  $ss = "${::pingfederate::install_dir}/local/etc/serverSettings.json"
  file {$ss:
    ensure   => 'present',
    mode     => 'a=r',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/serverSettings.json.erb'),
  } ~> 
  exec {'pf-admin-api POST serverSettings':
    command     => "${::pingfederate::install_dir}/local/bin/pf-admin-api -m PUT -j ${ss} -r ${ss}.out serverSettings", #  || rm -f ${ss}
    refreshonly => true,
    user        => $::pingfederate::owner,
    logoutput   => true,
  }
}

