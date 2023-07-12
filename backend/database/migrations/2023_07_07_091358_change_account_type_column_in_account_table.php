<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

class ChangeAccountTypeColumnInAccountTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::statement("ALTER TABLE accounts MODIFY COLUMN account_type ENUM('SAVINGS', 'SALARY', 'BILLS', 'SENDER', 'RECIPIENT')");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::statement('ALTER TABLE accounts MODIFY COLUMN account_type INT');
    }
}
