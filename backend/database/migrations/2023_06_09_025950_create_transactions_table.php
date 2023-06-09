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
            $table->id();
            $table->unsignedBigInteger('account_id');
            $table->foreign('account_id')->references('id')->on('accounts')->constrained()->onDelete('cascade');
            $table->dateTime('transaction_date');
            $table->enum('transaction_type', [0, 1, 2, 3]);
            $table->enum('category',[0, 1, 2, 3, 4, 5, 6]);
            $table->longText('description');
            $table->unsignedBigInteger('transfer_id');
            $table->foreign('transfer_id')->references('id')->on('transactions')->nullable()->constrained()->onDelete('cascade');
            $table->double('starting_balance');
            $table->double('transaction_amount');
            $table->softDeletes();
            $table->timestamps();
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
