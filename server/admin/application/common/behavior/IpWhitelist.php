<?php
namespace app\common\behavior;

use think\Request;
use think\Db;

class IpWhitelist
{
    public function run(&$params)
    {
        // 获取客户端真实IP
        $request = Request::instance();
        $ip = $request->ip();
        
        // 从数据库查询启用的白名单IP
        $whitelist = Db::name('ip_whitelist')
            ->where('status', 1)
            ->column('ip');
        
        // 如果有白名单配置，则进行校验
        if (!empty($whitelist)) {
            $allow = false;
            foreach ($whitelist as $pattern) {
                if ($this->checkIp($ip, $pattern)) {
                    $allow = true;
                    break;
                }
            }
            if (!$allow) {
                // 记录日志（可选）
                // 直接返回错误并终止程序
                header('Content-Type: text/html; charset=utf-8');
                exit('您无权访问');
                // exit('您的IP地址'.$ip.'无权访问后台');
            }
        }
    }
    
    /**
     * IP匹配规则（支持通配符*和CIDR）
     * @param string $ip
     * @param string $pattern
     * @return bool
     */
    protected function checkIp($ip, $pattern)
    {
        $pattern = trim($pattern);
        
        // CIDR格式，如 192.168.1.0/24
        if (strpos($pattern, '/') !== false) {
            list($subnet, $mask) = explode('/', $pattern);
            if (ip2long($ip) & ~((1 << (32 - $mask)) - 1) == ip2long($subnet)) {
                return true;
            }
        }
        // 通配符格式，如 192.168.1.*
        elseif (strpos($pattern, '*') !== false) {
            $pattern = str_replace('.*', '.', $pattern);
            $pattern = preg_quote($pattern, '/');
            $pattern = str_replace('\*', '\d+', $pattern);
            if (preg_match('/^' . $pattern . '$/', $ip)) {
                return true;
            }
        }
        // 精确匹配
        else {
            if ($ip === $pattern) {
                return true;
            }
        }
        return false;
    }
}