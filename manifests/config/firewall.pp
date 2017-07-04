# == Class simp_snmp::config::firewall
#
# This class is meant to be called from simp_snmp.
# It ensures that firewall rules are defined.
#
class simp_snmp::config::firewall {
  assert_private()

  # FIXME: ensure your module's firewall settings are defined here.
  iptables::listen::tcp_stateful { 'allow_simp_snmp_tcp_connections':
    trusted_nets => $::simp_snmp::trusted_nets,
    dports       => $::simp_snmp::tcp_listen_port
  }
}
