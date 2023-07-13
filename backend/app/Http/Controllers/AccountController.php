<?php

namespace App\Http\Controllers;

use App\Http\Requests\AccountPostRequest;
use App\Http\Requests\SpendingBreakdownRequest;
use App\Http\Resources\AccountResource;
use App\Http\Resources\SpendingBreakdownResource;
use App\Models\Account;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

class AccountController extends Controller
{
    public function index($user_id = null)
    {
        //For /users/{user_id}/accounts
        if ($user_id) {
            //For shallow nesting
            // see https://laravel.com/docs/10.x/controllers#shallow-nesting

            $user = User::where('id', $user_id)
                ->with(['userAccounts', 'userAccounts.accountTransactions'])
                ->first();

            return AccountResource::collection($user->userAccounts);
        }

        //For /accounts
        return AccountResource::collection(Account::with(['accountTransactions'])->get());
    }

    public function show(Account $account)
    {
        return AccountResource::make($account);
    }

    public function store(AccountPostRequest $request)
    {
        $payload = $request->validated();

        $account = Account::create(array_merge($payload, ['user_id' => Auth::id()]));

        return AccountResource::make($account);
    }

    // api endpoint for retrieving aggregated data on an account's CREDIT transactions
    // @param days (null | 0 | 7 | 30) filter for transaction date between Now and {days} Days before
    // spending breakdown groups the transactions by the categories and the main data to manage
    //   is total_transaction_amount and latest_transaction_date
    // diff_for_human data is also made available to easily display words like "Yesterday"
    //   instead of a date time data
    public function spendingBreakdown(SpendingBreakdownRequest $request, Account $account)
    {
        $validated = $request->validated();

        $result = Account::getSpendingBreakdown($validated, $account);

        return SpendingBreakdownResource::make($result);
    }
}
