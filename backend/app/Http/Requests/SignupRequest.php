<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class SignupRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'user_name' => ['required'],
            'password' => ['required', 'confirmed'],
            'email' => ['required', 'email', Rule::unique('users', 'email')],
            'first_name' => ['required'],
            'middle_name' => [],
            'last_name' => ['required'],
            'address' => ['required'],
            'birthday' => ['required'],
        ];
    }
}
