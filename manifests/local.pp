class simp_snmp::local
{

  $snmp_local = [
     "sysLocation  snmp.local.conf",
     'sysContact snmp.local.con'
  ]

  $snmp_localsimpd = [
     "sysLocation  simp.snmpd.d/snmpd.local.conf",
     'sysContact simp.snmpd.d/snmpd.local.conf'
  ]

  $snmp_localsnmpd = [
     "sysLocation  snmpd.d/snmpd.local.conf",
     'sysContact snmpd.d/snmpd.local.con'
  ]


  file { '/etc/snmp/snmpd.local.conf':
    owner => 'root',
    group => $simp::snmp_group,
    mode  => '0750',
    ensure => file,
 #   content => $snmp_local.join("\n")
    content => ""
  }

  file { '/etc/snmp/simp.snmpd.d/snmpd.conf':
    owner => 'root',
    group => $simp_snmp::snmp_group,
    mode  => '0750',
    ensure => file,
    require => File['/etc/snmp/simp.snmpd.d'],
    content => $snmp_localsimpd.join("\n")
  }

  file { '/etc/snmp/snmpd.d/snmp.conf':
    owner => 'root',
    group => $simp_snmp::snmp_group,
    mode  => '0750',
    ensure => file,
    require => File['/etc/snmp/snmpd.d'],
    content => $snmp_localsnmpd.join("\n")
  }

}    
