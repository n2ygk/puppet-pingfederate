class pingfederate::service inherits pingfederate {
  service { 'pingfederate':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
