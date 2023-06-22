<?php

namespace App\Http\Controllers;

use App\Http\Resources\TransactionResource;
use App\Models\Account;
use App\Models\Transaction;

class TransactionController extends Controller
{
    public function index($account_id = null)
    {

        //For /accounts/{account_id}/transactions
        if ($account_id) {
            //For shallow nesting
            // see https://laravel.com/docs/10.x/controllers#shallow-nesting
            $account = Account::where('id', $account_id)->with(['accountTransactions'])->first();

            return TransactionResource::collection($account->accountTransactions);
        }

        //For /transactions
        return TransactionResource::collection(Transaction::all());
    }

    public function show(Transaction $transaction)
    {
        return TransactionResource::make($transaction);
    }
}
