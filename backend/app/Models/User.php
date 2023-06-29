<?php

namespace App\Models;

use App\Notifications\ResetPasswordNotification;
use App\Traits\Uuid;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\DB;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use Uuid;
    use HasApiTokens, HasFactory, Notifiable, SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_name',
        'password',
        'is_admin',
        'first_name',
        'last_name',
        'middle_name',
        'email',
        'address',
        'birthday',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
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
     * Set the user's password to its encrypted version.
     * see https://laravel.com/docs/8.x/eloquent-mutators#defining-a-mutator
     *
     * @param  string  $value
     * @return void
     */
    public function setPasswordAttribute($password)
    {
        $this->attributes['password'] = bcrypt($password);
    }

    public function userAccounts()
    {
        return $this->hasMany(Account::class);
    }

    public function userTransactions()
    {
        return $this->hasMany(Transaction::class);
    }

    public function sendPasswordResetNotification($token)
    {
        $this->notify(new ResetPasswordNotification($token));
    }

    /**
     * Get the list of searched users base on the keyword.
     *
     * @param string|null $keyword
     * @return object
     */
    public static function searchUsers(String | null $keyword)
    {
        return User::where('is_admin', false)
            ->where(function ($query) use ($keyword) {
                $query->where('first_name', 'LIKE', "%{$keyword}%")
                    ->orWhere('middle_name', 'LIKE', "%{$keyword}%")
                    ->orWhere('last_name', 'LIKE', "%{$keyword}%")
                    ->orWhere(DB::raw('CONCAT(first_name," ",last_name)'), 'LIKE', "%{$keyword}%")
                    ->orWhere(DB::raw('CONCAT(first_name," ",middle_name," ",last_name)'), 'LIKE', "%{$keyword}%");
            })
            ->get();
    }
}
