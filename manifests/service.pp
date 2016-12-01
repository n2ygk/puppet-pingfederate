# ensure the pingfederate service is running
class pingfederate::service inherits ::pingfederate {
  service { 'pingfederate':
    ensure     => 'running',
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
  }
}
