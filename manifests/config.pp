# https://docs.puppet.com/puppet/3.8/reference/experiments_future.html#enabling-the-future-parser
class pingfederate::config inherits ::pingfederate {
  # apparently the augeas-1.0 Properties.lens doesn't work with the shitty version of RHEL 6 repos.
  #include augeas

  #augeas{'run.properties':
    #       lens    => 'Properties.lns',
    #       incl    => $::pingfederate::install_dir,
    #       changes => ['set "abc.def" "2345"']
    #}

  # so use inifile for this and augeas for the XML files

  $defaults = { 'path' => "${::pingfederate::install_dir}/pingfederate/bin/run.properties" }
  # this Java properties file has no sections so the section name is '.'
  $settings = {
    '.' => {
      'pf.admin.https.port'  => $::pingfederate::admin_https_port,
      'pf.console.title' => $::pingfederate::console_title,
    }
  }
  create_ini_settings($settings, $defaults)

}
