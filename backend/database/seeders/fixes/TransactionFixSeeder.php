<?php

namespace Database\Seeders\Fixes;

use App\Models\Transaction;
use Illuminate\Database\Seeder;

class TransactionFixSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $transactions = Transaction::where('transaction_type', 'CREDIT')->get();
        $category_enums = config('enums.transaction_category');
        foreach ($transactions as $transaction) {
            $transaction->category = $category_enums[rand(3, 7)];
            $transaction->save();
        }
    }
}
