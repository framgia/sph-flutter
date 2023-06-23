<?php

namespace Database\Seeders;

use App\Models\Account;
use App\Models\Transaction;
use Illuminate\Database\Seeder;

class TransactionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {

        function processAccounts($accounts)
        {

            $latestTransaction1 = getLatestTransaction($accounts[0]->id);
            $latestTransaction2 = getLatestTransaction($accounts[1]->id);

            $accounts[0] = [
                'id' => $accounts[0]->id,
                'user_id' => $accounts[0]->user_id,
                'starting_balance' => getStartingBalance($latestTransaction1),
            ];

            $accounts[1] = [
                'id' => $accounts[1]->id,
                'user_id' => $accounts[1]->user_id,
                'starting_balance' => getStartingBalance($latestTransaction2),
            ];

            return $accounts;
        }

        $type_enums = config('enums.transaction_type');
        $category_enums = config('enums.transaction_category');

        for ($i = 0; $i <= 20; $i++) {
            $accounts = Account::inRandomOrder()->take(2)->get();
            $accounts = processAccounts($accounts);
            $transaction_type = $type_enums[rand(0, 2)];
            $category = $category_enums[2];
            $transaction_amount = rand(1000, 20000);

            if ($transaction_type === 'CREDIT') {
                $transaction_amount = $transaction_amount * -1;
                // Turn Credit to Deposit when Credit transaction results in less than 0
                // Remove comments if negative values are not allowed
                // if ($transaction_amount + $accounts[0]['starting_balance'] < 0) {
                //     $transaction_type = 'DEPT';
                //     $transaction_amount = $transaction_amount * -1;
                // }
            }

            if ($transaction_type === 'DEPT') {
                $category = $category_enums[rand(0, 1)];
            }

            if ($transaction_type === 'TRANSFER') {
                //Question: Should i cap transfer amount to starting balance to prevent negative values?

                $sender = Transaction::factory()->create([
                    'account_id' => $accounts[0]['id'],
                    'user_id' => $accounts[0]['user_id'],
                    'transaction_type' => $transaction_type,
                    'category' => 'SENDER',
                    'starting_balance' => $accounts[0]['starting_balance'],
                    'transaction_amount' => $transaction_amount * -1,
                ]);
                Transaction::factory()->create([
                    'account_id' => $accounts[1]['id'],
                    'user_id' => $accounts[1]['user_id'],
                    'transaction_type' => $transaction_type,
                    'transaction_id' => $sender->id,
                    'category' => 'RECIPIENT',
                    'starting_balance' => $accounts[1]['starting_balance'],
                    'transaction_amount' => $transaction_amount,
                ]);
            } else {
                Transaction::factory()->create([
                    'account_id' => $accounts[0]['id'],
                    'user_id' => $accounts[0]['user_id'],
                    'transaction_type' => $transaction_type,
                    'category' => $category,
                    'starting_balance' => $accounts[0]['starting_balance'],
                    'transaction_amount' => $transaction_amount,
                ]);
            }
            //To enable sort by created at
            sleep(1);
        }
    }
}
