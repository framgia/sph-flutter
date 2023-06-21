<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\DB;

class TransactionFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        // $type_enums = config('enums.transaction_type'); //TODO: For more variation in seeding
        // $category_enums = config('enums.transaction_category'); //TODO: For more variation in seeding
        $account = DB::table('accounts')->inRandomOrder()->first();
        $starting_balance = rand(1000, 20000);
        $transaction_amount = rand(1000, 20000);

        $transaction_template = [
            'id' => $this->faker->unique()->uuid(),
            'account_id' => $account->id,
            'user_id' => $account->user_id,
            'transaction_date' => now(),
            'transaction_type' => 'CREDIT', //TODO:replace if a more complex seeder is needed
            'category' => 'SAVINGS', //TODO:replace if a more complex seeder is needed
            'description' => $this->faker->paragraph($nbSentences = 3, $variableNbSentences = true),
            'transaction_id' => null,
            'starting_balance' => $starting_balance,
            'transaction_amount' => $transaction_amount,
        ];

        return $transaction_template;
    }
}
