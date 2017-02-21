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
    command     => "${pfapi} -m PUT -j ${etc}/${ss}.json -r ${etc}/${ss}.json.out ${ss}", # || rm -f ${ss}.json",
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
    command     => "${pfapi} -m POST -j ${etc}/${pcv}.json -r ${etc}/${pcv}.json.out ${pcv}", # || rm -f ${pcv}.json",
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
      command     => "${pfapi} -m POST -j ${etc}/${apc}.json -r ${etc}/${apc}.json.out -i ${etc}/${apc}.id ${apc}", # || rm -f ${apc}.json",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
    $apcm = 'oauth/authenticationPolicyContractMappings'
    $apcmf = 'oauth_authenticationPolicyContractMappings'
    $apcm_frag01 = "${apcmf}_01"
    $apcm_frag03 = "${apcmf}_03"
    $apcm_frag05 = "${apcmf}_05"
    $apcm_frag07 = "${apcmf}_07"
    Exec["pf-admin-api POST ${apc}"] ->
    concat {"${etc}/${apcmf}.json":
      ensure  => present,
      mode    => 'a=r',
      owner   => $::pingfederate::owner,
      group   => $::pingfederate::group,
    }
    concat::fragment {"${apcm_frag01}":
      target  => "${etc}/${apcmf}.json",
      content => template("pingfederate/${apcm_frag01}.json.erb"),
      order   => '01',
    }
    concat::fragment {"${apc}.id ${apcm} 02":
      target => "${etc}/${apcmf}.json",
      source => "${etc}/${apc}.id",
      order  => '02',
    }
    concat::fragment {"${apcm_frag03}":
      target  => "${etc}/${apcmf}.json",
      content => template("pingfederate/${apcm_frag03}.json.erb"),
      order   => '03',
    }
    concat::fragment {"${apc}.id ${apcm} 04":
      target => "${etc}/${apcmf}.json",
      source => "${etc}/${apc}.id",
      order  => '04',
    }
    concat::fragment {"${apcm_frag05}":
      target  => "${etc}/${apcmf}.json",
      content => template("pingfederate/${apcm_frag05}.json.erb"),
      order   => '05',
    }
    concat::fragment {"${apc}.id ${apcm} 06":
      target => "${etc}/${apcmf}.json",
      source => "${etc}/${apc}.id",
      order  => '06',
    }
    concat::fragment {"${apcm_frag07}":
      target  => "${etc}/${apcmf}.json",
      content => template("pingfederate/${apcm_frag07}.json.erb"),
      order   => '07',
    }
    exec {"pf-admin-api POST ${apcm}/saml2":
      subscribe   => Concat["${etc}/${apcmf}.json"],
      command     => "${pfapi} -m POST -j ${etc}/${apcmf}.json -r ${etc}/${apcmf}.json.out -i ${etc}/${apcmf}.id ${apcm}", # || rm -f ${apcmf}.json",
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
    command     => "${pfapi} -m PUT -j ${etc}/${oasf}.json -r ${etc}/${oasf}.json.out ${oas}", # || rm -f ${oasf}.json",
    refreshonly => true,
    user        => $::pingfederate::owner,
    logoutput   => true,
  }

  if $::pingfederate::oauth_svc_acc_tok_mgr_id {
    $atm = "oauth/accessTokenManagers"
    $atmf = "oauth_accessTokenManagers"
    Exec["pf-admin-api PUT ${oas}"] ->
    file {"${etc}/${atmf}.json":
      ensure   => 'present',
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template("pingfederate/${atmf}.json.erb"),
    } ~> 
    exec {"pf-admin-api POST ${atm}":
      command     => "${pfapi} -m POST -j ${etc}/${atmf}.json -r ${etc}/${atmf}.json.out ${atm}", # || rm -f ${atmf}.json",
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
      command     => "${pfapi} -m POST -j ${etc}/${oipf}.json -r ${etc}/${oipf}.json.out ${oip}", # || rm -f ${oipf}.json",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    } ->
    file {"${etc}/${oisf}.json":
      ensure   => 'present',
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template("pingfederate/${oisf}.json.erb"),
    } ~> 
    exec {"pf-admin-api PUT ${ois}":
      command     => "${pfapi} -m PUT -j ${etc}/${oisf}.json -r ${etc}/${oisf}.json.out ${ois}", # || rm -f ${oisf}.json",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
  # TODO: make sure an adapter wasn't previously defined and is now removed. Removal happens
  # in the reverse order of addition!
  if str2bool($::pingfederate::facebook_adapter) {
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
      command     => "${pfapi} -m POST -j ${etc}/${fbaf}.json -r ${etc}/${fbaf}.json.out ${fba}", # || rm -f ${fbaf}.json",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
  # TO DO: additional social adapters. Can probably parameterize and reuse the facebook stuff,

  if $::pingfederate::saml2_idp_url {
    $spidp = 'sp/idpConnections'
    $spidpf = 'sp_idpConnections'
    $spidp_frag01 = "${spidpf}_01"
    $spidp_frag03 = "${spidpf}_03"
    $spidp_frag05 = "${spidpf}_05"
    $x509_string = regsubst($::pingfederate::saml2_idp_cert_content,'\n','\\n','G')

    Exec["pf-admin-api POST ${apc}"] ->
    concat {"${etc}/${spidpf}.json":
      ensure   => present,
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
      command     => "${pfapi} -m POST -j ${etc}/${spidpf}.json -r ${etc}/${spidpf}.json.out -i ${etc}/${spidpf}.id ${spidp}", # || rm -f ${spidpf}.json",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
    $oatsp = 'oauth/accessTokenMappings'
    $oatspf = 'oauth_accessTokenMappings_saml2'
    $oatsp_frag01 = "${oatspf}_01"
    $oatsp_frag03 = "${oatspf}_03"
    $oatsp_frag05 = "${oatspf}_05"
    $oatsp_frag07 = "${oatspf}_07"

    Exec["pf-admin-api POST ${spidp}"] ->
    concat {"${etc}/${oatspf}.json":
      ensure  => present,
      mode    => 'a=r',
      owner   => $::pingfederate::owner,
      group   => $::pingfederate::group,
    }
    concat::fragment {"${oatsp_frag01}":
      target  => "${etc}/${oatspf}.json",
      content => template("pingfederate/${oatsp_frag01}.json.erb"),
      order   => '01',
    }
    concat::fragment {"${spidpf}.id ${oatsp} 02":
      target => "${etc}/${oatspf}.json",
      source => "${etc}/${spidpf}.id",
      order  => '02',
    }
    concat::fragment {"${oatsp_frag03}":
      target  => "${etc}/${oatspf}.json",
      content => template("pingfederate/${oatsp_frag03}.json.erb"),
      order   => '03',
    }
    concat::fragment {"${spidpf}.id ${oatsp} 04":
      target => "${etc}/${oatspf}.json",
      source => "${etc}/${spidpf}.id",
      order  => '04',
    }
    concat::fragment {"${oatsp_frag05}":
      target  => "${etc}/${oatspf}.json",
      content => template("pingfederate/${oatsp_frag05}.json.erb"),
      order   => '05',
    } 
    concat::fragment {"${spidpf}.id ${oatsp} 06":
      target => "${etc}/${oatspf}.json",
      source => "${etc}/${spidpf}.id",
      order  => '06',
    }
    concat::fragment {"${oatsp_frag07}":
      target  => "${etc}/${oatspf}.json",
      content => template("pingfederate/${oatsp_frag07}.json.erb"),
      order   => '07',
    } 
    exec {"pf-admin-api POST ${oatsp}/saml2":
      subscribe   => Concat["${etc}/${oatspf}.json"],
      command     => "${pfapi} -m POST -j ${etc}/${oatspf}.json -r ${etc}/${oatspf}.json.out -i ${etc}/${oatspf}.id ${oatsp}", # || rm -f ${oatspf}.json",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
  # move this after the OAuth stuff?
  if str2bool($::pingfederate::facebook_adapter) {
    $fbi = "oauth/idpAdapterMappings"
    $fbif = "oauth_idpAdapterMappings_facebook"
    file {"${etc}/${fbif}.json":
      require    => [
                     Exec["pf-admin-api POST ${fbaf}"], # need idp/apapters/Facebook
                     Exec["pf-admin-api POST ${atm}"],  # need oauth/accessTokenManagers/{id}
                     ],
      ensure     => 'present',
      mode       => 'a=r',
      owner      => $::pingfederate::owner,
      group      => $::pingfederate::group,
      content    => template("pingfederate/${fbif}.json.erb"),
    } ~> 
    exec {"pf-admin-api POST ${fbif}":
      command     => "${pfapi} -m POST -j ${etc}/${fbif}.json -r ${etc}/${fbif}.json.out ${fbi}", # || rm -f ${fbif}.json",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
    $oatfb = 'oauth/accessTokenMappings'
    $oatfbf = 'oauth_accessTokenMappings_facebook'
    Exec["pf-admin-api POST ${fbaf}"] ->
    file {"${etc}/${oatfbf}.json":
      ensure   => 'present',
      mode     => 'a=r',
      owner    => $::pingfederate::owner,
      group    => $::pingfederate::group,
      content  => template("pingfederate/${oatfbf}.json.erb"),
    } ~> 
    exec {"pf-admin-api POST ${oatfb}/Facebook":
      command     => "${pfapi} -m POST -j ${etc}/${oatfbf}.json -r ${etc}/${oatfbf}.json.out -i ${etc}/${oatfbf}.id ${oatfb}", # || rm -f ${oatfbf}.json",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }    
}
