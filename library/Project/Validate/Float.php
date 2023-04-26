<?php

/**
 * @see Zend_Validate_Abstract
 */
require_once 'Zend/Validate/Abstract.php';

class Project_Validate_Float extends Zend_Validate_Abstract
{
    const INVALID   = 'floatInvalid';
    const NOT_FLOAT = 'notFloat';

    /**
     * @var array
     */
    protected $_messageTemplates = array(
        self::INVALID   => "Invalid type given. String, integer or float expected",
        self::NOT_FLOAT => "'%value%' does not appear to be a float",
    );

    /**
     * Defined by Zend_Validate_Interface
     *
     * Returns true if and only if $value is a floating-point value
     *
     * @param  string $value
     * @return boolean
     */
    public function isValid($value)
    {
        $this->_setValue($value);

        if (!is_float($value) && !is_numeric($value)) {
            $this->_error(self::NOT_FLOAT);
            return false;
        }
        
        return true;
    }
}
