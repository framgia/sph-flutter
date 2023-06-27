<?php

namespace App\Observers;

use App\Models\Transaction;

class TransactionObserver
{
    public function creating(Transaction $transaction)
    {
        // ($transaction->type === DEPT) balance++
        // ($transaction->type === TRANSFER) balance--
        // ($transaction->type === CREDIT) balance--

        if ($transaction->starting_balance + $transaction->transaction_amount < 0) {
            return false;
        }

        return true;

    }
}
