# Class ::pingfederate::install
# (optionally) install the packages.
# As delivered by the vendor, there are no packages, but I've RPMed them.
class pingfederate::install inherits ::pingfederate {
  # not sure if this java thing belongs here... looks like puppetlabs-java only works for Oracle on CentOS.
  # use ensure_packages() instead?
  if $::pingfederate::package_java_ensure {
    # if a specific java pkg is specified use it, otherwise use our defaults for redhat or centos
    if $::pingfederate::package_java_list { 
      $pkg = $::pingfederate::package_java_list
    } else {
      case $facts['os']['name'] {
        'redhat': { $pkg = $::pingfederate::package_java_redhat }
        'centos': { $pkg = $::pingfederate::package_java_centos }
        default: { fail("Don't know how to install java on ${facts['os']['name']}") }
      }
    }
    ensure_packages($pkg, {'ensure' => $::pingfederate::package_java_ensure})
  }
  if $pingfederate::package_ensure {
    ensure_packages($pingfederate::package_list, {'ensure' => $pingfederate::package_ensure})
  }
  # TBD: Refactor to a list of adapters to add? Or to download from PingIdentity.com?
  if $pingfederate::facebook_adapter {
    ensure_packages($pingfederate::facebook_package_list, {'ensure' => $pingfederate::facebook_package_ensure})
  }
  if $pingfederate::google_adapter {
    ensure_packages($pingfederate::google_package_list,{'ensure' => $pingfederate::google_package_ensure})
  }
  if $pingfederate::linkedin_adapter {
    ensure_packages($pingfederate::linkedin_package_list,{'ensure' => $pingfederate::linkedin_package_ensure})
  }
  if $pingfederate::twitter_adapter {
    ensure_packages($pingfederate::twitter_adapter_list,{'ensure' => $pingfederate::twitter_package_ensure})
  }
  if $pingfederate::windowslive_adapter {
    ensure_packages($pingfederate::windowslive_adapter_list,{'ensure' => $pingfederate::windowslive_package_ensure})
  }
  # wget is used to wait_for the REST api
  # mysql is used to wait_for the mysql database
  ensure_packages(['wget','python','python-requests','python-libs'],{'ensure' => 'installed'})

  # Also install some local configuration tools
  file { "${::pingfederate::install_dir}/local":
    ensure => 'directory',
    owner  => $::pingfederate::owner,
    group  => $::pingfederate::group,
  }
  file { "${::pingfederate::install_dir}/local/README":
    ensure => 'present',
    content => 'These are locally-added utility scripts (in bin/) and config files (in etc/) managed by Puppet',
    owner  => $::pingfederate::owner,
    group  => $::pingfederate::group,
  }
  file { "${::pingfederate::install_dir}/local/bin":
    ensure => 'directory',
    owner  => $::pingfederate::owner,
    group  => $::pingfederate::group,
  }
  file { "${::pingfederate::install_dir}/local/bin/pf-admin-api":
    ensure   => 'present',
    mode     => 'u=rx,go=',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/pf-admin-api.erb')
  }
  file { "${::pingfederate::install_dir}/local/bin/oauth_jdbc_augeas":
    ensure   => 'present',
    mode     => 'a=rx',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/oauth_jdbc_augeas.erb')
  }
  file { "${::pingfederate::install_dir}/local/etc":
    ensure => 'directory',
    owner  => $::pingfederate::owner,
    group  => $::pingfederate::group,
  }
  if $::pingfederate::oauth_jdbc_package_ensure {
    ensure_packages($::pingfederate::oauth_jdbc_package_list,{'ensure' => $::pingfederate::oauth_jdbc_package_ensure})
  }
  file { "${::pingfederate::install_dir}/server/default/lib/${::pingfederate::oauth_jdbc_jar}":
    ensure => 'present',
    source => "${::pingfederate::oauth_jdbc_jar_dir}/${::pingfederate::oauth_jdbc_jar}",
    links  => 'follow',
    owner  => $::pingfederate::owner,
    group  => $::pingfederate::group,
  }
}
