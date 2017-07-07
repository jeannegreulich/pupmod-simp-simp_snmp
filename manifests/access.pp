class simp_snmp::access
{

  $snmpd_access = [
     'group systemonly usm rwuser2',
     'group hostonly usm snmp_ro',
     'view systemonly included .1.3.6.1.2.1.1',
     'view systemonly included .1.3.6.1.2.1.25',
     'view all included .1',
     'access systemonly "" usm priv prefix systemonly none none',
     'access hostonly "" usm priv exact systemonly none none',
  ]

  file { '/etc/snmp/simp.snmpd.d/access.conf':
    owner => 'root',
    group => $simp_snmp::snmp_group,
    mode  => '0750',
    ensure => file,
    require => File['/etc/snmp/simp.snmpd.d'],
    content => $snmpd_access.join("\n"),
    notify  => Service['snmpd']
  }

}    
