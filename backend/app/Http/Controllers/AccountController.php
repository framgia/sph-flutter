<?php

namespace App\Http\Controllers;

use App\Http\Resources\AccountResource;
use App\Models\Account;

class AccountController extends Controller
{
    public function index()
    {
        return AccountResource::collection(Account::with(['accountTransactions'])->get());
    }

    public function show(Account $account)
    {
        return AccountResource::make($account);
    }
}
