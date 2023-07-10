<?php

namespace App\Traits;

use App\Models\Account;

//generates unique code for the account number
trait UniqueCodeTrait
{
    private static function _generateUniqueCode()
    {
        do {
            $code = (string) random_int(10000000000, 99999999999);
        } while (Account::where('account_number', $code)->exists());

        return $code;
    }

    /**
     * Boot function from Laravel.
     */
    protected static function bootUniqueCodeTrait()
    {
        static::creating(function ($model) {
            if (empty($model->{$model->getUniqueCodeKeyName()})) {
                $model->{$model->getUniqueCodeKeyName()} = static::_generateUniqueCode();
            }
        });
    }

    /**
     * trait function for generating unique code
     * use case: seeder
     */
    public function generateUniqueCode()
    {
        return static::_generateUniqueCode();
    }
}
