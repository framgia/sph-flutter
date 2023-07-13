<?php

namespace App\Models;

use App\Traits\UniqueCodeTrait;
use App\Traits\Uuid;
use Database\Factories\AccountFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Account extends Model
{
    use Uuid, UniqueCodeTrait;
    use HasFactory;

    /**
     * Create a new factory instance for the model.
     */
    protected static function newFactory()
    {
        return new AccountFactory();
    }

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',
        'account_type',
        'account_name',
        'account_number',
    ];

    /**
     * The data type of the auto-incrementing ID.
     *
     * @var string
     */
    protected $keyType = 'string';

    /**
     * Indicates if the model's ID is auto-incrementing.
     *
     * @var bool
     */
    public $incrementing = false;

    /**
     * function used in UniqueCodeTrait to retrieve the column
     * name where unique code will be stored.
     */
    public function getUniqueCodeKeyName()
    {
        return 'account_number';
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function accountTransactions()
    {
        return $this->hasMany(Transaction::class);
    }

    public function getBalance()
    {

        // ($transaction->type === DEPT) balance++
        // ($transaction->type === TRANSFER) balance--
        // ($transaction->type === CREDIT) balance--

        $transaction = $this->accountTransactions()->latest()->first();
        if ($transaction) {
            return $transaction['starting_balance'] + $transaction['transaction_amount'];
        }

        return 0;
    }

    public static function getAccountByNumberAndName(string $accountNumber, string $accountName)
    {
        $account = Account::where('account_number', $accountNumber)->first();

        if ($account) {
            $user = User::find($account->user_id);
            $fullName = $user->first_name.' '.$user->middle_name.' '.$user->last_name;
            similar_text(Str::lower($fullName), Str::lower($accountName), $percentSimilarity);
            
            if ($percentSimilarity >= 80) {
                return $account;
            }
        }

        return null;
    }
}
