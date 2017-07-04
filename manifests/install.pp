# == Class simp_snmp::install
#
# This class is called from simp_snmp for install.
#
class simp_snmp::install {
  assert_private()

  package { $::simp_snmp::package_name:
    ensure => present
  }
}
