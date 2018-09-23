# Class ::pingfederate::install
# (optionally) install the pingfederate packages and ensures other required packages.
# As delivered by the vendor, there are no packages, but I've RPMed them.
# Future developer: add a way to just use the vendor-supplied ZIP files.
class pingfederate::install inherits ::pingfederate {
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
    ensure_packages($pingfederate::package_list,{'ensure' => $pingfederate::package_ensure})
    $pf_pkgs = Package[$::pingfederate::package_list] # dependency used below
  }
  else {
    $pf_pkgs = undef
  }

  # TBD: Refactor to a list of adapters to add? Or to download from PingIdentity.com?
  $::pingfederate::social_adapter.each |$name, $a| {
    $b = deep_merge($::pingfederate::social_adapter_default,$a)
    if str2bool($b['enable']) {
      $plist = if $b['package_list'] { $b['package_list'] } else { "pingfederate-${name}-adapter" }
      $ens = if $b['package_ensure'] { $b['package_ensure'] } else { 'installed' }
      ensure_packages($plist, {'ensure' => $ens})
    }
  }
  # python and augeas scripts are in templates/
  ensure_packages(['python','python-requests','python-libs','augeas'],{'ensure' => 'installed'})

  # Also install some local configuration tools
  file { "${::pingfederate::install_dir}/local":
    require => $pf_pkgs, # require the package to create the install_dir
    ensure  => 'directory',
    owner   => $::pingfederate::owner,
    group   => $::pingfederate::group,
  }
  file { "${::pingfederate::install_dir}/local/README":
    require => File["${::pingfederate::install_dir}/local"],
    ensure  => 'present',
    content => 'These are locally-added utility scripts (in bin/) and config files (in etc/) managed by Puppet',
    owner  => $::pingfederate::owner,
    group  => $::pingfederate::group,
  }
  file { "${::pingfederate::install_dir}/local/bin":
    require => File["${::pingfederate::install_dir}/local"],
    ensure  => 'directory',
    owner   => $::pingfederate::owner,
    group   => $::pingfederate::group,
  }
  file { "${::pingfederate::install_dir}/local/bin/pf-admin-api":
    require => File["${::pingfederate::install_dir}/local/bin"],
    ensure   => 'present',
    mode     => 'a=rx',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/pf-admin-api.erb')
  }
  file { "${::pingfederate::install_dir}/local/bin/oauth_jdbc_augeas":
    require => File["${::pingfederate::install_dir}/local/bin"],
    ensure   => 'present',
    mode     => 'a=rx',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/oauth_jdbc_augeas.erb')
  }
  file { "${::pingfederate::install_dir}/local/bin/oauth_jdbc_revert_augeas":
    require => File["${::pingfederate::install_dir}/local/bin"],
    ensure   => 'present',
    mode     => 'a=rx',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/oauth_jdbc_revert_augeas.erb')
  }
  file { "${::pingfederate::install_dir}/local/etc":
    require => File["${::pingfederate::install_dir}/local"],
    ensure => 'directory',
    owner  => $::pingfederate::owner,
    group  => $::pingfederate::group,
  }
  file { "${::pingfederate::install_dir}/local/etc/pf-admin-cfg.json":
    require => File["${::pingfederate::install_dir}/local/etc"],
    ensure   => 'present',
    mode     => 'u=rx,go=',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template('pingfederate/pf-admin-cfg.json.erb')
  }
  # If using an external JDBC database, install the JAR on the classpath and initialize the database.
  if $::pingfederate::oauth_jdbc_type {    # sometimes the jar is in an RPM
    if $::pingfederate::oauth_jdbc_package_ensure {
      ensure_packages($::pingfederate::o_pkgs,{'ensure' => $::pingfederate::oauth_jdbc_package_ensure})
    }
    if $::pingfederate::oauth_jdbc_nexus { # other times the jar is in a nexus repo
      archive::nexus { "${::pingfederate::o_jar_dir}/${::pingfederate::o_jar}":
        url        => $::pingfederate::o_nexus['url'],
        gav        => $::pingfederate::o_nexus['gav'],
        repository => $::pingfederate::o_nexus['repo'],
        packaging  => 'jar',
        extract    => false,
        before     => File["${::pingfederate::install_dir}/server/default/lib/${::pingfederate::o_jar}"],
      }
    }
    file { "${::pingfederate::install_dir}/server/default/lib/${::pingfederate::o_jar}":
      ensure => 'present',
      source => "${::pingfederate::o_jar_dir}/${::pingfederate::o_jar}",
      links  => 'follow',
      owner  => $::pingfederate::owner,
      group  => $::pingfederate::group,
    } ~>
    exec {"oauth_jdbc CREATE ${::pingfederate::o_url}":
      command => $::pingfederate::o_create,
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    } ~>
    exec {"oauth_jdbc_client DDL ${::pingfederate::o_url}": # define tables for oauth client management
      command => $::pingfederate::o_c_cmd,
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    } ~>
    exec {"oauth_jdbc_access DDL ${::pingfederate::o_url}": # define tables for saml2 access management
      command => $::pingfederate::o_a_cmd,
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    } ~>
    exec {"acct_jdbc_linking DDL ${::pingfederate::o_url}": # define tables for account linking
      command => $::pingfederate::a_l_cmd,
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
}
