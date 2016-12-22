# Class pingfederate::server_settings
#
# Configure the server settings via the admin API
#
class pingfederate::server_settings inherits ::pingfederate {
  $pfapi = "${::pingfederate::install_dir}/local/bin/pf-admin-api"
  $etc = "${::pingfederate::install_dir}/local/etc"

  $ss = "serverSettings"
  file { "${etc}/${ss}.json":
    ensure   => 'present',
    mode     => 'a=r',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template("pingfederate/${ss}.json.erb"),
  } ~> 
  exec {"pf-admin-api PUT ${ss}":
    command     => "${pfapi} -m PUT -j ${etc}/${ss}.json -r ${etc}/${ss}.json.out ${ss}", #  || rm -f ${ss}.json
    refreshonly => true,
    user        => $::pingfederate::owner,
    logoutput   => true,
  }

  $pcv = "passwordCredentialValidators"
  file {"${etc}/${pcv}.json":
    ensure   => 'present',
    mode     => 'a=r',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template("pingfederate/${pcv}.json.erb"),
  } ~> 
  exec {"pf-admin-api POST ${pcv}":
    command     => "${pfapi} -m POST -j ${etc}/${pcv}.json -r ${etc}/${pcv}.json.out ${pcv}", #  || rm -f ${pcv}.json
    refreshonly => true,
    user        => $::pingfederate::owner,
    logoutput   => true,
  }

  if $::pingfederate::saml2_sp_auth_policy_name {
    $apc = "authenticationPolicyContracts"
    file {"${etc}/${apc}.json":
      ensure   => 'present',
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template("pingfederate/${apc}.json.erb"),
    } ~> 
    exec {"pf-admin-api POST ${apc}":
      command     => "${pfapi} -m POST -j ${etc}/${apc}.json -r ${etc}/${apc}.json.out -i ${etc}/${apc}.id ${apc}", #  || rm -f ${apc}.json
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }

  $oas = "oauth/authServerSettings"
  $oasf = "oauth_authServerSettings"
  file {"${etc}/${oasf}.json":
    ensure   => 'present',
    mode     => 'a=r',
    owner    => $::pingfederate::owner,
    group    => $::pingfederate::group,
    content  => template("pingfederate/${oasf}.json.erb"),
  } ~> 
  exec {"pf-admin-api PUT ${oas}":
    command     => "${pfapi} -m PUT -j ${etc}/${oasf}.json -r ${etc}/${oasf}.json.out ${oas}", #  || rm -f ${oasf}.json
    refreshonly => true,
    user        => $::pingfederate::owner,
    logoutput   => true,
  }

  if $::pingfederate::oauth_svc_acc_tok_mgr_id {
    $atm = "oauth/accessTokenManagers"
    $atmf = "oauth_accessTokenManagers"
    file {"${etc}/${atmf}.json":
      ensure   => 'present',
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template("pingfederate/${atmf}.json.erb"),
    } ~> 
    exec {"pf-admin-api POST ${atm}":
      command     => "${pfapi} -m POST -j ${etc}/${atmf}.json -r ${etc}/${atmf}.json.out ${atm}", #  || rm -f ${atmf}.json
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
  if $::pingfederate::oauth_oidc_policy_id {
    $oip = "oauth/openIdConnect/policies"
    $oipf = "oauth_openIdConnect_policies"
    $ois = "oauth/openIdConnect/settings"
    $oisf = "oauth_openIdConnect_settings"
    file {"${etc}/${oipf}.json":
      ensure   => 'present',
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template("pingfederate/${oipf}.json.erb"),
    } ~> 
    exec {"pf-admin-api POST ${oip}":
      command     => "${pfapi} -m POST -j ${etc}/${oipf}.json -r ${etc}/${oipf}.json.out ${oip}", #  || rm -f ${oipf}.json
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    } ->
    file {"${etc}/${oisf}.json":
      ensure   => 'present',
      require  => File["${etc}/${oipf}.json"],
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template("pingfederate/${oisf}.json.erb"),
    } ~> 
    exec {"pf-admin-api PUT ${ois}":
      command     => "${pfapi} -m PUT -j ${etc}/${oisf}.json -r ${etc}/${oisf}.json.out ${ois}", #  || rm -f ${oisf}.json
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
  if $::pingfederate::facebook_adapter {
    $fba = "idp/adapters"
    $fbaf = "idp_adapters_facebook"
    file {"${etc}/${fbaf}.json":
      ensure   => 'present',
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template("pingfederate/${fbaf}.json.erb"),
    } ~> 
    exec {"pf-admin-api POST ${fbaf}":
      command     => "${pfapi} -m POST -j ${etc}/${fbaf}.json -r ${etc}/${fbaf}.json.out ${fba}", #  || rm -f ${fbaf}.json
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
  # TO DO: additional social adapters.

  # SP idp partner configuration needs to pull in an ID from authenticationPolicyContracts.
  # So template the fragments and then concatenate them.
  if $::pingfederate::saml2_idp_url {
    $spidp = 'sp/idpConnections'
    $spidpf = 'sp_idpConnections'
    $spidp_frag01 = 'sp_idpConnections_01'
    $spidp_frag03 = 'sp_idpConnections_03'
    $spidp_frag05 = 'sp_idpConnections_05'
    $x509_string = regsubst($::pingfederate::saml2_idp_cert_str,'\n','\\n','G')
    concat {"${etc}/${spidpf}.json":
      ensure => present,
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
    }
    concat::fragment {"${spidp_frag01}":
      target  => "${etc}/${spidpf}.json",
      content => template("pingfederate/${spidp_frag01}.json.erb"),
      order   => '01',
    }
    concat::fragment {"${apc}.id 02":
      target => "${etc}/${spidpf}.json",
      source => "${etc}/${apc}.id",
      order  => '02',
    }
    concat::fragment {"${spidp_frag03}":
      target  => "${etc}/${spidpf}.json",
      content => template("pingfederate/${spidp_frag03}.json.erb"),
      order   => '03',
    }
    concat::fragment {"${apc}.id 04":
      target => "${etc}/${spidpf}.json",
      source => "${etc}/${apc}.id",
      order  => '04',
    }
    concat::fragment {"${spidp_frag05}":
      target  => "${etc}/${spidpf}.json",
      content => template("pingfederate/${spidp_frag05}.json.erb"),
      order   => '05',
    } 
    exec {"pf-admin-api POST ${spidp}":
      subscribe   => Concat["${etc}/${spidpf}.json"],
      command     => "${pfapi} -m POST -j ${etc}/${spidpf}.json -r ${etc}/${spidpf}.json.out -i ${etc}/${spidpf}.id ${spidp}", #  || rm -f ${fbaf}.json
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
}

