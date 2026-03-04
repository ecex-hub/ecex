<?php

return [
    'redis.prefix' => 'prod-ecex',
    'cdn_url' => 'https://ecex.cc/api',
    'base_url' => 'https://ecex.cc/api',
    'return_url' => 'https://ecex.cc',
    'return_url_app' => 'https://ecex.cc',
    'resourceHostCdn' => 'https://ecex.cc/api',
    'admin_cdn_url' => 'https://ecex.cc/api',
    'aliyun_sms_key_id' => getenv('ALIYUN_SMS_ACCESS_KEY_ID'),
    'aliyun_sms_key_secret' => getenv('ALIYUN_SMS_ACCESS_KEY_SECRET'),
];