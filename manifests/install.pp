class pingfederate::install inherits pingfederate {

  package { 'pingfederate':
    ensure => 'installed',
  }
}
