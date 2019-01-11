# Class: pingfederate::server_settings
#
# Configure the server settings via the admin API. For documentation, see
# https://<server>:9999/pf-admin-api/api-docs
#
# This is not so easy as one would hope as many of the APIs require referencing a system-generated
# 'id' parameter that was created as the result of an earlier POST. These are written out of a file
# named *.id and then pulled in using 'pf-admin-api --subst id=filename.id'.
#
class pingfederate::server_settings inherits ::pingfederate {
  $pfapi = "${::pingfederate::install_dir}/local/bin/pf-admin-api"
  $etc = "${::pingfederate::install_dir}/local/etc"

  $ss = 'serverSettings'
  file { "${etc}/${ss}.json":
    ensure  => 'present',
    mode    => 'a=r',
    owner   => $::pingfederate::owner,
    group   => $::pingfederate::group,
    content => template("pingfederate/${ss}.json.erb"),
  }
  ~> exec {"pf-admin-api PUT ${ss}":
    command     => "${pfapi} -m PUT -j ${etc}/${ss}.json -r ${etc}/${ss}.json.out ${ss}",
    refreshonly => true,
    user        => $::pingfederate::owner,
    logoutput   => true,
  }

  $pcv = 'passwordCredentialValidators'
  file {"${etc}/${pcv}.json":
    ensure  => 'present',
    mode    => 'a=r',
    owner   => $::pingfederate::owner,
    group   => $::pingfederate::group,
    content => template("pingfederate/${pcv}.json.erb"),
  }
  ~> exec {"pf-admin-api POST ${pcv}":
    command     => "${pfapi} -m POST -j ${etc}/${pcv}.json -r ${etc}/${pcv}.json.out ${pcv}",
    refreshonly => true,
    user        => $::pingfederate::owner,
    logoutput   => true,
  }


  # Pingfederate version >= 9 sets oauth CORS via an oauth/authServerSettings instead of editing webdefault.xml

  $allowed_origins = split($::pingfederate::cors_allowedorigins, ',')
  $pf_ver = $::pingfederate::package_ensure
  $oas = 'oauth/authServerSettings'
  $oasf = 'oauth_authServerSettings'
  file {"${etc}/${oasf}.json":
    ensure  => 'present',
    mode    => 'a=r',
    owner   => $::pingfederate::owner,
    group   => $::pingfederate::group,
    content => template("pingfederate/${oasf}.json.erb"),
  }
  ~> exec {"pf-admin-api PUT ${oas}":
    command     => "${pfapi} -m PUT -j ${etc}/${oasf}.json -r ${etc}/${oasf}.json.out ${oas}",
    refreshonly => true,
    user        => $::pingfederate::owner,
    logoutput   => true,
  }

  # authenticationPolicyContracts link sp/idpConnections and oauth/authenticationPolicyContractMappings
  # by the 'id' that is the result of a POST. We identify our contacts by the 'name' which is used in
  # the JSON filename in order to find the 'id' to link by. oauth/authServerSettings comes first because
  # if defines the persistentGrantContract attributes that are referenced by these.

