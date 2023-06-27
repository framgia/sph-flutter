<?php

namespace App\Http\Requests;

use App\Models\Account;
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
        if ($this->myAccount->user_id === Auth::id()) {
            return true;
        }

        return false;
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
            'transaction_type' => ['required', Rule::in(config('enums.transaction_type'))],
            'category' => ['required', Rule::in(config('enums.transaction_category'))],
            'amount' => 'required|numeric|gt:0',
            'receiver_id' => 'required_if:transaction_type,TRANSFER|nullable|uuid',
        ];
    }
}
