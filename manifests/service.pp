# ensure the pingfederate service is running
class pingfederate::service inherits ::pingfederate {
  if $::pingfederate::service_ensure {
    service { $::pingfederate::service_name:
      ensure     => $::pingfederate::service_ensure,
      enable     => true,
      hasstatus  => false,
      hasrestart => true,
    }
  }
}
