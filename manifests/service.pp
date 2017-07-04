# == Class simp_snmp::service
#
# This class is meant to be called from simp_snmp.
# It ensure the service is running.
#
class simp_snmp::service {
  assert_private()

  service { $::simp_snmp::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }
}
