<?php

namespace App\Http\Controllers;

use App\Http\Resources\TransactionResource;
use App\Models\Account;
use App\Models\Transaction;

class TransactionController extends Controller
{
    public function index(Account $account = null)
    {
        // For /accounts/{account_id}/transactions
        if ($account) {
            // For shallow nesting
            // See https://laravel.com/docs/8.x/controllers#shallow-nesting
            return TransactionResource::collection($account->accountTransactions);
        }

        // For /transactions
        return TransactionResource::collection(Transaction::all());
    }

    public function show(Transaction $transaction)
    {
        return TransactionResource::make($transaction);
    }
}
