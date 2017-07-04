# Full description of SIMP module 'simp_snmp' here.
#
# === Welcome to SIMP!
# This module is a component of the System Integrity Management Platform, a
# managed security compliance framework built on Puppet.
#
# ---
# *FIXME:* verify that the following paragraph fits this module's characteristics!
# ---
#
# This module is optimally designed for use within a larger SIMP ecosystem, but
# it can be used independently:
#
# * When included within the SIMP ecosystem, security compliance settings will
#   be managed from the Puppet server.
#
# * If used independently, all SIMP-managed security subsystems are disabled by
#   default, and must be explicitly opted into by administrators.  Please
#   review the +trusted_nets+ and +$enable_*+ parameters for details.
#
# @param service_name
#   The name of the simp_snmp service
#
# @param package_name
#   The name of the simp_snmp package
#
# @param trusted_nets
#   A whitelist of subnets (in CIDR notation) permitted access
#
# @param enable_auditing
#   If true, manage auditing for simp_snmp
#
# @param enable_firewall
#   If true, manage firewall rules to acommodate simp_snmp
#
# @param enable_logging
#   If true, manage logging configuration for simp_snmp
#
# @param enable_pki
#   If true, manage PKI/PKE configuration for simp_snmp
#
# @param enable_selinux
#   If true, manage selinux to permit simp_snmp
#
# @param enable_tcpwrappers
#   If true, manage TCP wrappers configuration for simp_snmp
#
# @author simp
#
class simp_snmp (
  String           $service_name           = 'simp_snmp',
  String           $package_name           = 'simp_snmp',
  Simplib::Port    $tcp_listen_port        = 9999,
  Simplib::Netlist $trusted_nets           = simplib::lookup('simp_options::trusted_nets', {'default_value' => ['127.0.0.1/32'] }),
  Boolean          $enable_pki             = simplib::lookup('simp_options::pki', { 'default_value' => false }),
  Boolean          $enable_auditing        = simplib::lookup('simp_options::auditd', { 'default_value' => false }),
  Boolean          $enable_firewall        = simplib::lookup('simp_options::firewall', { 'default_value' => false }),
  Boolean          $enable_logging         = simplib::lookup('simp_options::syslog', { 'default_value' => false }),
  Boolean          $enable_selinux         = simplib::lookup('simp_options::selinux', { 'default_value' => false }),
  Boolean          $enable_tcpwrappers     = simplib::lookup('simp_options::tcpwrappers', { 'default_value' => false })

) {

  $oses = load_module_metadata( $module_name )['operatingsystem_support'].map |$i| { $i['operatingsystem'] }
  unless $::operatingsystem in $oses { fail("${::operatingsystem} not supported") }

  include '::simp_snmp::install'
  include '::simp_snmp::config'
  include '::simp_snmp::service'
  Class[ '::simp_snmp::install' ]
  -> Class[ '::simp_snmp::config'  ]
  ~> Class[ '::simp_snmp::service' ]
  -> Class[ '::simp_snmp' ]

  if $enable_pki {
    include '::simp_snmp::config::pki'
    Class[ '::simp_snmp::config::pki' ]
    -> Class[ '::simp_snmp::service' ]
  }

  if $enable_auditing {
    include '::simp_snmp::config::auditing'
    Class[ '::simp_snmp::config::auditing' ]
    -> Class[ '::simp_snmp::service' ]
  }

  if $enable_firewall {
    include '::simp_snmp::config::firewall'
    Class[ '::simp_snmp::config::firewall' ]
    -> Class[ '::simp_snmp::service'  ]
  }

  if $enable_logging {
    include '::simp_snmp::config::logging'
    Class[ '::simp_snmp::config::logging' ]
    -> Class[ '::simp_snmp::service' ]
  }

  if $enable_selinux {
    include '::simp_snmp::config::selinux'
    Class[ '::simp_snmp::config::selinux' ]
    -> Class[ '::simp_snmp::service' ]
  }

  if $enable_tcpwrappers {
    include '::simp_snmp::config::tcpwrappers'
    Class[ '::simp_snmp::config::tcpwrappers' ]
    -> Class[ '::simp_snmp::service' ]
  }
}
