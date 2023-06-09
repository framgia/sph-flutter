<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

use App\Models\Account;

class Transaction extends Model
{
    use HasFactory;

    public function account()
    {
        return $this->belongsTo(Account::class);
    }

    public function parent()
    {
        return $this->belongsTo(Transaction::class);
    }

    public function child()
    {
        return $this->hasOne(Transaction::class);
    }
}