  $apc = 'authenticationPolicyContracts'
  $::pingfederate::auth_policy_contract.each |$a| {
    # need to check for existence of each key and replace missing values with defaults
    $b = deep_merge($::pingfederate::auth_policy_contract_default,$a)
    if !has_key($b,'name') {
      fail('auth_policy_contract must have a name')
    }
    $n=$b['name']
    $un=uriescape($n)
    file { "${etc}/${apc}_${un}.json":
      ensure    => 'present',
      subscribe => Exec["pf-admin-api PUT ${oas}"],
      mode      => 'a=r',
      owner     => $::pingfederate::owner,
      group     => $::pingfederate::group,
      content   => template("pingfederate/${apc}.json.erb"),
    }
    ~> exec { "pf-admin-api POST ${apc}_${un}":
      command     => "${pfapi} -m POST -j ${etc}/${apc}_${un}.json -r ${etc}/${apc}_${un}.json.out -i ${etc}/${apc}_${un}.id ${apc}",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }

    $apcm = 'oauth/authenticationPolicyContractMappings'
    $apcmf = 'oauth_authenticationPolicyContractMappings'

    file {"${etc}/${apcmf}_${un}.json":
      ensure    => present,
      subscribe => [Exec["pf-admin-api PUT ${oas}"],Exec["pf-admin-api POST ${apc}_${un}"]],
      mode      => 'a=r',
      owner     => $::pingfederate::owner,
      group     => $::pingfederate::group,
      content   => template("pingfederate/${apcmf}.json.erb"),
    }
    ~> exec { "pf-admin-api POST ${apcm}_${un}":
      command     => @("END"/L),
        ${pfapi} -m POST -j ${etc}/${apcmf}_${un}.json -s id=${etc}/${apc}_${un}.id
         -r ${etc}/${apcmf}_${un}.json.out -i ${etc}/${apcmf}_${un}.id ${apcm}
        |-END
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  } # end $::pingfederate::auth_policy_contract.each

  if $::pingfederate::oauth_svc_acc_tok_mgr_id {
    $atm = 'oauth/accessTokenManagers'
    $atmf = 'oauth_accessTokenManagers'
    Exec["pf-admin-api PUT ${oas}"]
    ~> file {"${etc}/${atmf}.json":
      ensure  => 'present',
      mode    => 'a=r',
      owner   => $::pingfederate::owner,
      group   => $::pingfederate::group,
      content => template("pingfederate/${atmf}.json.erb"),
    }
    ~> exec {"pf-admin-api POST ${atm}":
      command     => "${pfapi} -m POST -j ${etc}/${atmf}.json -r ${etc}/${atmf}.json.out ${atm}",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  } # endif $::pingfederate::oauth_svc_acc_tok_mgr_id

  # TODO: refactor to iterate over a list of policies
  if $::pingfederate::oauth_oidc_policy_id {
    $oip = 'oauth/openIdConnect/policies'
    $oipf = 'oauth_openIdConnect_policies'
    $ois = 'oauth/openIdConnect/settings'
    $oisf = 'oauth_openIdConnect_settings'
    file {"${etc}/${oipf}.json":
      ensure  => 'present',
      mode    => 'a=r',
      owner   => $::pingfederate::owner,
      group   => $::pingfederate::group,
      content => template("pingfederate/${oipf}.json.erb"),
    }
    ~> exec {"pf-admin-api POST ${oip}":
      command     => "${pfapi} -m POST -j ${etc}/${oipf}.json -r ${etc}/${oipf}.json.out ${oip}",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
    ~> file {"${etc}/${oisf}.json":
      ensure  => 'present',
      mode    => 'a=r',
      owner   => $::pingfederate::owner,
      group   => $::pingfederate::group,
      content => template("pingfederate/${oisf}.json.erb"),
    }
    ~> exec {"pf-admin-api PUT ${ois}":
      command     => "${pfapi} -m PUT -j ${etc}/${oisf}.json -r ${etc}/${oisf}.json.out ${ois}",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  } # endif $::pingfederate::oauth_oidc_policy_id

  # need to iterate, fill in defaults, use auth_policy_contract as filename component for $apc_*.id
  # move this up closer to the apc stuff?
  $::pingfederate::saml2_idp.each |$a| {
    $spidp = 'sp/idpConnections'
    $spidpf = 'sp_idpConnections'
    $b = deep_merge($::pingfederate::saml2_idp_default,$a)
    $x509_string = regsubst($b['cert_content'],'\n','\\n','G')
    if !has_key($b,'auth_policy_contract') or !has_key($b,'name') or $b['auth_policy_contract'] == undef or $b['name'] == undef {
      fail("saml2_idp => 'name' and/or 'auth_policy_contract' is missing")
    }
    $n=$b['name']
    $un=uriescape($n)
    $an=$b['auth_policy_contract']
    $uan=uriescape($an)
    if $b['metadata'] != '' {
      $md = 'metadataUrls'
      Exec["pf-admin-api POST ${apc}_${uan}"]
      ~> file {"${etc}/${md}_${un}.json":
        ensure  => present,
        mode    => 'a=r',
        owner   => $::pingfederate::owner,
        group   => $::pingfederate::group,
        content => template("pingfederate/${md}.json.erb"),
      }
      ~> exec {"pf-admin-api POST ${md}_${un}":
        notify      => File["${etc}/${spidpf}_${un}.json"],
        command     => "${pfapi} -m POST -j ${etc}/${md}_${un}.json -r ${etc}/${md}_${un}.json.out -i ${etc}/${md}_${un}.id ${md}",
        refreshonly => true,
        user        => $::pingfederate::owner,
        logoutput   => true,
      }
      $mdsubst = "-s metaId=${etc}/${md}_${un}.id"
    }
    else {
      $mdsubst = undef
    }

    Exec["pf-admin-api POST ${apc}_${uan}"]
    ~> file {"${etc}/${spidpf}_${un}.json":
      ensure  => present,
      mode    => 'a=r',
      owner   => $::pingfederate::owner,
      group   => $::pingfederate::group,
      content => template("pingfederate/${spidpf}.json.erb"),
    }
    ~> exec {"pf-admin-api POST ${spidp}_${un}":
      command     => @("END"/L),
        ${pfapi} -m POST -j ${etc}/${spidpf}_${un}.json -s id=${etc}/${apc}_${uan}.id ${mdsubst}
         -r ${etc}/${spidpf}_${un}.json.out -i ${etc}/${spidpf}_${un}.id ${spidp}
        |-END
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }

    $oatsp = 'oauth/accessTokenMappings'
    $oatspf = 'oauth_accessTokenMappings_saml2'
    Exec["pf-admin-api POST ${apc}_${uan}"]
    ~> file {"${etc}/${oatspf}_${un}.json":
      ensure  => present,
      mode    => 'a=r',
      owner   => $::pingfederate::owner,
      group   => $::pingfederate::group,
      content => template("pingfederate/${oatspf}.json.erb"),
    }
    ~> exec {"pf-admin-api POST ${oatsp}/saml2_${un}":
      command     => @("END"/L),
        ${pfapi} -m POST -j ${etc}/${oatspf}_${un}.json -s id=${etc}/${spidpf}_${un}.id 
          -r ${etc}/${oatspf}_${un}.json.out -i ${etc}/${oatspf}_${un}.id ${oatsp}
        |-END
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }

  } #end $::pingfederate.saml2_idp.each

  ###
  # SOCIAL OAUTH ADAPTERS
  # these adapters have a unique idp/adapters template and then common oauth/idpAdapterMappings
  # and oauth/accessTokenMappings templates. The adapter 'name' must match the template filename.
  # This will detect an incorrect adapter name by complaining about a missing template.
  ###

  # TODO: make sure an adapter wasn't previously defined and is now removed. Removal happens
  # in the reverse order of addition!

  $::pingfederate::social_adapter.each |$name, $a| {
    $b = deep_merge($::pingfederate::social_adapter_default,$a)
    $n = $name
    $un = uriescape($n)
    if str2bool($b['enable']) {
      $ida = 'idp/adapters'
      $idaf = "idp_adapters_${un}"
      $subid = "-s aid=${etc}/${idaf}.id"
      file {"${etc}/${idaf}.json":
        ensure  => 'present',
        mode    => 'a=r',
        owner   => $::pingfederate::owner,
        group   => $::pingfederate::group,
        content => template("pingfederate/${idaf}.json.erb"), # unique template per provider
      }
      ~> exec {"pf-admin-api POST ${idaf}":
        command     => "${pfapi} -m POST -j ${etc}/${idaf}.json -r ${etc}/${idaf}.json.out -i ${etc}/${idaf}.id ${ida}",
        refreshonly => true,
        user        => $::pingfederate::owner,
        logoutput   => true,
      }

      $oiam = 'oauth/idpAdapterMappings'
      $oiamt = 'oauth_idpAdapterMappings'
      $oiamf = "${oiamt}_${un}"
      file {"${etc}/${oiamf}.json":
        ensure    => 'present',
        subscribe => [
                      Exec["pf-admin-api POST ${idaf}"], # need idp/apapters/$un
                      Exec["pf-admin-api POST ${atm}"],  # need oauth/accessTokenManagers
                      ],
        mode      => 'a=r',
        owner     => $::pingfederate::owner,
        group     => $::pingfederate::group,
        content   => template("pingfederate/${oiamt}.json.erb"),
      }
      ~> exec {"pf-admin-api POST ${oiamf}":
        command     => "${pfapi} -m POST -j ${etc}/${oiamf}.json ${subid} -r ${etc}/${oiamf}.json.out ${oiam}",
        refreshonly => true,
        user        => $::pingfederate::owner,
        logoutput   => true,
      }

      $oatm = 'oauth/accessTokenMappings'
      $oatmt = 'oauth_accessTokenMappings'
      $oatmf = "${oatmt}_${un}"
      file {"${etc}/${oatmf}.json":
        ensure    => 'present',
        subscribe => [
                      Exec["pf-admin-api POST ${idaf}"],
                      Exec["pf-admin-api POST ${atm}"]
                      ],
        mode      => 'a=r',
        owner     => $::pingfederate::owner,
        group     => $::pingfederate::group,
        content   => template("pingfederate/${oatmt}.json.erb"),
      }
      ~> exec {"pf-admin-api POST ${oatmf}":
        command     => "${pfapi} -m POST -j ${etc}/${oatmf}.json  ${subid} -r ${etc}/${oatmf}.json.out -i ${etc}/${oatmf}.id ${oatm}",
        refreshonly => true,
        user        => $::pingfederate::owner,
        logoutput   => true,
      }
    } # end enabled?
  } # end $::pingfederate::social_adapter.each

  # authenticationSelectors check for presence of scopes which are defined in oauth/authServerSettings.
  $asel = 'authenticationSelectors'
  if !($::pingfederate::oauth_scope_fail_no_selection in [true,false]) {
    fail("oauth_scope_fail_no_selection must be one of 'true' or 'false'")
  }
  $::pingfederate::oauth_scope_selectors.each |$s| {
    if !has_key($s,'adapter') {
      fail('oauth_scope_selectors must have an adapter name')
    }
    $n = uriescape($s['adapter'])
    if !($s['type'] in ['IDP_ADAPTER','IDP_CONNECTION']) {
      fail("oauth_scope_selectors type must be IDP_ADAPTER or IDP_CONNECTION, not ${s['type']}.")
    }
    $scopes = $::pingfederate::oauth_svc_scopes + $::pingfederate::oauth_svc_scope_groups
    file {"${etc}/${asel}_${n}.json":
      ensure    => 'present',
      subscribe => Exec["pf-admin-api PUT ${oas}"],
      mode      => 'a=r',
      owner     => $::pingfederate::owner,
      group     => $::pingfederate::group,
      content   => template("pingfederate/${asel}.json.erb"),
    }
    ~>  exec {"pf-admin-api POST ${asel}_${n}":
      command     => "${pfapi} -m POST -j ${etc}/${asel}_${n}.json -r ${etc}/${asel}_${n}.json.out ${asel}",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }

  # authenticationPolicies/settings chooses to enable IdP and/or SP authentication selection.
  # For now we just hardcode to use IdP selection if there are scope selectors defined.
  if !empty($::pingfederate::oauth_scope_selectors) {
    $aps = 'authenticationPolicies/settings'
    $apsf = 'authenticationPolicies_settings'
    file {"${etc}/${apsf}.json":
      ensure    => 'present',
      subscribe => Exec["pf-admin-api PUT ${oas}"],
      mode      => 'a=r',
      owner     => $::pingfederate::owner,
      group     => $::pingfederate::group,
      content   => template("pingfederate/${apsf}.json.erb"),
    }
    ~> exec {"pf-admin-api PUT ${apsf}":
      command     => "${pfapi} -m PUT -j ${etc}/${apsf}.json -r ${etc}/${apsf}.json.out ${aps}",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
    # authenticationPolicies/default uses the authenticationSelectors defined above to choose IdPs.
    # N.B. there are idpConnections (saml) and idpAdapters (social). Because the sp/idpConnections have
    # a system-generated id, we have to pull the id in from the .id file. For consistency, do the same
    # for the idpAdapters. We iteretate the list once here to build up the "@@id@@'s" and again in the
    # ERB template which will reference those @@id@@'s.
    # XXX todo - turn facebook, etc. adapters into a list, and add selectors to the list.
    $apd = 'authenticationPolicies/default'
    $apdf = 'authenticationPolicies_default'
    # iterate pingfederate::oauth_scope_selectors and create an "id=..." for each ID file.
    # Make string like 'facebook=Facebook -s Columbia%20Univ=xyzzhfrbkwgjkfgke ... -s google=Google '
    $ids = $pingfederate::oauth_scope_selectors.map |$s|
    {
      $u=uriescape($s['adapter'])
      $f=case $s['type'] {
        'IDP_ADAPTER'   : { "${etc}/idp_adapters_${u}.id" }
        'IDP_CONNECTION' : { "${etc}/sp_idpConnections_${u}.id" }
        default         : { undef }
      }
      "${u}=${f}"
    }.join(' -s ')

    file {"${etc}/${apdf}.json":
      ensure    => 'present',
      subscribe => Exec["pf-admin-api PUT ${apsf}"],
      mode      => 'a=r',
      owner     => $::pingfederate::owner,
      group     => $::pingfederate::group,
      content   => template("pingfederate/${apdf}.json.erb"),
    }
    ~> exec { "pf-admin-api PUT ${apd}":
      command     => "${pfapi} -m PUT -j ${etc}/${apdf}.json -r ${etc}/${apdf}.json.out -s ${ids} ${apd}",
      refreshonly => true,
      user        => $::pingfederate::owner,
      logoutput   => true,
    }
  }
}
