<?php
return [
    'ldap_server' => getenv('LDAP_SERVER'),
    'ldap_domain' => getenv('LDAP_DOMAIN'),
    'ldap_base_dn' => getenv('LDAP_BASE_DN'),
    //'ldap_group_dn' => 'CN=BKT_WebLoginGroup,OU=Groups,OU=Torvenyszek,OU=BudapestKornyeki_Tvsz,OU=Szervezet,DC=birosagiad,DC=hu',
    'ldap_required_groups' => array_filter(array_map('trim', explode(',', getenv('LDAP_REQUIRED_GROUPS') ?: ''))), // Convert comma-separated string to array and trim whitespace
    'db_host' => getenv('DB_HOST'),
    'db_name' => getenv('MYSQL_DATABASE'),
    'db_user' => getenv('MYSQL_USER'),
    'db_pass' => getenv('MYSQL_PASSWORD')
];