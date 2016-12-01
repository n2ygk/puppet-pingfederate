class pingfederate::install inherits ::pingfederate {

  package { 'pingfederate-server':
    ensure => 'installed',
  }
  if $::pingfederate::adapter_facebook {
    package { 'pingfederate-facebook-adapter':
      ensure => 'installed',
    }
  }
  if $::pingfederate::adapter_google {
    package { 'pingfederate-google-adapter':
      ensure => 'installed',
    }
  }
  if $::pingfederate::adapter_linkedin {
    package { 'pingfederate-linkedin-adapter':
      ensure => 'installed',
    }
  }
  if $::pingfederate::adapter_twitter {
    package { 'pingfederate-twitter-adapter':
      ensure => 'installed',
    }
  }
  if $::pingfederate::adapter_windowslive {
    package { 'pingfederate-windowslive-adapter':
      ensure => 'installed',
    }
  }
}
