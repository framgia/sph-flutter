<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class UserFactory extends Factory
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
            'user_name' => $this->faker->userName(),
            // password attribute is mutated when being created, see backend\app\Models\User.php
            'password' => 'password',
            'is_admin' => $this->faker->boolean(),
            'first_name' => $this->faker->firstName(),
            'last_name' => $this->faker->lastName(),
            'middle_name' => $this->faker->lastName(),
            'email' => $this->faker->unique()->safeEmail(),
            'address' => $this->faker->unique()->address(),
            'birthday' => $this->faker->dateTime(),
        ];
    }

    /**
     * Indicate that the model's email address should be unverified.
     *
     * @return \Illuminate\Database\Eloquent\Factories\Factory
     */
    public function unverified()
    {
        return $this->state(function (array $attributes) {
            return [
                'email_verified_at' => null,
            ];
        });
    }
}
