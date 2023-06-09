<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTransactionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('account_id')->references('id')->on('accounts')->constrained()->onDelete('cascade');
            $table->foreignUuid('user_id')->references('id')->on('users')->constrained()->onDelete('cascade');
            $table->dateTime('transaction_date');
            $table->enum('transaction_type', ['CREDIT', 'DEPT', 'TRANSFER']);
            $table->enum('category',['SAVINGS', 'SALARY', 'BILLS', 'SENDER', 'RECIPIENT']);
            $table->longText('description');
            $table->uuid('transaction_id')->nullable();
            $table->double('starting_balance');
            $table->double('transaction_amount');
            $table->softDeletes();
            $table->timestamps();
        });

        Schema::table('transactions', function (Blueprint $table) {
            $table->foreign('transaction_id')->references('id')->on('transactions')->constrained()->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('transactions');
    }
}
