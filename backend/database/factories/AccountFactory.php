<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\DB;

class AccountFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {

        $userId = DB::table('users')->pluck('id')->random();

        return [
            'id' => $this->faker->unique()->uuid(),
            'user_id' => $userId,
            'account_type' => 1,
        ];
    }
}
