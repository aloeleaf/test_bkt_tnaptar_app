<?php
return [
    // PostgreSQL connection parameters
    'host'     => getenv('DB_HOST') ?: 'db',
    'port'     => getenv('DB_PORT') ?: '5432',
    'dbname'   => getenv('POSTGRES_DATABASE'),
    'user'     => getenv('POSTGRES_USER'),
    'password' => getenv('POSTGRES_PASSWORD'),
    'driver'   => 'pgsql', // Specify PostgreSQL driver

    // LDAP keys (unchanged)
    'ldap_server'         => getenv('LDAP_SERVER'),
    'ldap_domain'         => getenv('LDAP_DOMAIN'),
    'ldap_base_dn'        => getenv('LDAP_BASE_DN'),
    'ldap_required_groups'=> array_filter(array_map('trim', explode(',', getenv('LDAP_REQUIRED_GROUPS') ?: '')))
];
?>