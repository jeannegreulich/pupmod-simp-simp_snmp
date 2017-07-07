class simp_snmp::iptables(
  Simplib::Netlist   $trusted_nets = simplib::lookup('simp_options::trusted_nets', { 'default_value' => ['127.0.0.1'] }),
  Boolean            $tcpwrappers         = simplib::lookup('simp_options::tcpwrappers', { 'default_value' => false }),
  Integer	     $port = 161
){
   iptables::listen::udp { 'snmpd':
     trusted_nets => ['192.168.104.23'],
     dports       => [ $port ]
   }

  if $tcpwrappers {
    include '::tcpwrappers'
    tcpwrappers::allow { 'snmpd': pattern => 'ALL' }
    tcpwrappers::allow { 'snmp': pattern => 'ALL' }
  }

}  
