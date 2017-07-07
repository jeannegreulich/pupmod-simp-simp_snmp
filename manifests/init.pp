class simp_snmp (
  String $snmp_group ='snmp',
  String $rouser,
  String $rwuser
) {
 
  include simp_snmp::snmpd::users
  include simp_snmp::local
  include simp_snmp::iptables
  include simp_snmp::access

  group { "${simp_snmp::snmp_group}":
    ensure => present,
    system => no
  }


  file { '/etc/snmp/snmpd.d':
    owner => 'root',
    group => $snmp_group,
    mode  => '0750',
    ensure => directory
  }

  file { '/etc/snmp/simp.snmpd.d':
    owner => 'root',
    group => $snmp_group,
    mode  => '0750',
    ensure => directory
  }


  $snmp_config = [
	  'defVersion 3',
	  'defSecurityLevel authPriv',
	  'defSecurityModel usm',
	  'defAuthType SHA',
	  'defPrivType AES',
  ]

  $snmpd_config = [
          'includeDir /etc/snmp/snmpd.d',
          'includeDir /etc/snmp/simp.snmpd.d',
  ]
   
  $agentaddress = [ '127.0.0.1:161',"${facts['ipaddress']}:161"]

  class { 'snmp':
          agentaddress        => $agentaddress,
	  manage_client       => true,
	  service_ensure      => 'running',
	  trap_service_ensure => 'stopped',
	  snmp_config         => $snmp_config,
	  snmpd_config        => $snmpd_config,
          service_config_dir_group => $snmp_group,
          location            => "Main snmp conf file",
          com2sec             => [],
          com2sec6            => [],
          ro_community        => [],
          ro_community6       => [],
          rw_community        => [],
          rw_community6       => []
  }
}    
