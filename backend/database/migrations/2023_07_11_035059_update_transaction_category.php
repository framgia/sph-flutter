<?php

use App\Models\Transaction;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class UpdateTransactionCategory extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('transactions', function (Blueprint $table) {
            DB::statement("ALTER TABLE `transactions` CHANGE `category` `category` ENUM('SAVINGS', 'SALARY', 'SENDER', 'RECIPIENT', 'FOOD', 'TRANSPORTATION', 'BILLS', 'MISC') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MISC';");
        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {

        Schema::table('transactions', function (Blueprint $table) {

            $transactions = Transaction::where('transaction_type', 'CREDIT')->get();
            foreach ($transactions as $transaction) {
                $transaction->category = 'BILLS';
                $transaction->save();
            }
            DB::statement("ALTER TABLE `transactions` MODIFY COLUMN `category` ENUM('SAVINGS', 'SALARY', 'SENDER', 'RECIPIENT', 'BILLS')  DEFAULT 'BILLS';");
        });

    }
}
