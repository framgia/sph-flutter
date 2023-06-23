<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class TransactionFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {

        return [
            'id' => $this->faker->unique()->uuid(),
            'transaction_date' => now(),
            'description' => $this->faker->paragraph($nbSentences = 3, $variableNbSentences = true),
            'transaction_id' => null,
        ];

    }
}
