# (optionally) install the packages.
# As delivered by the vendor, there are no packages, but I've RPMed them.
class pingfederate::install inherits ::pingfederate {
  # not sure if this java thing belongs here... looks like puppetlabs-java only works for Oracle on CentOS.
  if $pingfederate::package_java_ensure {
    if $pingfederate::package_java_list {
      package { $pingfederate::package_java_list:
        ensure => $pingfederate::package_java_ensure
      }
    } else {
      case $facts['os']['name'] {
        'redhat': { $pkg = $pingfederate::package_java_redhat }
        'centos': { $pkg = $pingfederate::package_java_centos }
        default: { fail("Don't know how to install java on ${facts['os']['name']}") }
      }
      package { $pkg:
        ensure => $pingfederate::package_java_ensure
      }
    }
  }

  if $pingfederate::package_ensure {
    package { $pingfederate::package_list:
      ensure => $pingfederate::package_ensure,
    }
  }
  # TBD: Refactor to a list of adapters to add? Or to download from PingIdentity.com?
  if $pingfederate::facebook_adapter {
    package { $pingfederate::facebook_package_list:
      ensure => $pingfederate::facebook_package_ensure,
    }
  }
  if $pingfederate::google_adapter {
    package { $pingfederate::google_package_list:
      ensure => $pingfederate::google_package_ensure,
    }
  }
  if $pingfederate::linkedin_adapter {
    package { $pingfederate::linkedin_package_list:
      ensure => $pingfederate::linkedin_package_ensure,
    }
  }
  if $pingfederate::twitter_adapter {
    package { $pingfederate::twitter_adapter_list:
      ensure => $pingfederate::twitter_package_ensure,
    }
  }
  if $pingfederate::windowslive_adapter {
    package { $pingfederate::windowslive_adapter_list:
      ensure => $pingfederate::windowslive_package_ensure,
    }
  }
}
