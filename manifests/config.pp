# https://docs.puppet.com/puppet/3.8/reference/experiments_future.html#enabling-the-future-parser
class pingfederate::config inherits pingfederate {
  if !File['/etc/ax25'] {
    file { '/etc/ax25':
      ensure  => directory,
    }
  }
  # build up the pingfederate options to look something like this:
  # --kill_dupes --kill_loops --logfile /var/log/pingfederate.log --trace WIDE --trace TRACE --subst_mycall --x1j4_xlate --interface ax25:sm0:RELAY,WIDE,TRACE

  $okd = if $kill_dupes { "--kill_dupes" }
  $okl = if $kill_loops { "--kill_loops" }
  $osm = if $subst_mycall { "--subst_mycall" }
  $oxx = if $x1j4_xlate { " --x1j4_xlate" }
  $olf = if $logfile { "--logfile ${logfile}" }
  $otr = $traces.reduce("") |$t,$i| { "${t} --trace ${i}" }
  $oal = $aliases.reduce("") |$a,$i| { "${a}${i}," }  # stupid extra comma at end of oal

  $pingfederate_opts = "${okd} ${okl} ${osm} ${oxx} ${olf} ${otr} --interface ax25:${intf}:${oal}"
  $beacon_text = "!${lat}/${lon}#PHG${phg}/${txt}"
  file { '/etc/ax25/pingfederate.conf':
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template('pingfederate/pingfederate.conf.erb'),
  }
}
