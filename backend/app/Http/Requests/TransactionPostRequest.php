<?php

namespace App\Http\Requests;

use App\Rules\CategoryValidation;
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
            'transaction_type' => ['required', Rule::in(config('enums.transaction_type'))],
            'category' => ['required', new CategoryValidation($this->input('transaction_type'))],
            'account_number' => 'required_if:transaction_type,TRANSFER|nullable',
            'account_name' => 'required_if:transaction_type,TRANSFER|nullable',
        ];
    }
}
