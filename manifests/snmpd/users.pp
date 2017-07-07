class simp_snmp::snmpd::users(
  Hash         $users_hash = $simp_snmp::users_hash,
) {
  
  $users_hash.each |String $username, Hash $settings| {
    $_authpass = $settings['authpass'] || passgen("snmp_auth_${username}")
    $_privpass = $settings['privpass'] || passgen("snmp_priv_${username}")
    snmp::snmpv3_user{ "${username}":
      authpass =>  $_authpass,
      authtype =>  $settings['authtype'],
      privtype =>  $settings['privtype'],
      privpass =>  $_privpass,
      daemon   =>  'snmpd'
    }
  }
    
  file { "${simp_snmp::simpconfigdir}/users.conf":
    owner   => ${simp_snmp::snmpd_user},
    group   => ${simp_snmp::snmpd_group},
    mode    => '0640',
    content => epp_template(${module_name}/snmpd/users.epp),
    require => File["${simp_snmp::simpconfigdir}"]
  }

}  
