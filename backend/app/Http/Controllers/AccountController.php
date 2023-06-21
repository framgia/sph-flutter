<?php

namespace App\Http\Controllers;

use App\Http\Resources\AccountResource;
use App\Models\Account;
use App\Models\User;

class AccountController extends Controller
{
    public function index($user_id = null)
    {

        //For /users/{user_id}/accounts
        if ($user_id) {
            //For shallow nesting
            // see https://laravel.com/docs/10.x/controllers#shallow-nesting

            $user = User::where('id', $user_id)->with(['userAccounts'])->first();
            return AccountResource::collection($user->userAccounts);
        }

        //For /accounts
        return AccountResource::collection(Account::with(['accountTransactions'])->get());
    }

    public function show(Account $account)
    {
        return AccountResource::make($account);
    }
}
