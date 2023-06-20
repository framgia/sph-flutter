<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Account extends Model
{
    use HasFactory;

    protected $appends = [ //For adding custom logic
        'balance'
    ];

    protected $casts = [
        'id' => 'string',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function accountTransactions()
    {
        return $this->hasMany(Transaction::class);
    }

    //Takes the latest transaction and outputs the sum of balance and transaction amount if exists
    //otherwise returns null
    public function getBalanceAttribute()
    {
        $latest_transaction = $this->accountTransactions()->latest()->first();

        if (!$latest_transaction) {
            return null;
        }

        return $latest_transaction->starting_balance + $latest_transaction->transaction_amount;
    }
}
