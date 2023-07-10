<?php

namespace Database\Seeders\Fixes;

use App\Models\Account;
use Illuminate\Database\Seeder;

class AccountFixSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $accounts = Account::where('account_number', null)->get();
        foreach ($accounts as $account) {
            $account->account_number = $account->generateUniqueCode();
            $account->save();
        }
    }
}
