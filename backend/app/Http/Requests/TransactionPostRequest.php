<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;

class TransactionPostRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        // Check if account is bound to user
        return $this->account->user_id === Auth::id();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'description' => 'required|string',
            'amount' => 'required|numeric|gt:0',
            'receiver_id' => 'required_if:transaction_type,TRANSFER|nullable|uuid|exists:accounts,id',
            'transaction_type' => ['required', Rule::in(config('enums.transaction_type'))],
            'category' => ['required', $this->getCategoryValidationRule()],
        ];
    }

    private function getCategoryValidationRule()
    {
        return function ($attribute, $value, $fail) {
            $type = $this->input('transaction_type');
            if ($type == 'DEPT' && ! in_array($value, ['SAVINGS', 'SALARY'])) {
                $fail('Wrong transaction category');
            }
            if ($type == 'CREDIT' && ! in_array($value, ['FOOD', 'TRANSPORTATION', 'BILLS', 'SAVINGS', 'MISC'])) {
                $fail('Wrong transaction category');
            }
            if ($type == 'TRANSFER' && ! in_array($value, ['SENDER', 'RECIPIENT'])) {
                $fail('Wrong transaction category');
            }
        };
    }
}
