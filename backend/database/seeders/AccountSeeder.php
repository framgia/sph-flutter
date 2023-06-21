<?php

namespace Database\Seeders;

use App\Models\Account;
use App\Models\User;
use Illuminate\Database\Seeder;

class AccountSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $users = User::all();

        foreach ($users as $user) {
            $accounts = Account::factory(rand(1, 3))->create([
                'user_id' => $user->id,
            ]);
            foreach ($accounts as $account) {
                $account->save();
            }
        }
    }
}
