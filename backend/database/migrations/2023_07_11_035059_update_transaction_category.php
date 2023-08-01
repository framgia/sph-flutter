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
        DB::statement("DROP TYPE IF EXISTS category_type_enum");
        DB::statement("CREATE TYPE category_type_enum AS ENUM ('SAVINGS', 'SALARY', 'SENDER', 'RECIPIENT', 'FOOD', 'TRANSPORTATION', 'BILLS', 'MISC')");
        // DB::statement("ALTER TABLE transactions ALTER COLUMN category TYPE account_type_enum USING category::category_type_enum");
        DB::statement("ALTER TABLE transactions ADD COLUMN category_enum category_type_enum");
        DB::statement("ALTER TABLE transactions ALTER COLUMN category_enum SET DEFAULT 'MISC'");
        DB::statement("Update transactions set category_enum = CAST (category as category_type_enum)");
        DB::statement("ALTER TABLE transactions DROP COLUMN category");
        DB::statement("ALTER TABLE transactions RENAME COLUMN category_enum to category");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {

        Schema::table('transactions', function (Blueprint $table) {

            // TODO: FIX DOWN
            Transaction::where('transaction_type', 'CREDIT')->update(['category' => 'BILLS']);
            DB::statement("ALTER TABLE `transactions` MODIFY COLUMN `category` ENUM('SAVINGS', 'SALARY', 'SENDER', 'RECIPIENT', 'BILLS')  DEFAULT 'BILLS';");
        });

    }
}
