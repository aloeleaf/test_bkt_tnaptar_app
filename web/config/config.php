<?php
return [
    // CORRECTED: Use standardized keys for the database connection
    'host'     => getenv('DB_HOST') ?: 'db', // Use 'db' (the service name) as the host for Docker
    'dbname'   => getenv('MYSQL_DATABASE'),
    'user'     => getenv('MYSQL_USER'),
    'password' => getenv('MYSQL_PASSWORD'),

    // LDAP keys (for Auth.php)
    'ldap_server'         => getenv('LDAP_SERVER'),
    'ldap_domain'         => getenv('LDAP_DOMAIN'),
    'ldap_base_dn'        => getenv('LDAP_BASE_DN'),
    'ldap_required_groups'=> array_filter(array_map('trim', explode(',', getenv('LDAP_REQUIRED_GROUPS') ?: '')))
];
?>