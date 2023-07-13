<?php

use App\Models\Account;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class UpdateAccountTypesInAccountsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('accounts', function () {
            Account::whereIn('account_type', ['BILLS', 'SENDER', 'RECIPIENT'])->update(['account_type' => 'SAVINGS']);

            DB::statement("ALTER TABLE `accounts` CHANGE `account_type` `account_type` ENUM('SAVINGS', 'SALARY') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SAVINGS';");
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('accounts', function () {
            DB::statement("ALTER TABLE `accounts` CHANGE `account_type` `account_type` ENUM('SAVINGS', 'SALARY', 'BILLS', 'SENDER', 'RECIPIENT') DEFAULT 'SAVINGS';");
        });
    }
}
