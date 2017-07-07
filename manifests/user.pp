define simp_snmp::user(
  Boolean                   $genpasswd,
  Hash                      $authhash,
  Enum['snmpd','snmptrapd'] $daemon     
){
 
# ?  Do I have to set the length of the password based on type}

 if $genpasswd
   _authpasswd = passgen("snmp_auth_${name}")
 else { 
   _authpasswd = $authhash['authpass']
 }
   _privpass   = passgen("snmp_priv_${name}")
