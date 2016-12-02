# (optionally) install the packages.
# As delivered by the vendor, there are no packages, but I've RPMed them.
class pingfederate::install inherits ::pingfederate {
  if $package_ensure {
    package { $package_list:
      ensure => $package_ensure,
    }
  }
  # TBD: Refactor to a list of adapters to add? Or to download from PingIdentity.com?
  if $facebook_adapter {
    package { $facebook_package_list:
      ensure => $facebook_ensure,
    }
  }
  if $google_adapter {
    package { $google_package_list:
      ensure => $google_ensure,
    }
  }
  if $linkedin_adapter {
    package { $linkedin_package_list:
      ensure => $linkedin_ensure,
    }
  }
  if $twitter_adapter {
    package { $twitter_adapter_list:
      ensure => $twitter_ensure,
    }
  }
  if $windowslive_adapter {
    package { $windowslive_adapter_list:
      ensure => $windowslive_ensure,
    }
  }
}
