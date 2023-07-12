<?php

namespace App\Rules;

use Illuminate\Contracts\Validation\Rule;

class CategoryValidation implements Rule
{
    /**
     * Create a new rule instance.
     *
     * @return void
     */
    public function __construct(private string $type)
    {
        //
    }

    /**
     * Determine if the validation rule passes.
     *
     * @param  string  $attribute
     * @param  mixed  $value
     * @return bool
     */
    public function passes($attribute, $value)
    {
        $type = $this->type;
        if ($type == 'DEPT' && in_array($value, ['SAVINGS', 'SALARY'])) {
            return true;
        }
        if ($type == 'CREDIT' && in_array($value, ['FOOD', 'TRANSPORTATION', 'BILLS', 'SAVINGS', 'MISC'])) {
            return true;
        }
        if ($type == 'TRANSFER' && in_array($value, ['SENDER', 'RECIPIENT'])) {
            return true;
        }

        return false;
    }

    /**
     * Get the validation error message.
     *
     * @return string
     */
    public function message()
    {
        return 'Wrong transaction category';
    }
}
