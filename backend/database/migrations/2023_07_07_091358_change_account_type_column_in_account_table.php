<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class ChangeAccountTypeColumnInAccountTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::statement("DROP TYPE IF EXISTS account_type_enum");
        DB::statement("CREATE TYPE account_type_enum AS ENUM ('SAVINGS', 'SALARY', 'BILLS', 'SENDER', 'RECIPIENT');");
        DB::statement("ALTER TABLE accounts add COLUMN account_type_enum account_type_enum");
        DB::statement(
            "Update accounts set account_type_enum = CASE account_type
                when 1 then cast('SAVINGS' as account_type_enum)
                when 2 then 'SALARY'
                when 3 then 'BILLS'
                when 4 then 'SENDER'
                when 5 then 'RECIPIENT'
            END;
            "
        );
        DB::statement("ALTER TABLE accounts DROP COLUMN account_type");
        DB::statement("ALTER TABLE accounts RENAME COLUMN account_type_enum to account_type");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        // TODO: FIX DOWN
        DB::statement("DROP TYPE IF EXISTS account_type_enum");
        DB::statement("ALTER TABLE accounts ALTER COLUMN account_type TYPE INTEGER");
    }
}
