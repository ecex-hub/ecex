<?php
/**
 * base Helper.
 *
 *
 */
namespace common\helpers;

/**
 * base Helper
 */
class BaseHelper
{
    private static $Instances = array();
    
    /**
     * Base Helper.
     *
     * @return mixed.
     */
    public static function getInstance()
    {
        $class = get_called_class();
        if (!isset(self::$Instances[$class])) {
            self::$Instances[$class] = new static();
        }
        
        return self::$Instances[$class];
    }
}
