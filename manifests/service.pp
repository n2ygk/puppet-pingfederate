# ensure the pingfederate service is running
class pingfederate::service inherits ::pingfederate {
  if $service_ensure {
    service { $service_name:
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => false,
      hasrestart => true,
    }
  }
}
