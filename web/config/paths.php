<?php
// Auto-detect protocol (http or https)
$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || 
            ($_SERVER['SERVER_PORT'] ?? 80) == 443 ||
            (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https')
            ? 'https' : 'http';

return [
    'base_url' => $protocol . '://test_tnaptar.bpkornyekitvsz.birosagiad.hu',
];
