<?php

use App\Models\Transaction;

function getLatestTransaction($transactionId)
{
    return Transaction::where('account_id', $transactionId)->latest('created_at')->first();
}

function getStartingBalance($latestTransaction)
{
    return $latestTransaction ? $latestTransaction['starting_balance'] + $latestTransaction['transaction_amount'] : 0;
}
