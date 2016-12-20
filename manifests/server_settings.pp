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
      command     => "${pfapi} -m POST -j ${etc}/${apc}.json -r ${etc}/${apc}.json.out ${apc}", #  || rm -f ${apc}.json
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
    $ois = "oauth/openIdConnect/settings"
    $oisf = "oauth_openIdConnect_settings"
    $oip = "oauth/openIdConnect/policies"
    $oipf = "oauth_openIdConnect_policies"
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
    }
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
}

