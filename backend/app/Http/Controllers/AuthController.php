<?php

namespace App\Http\Controllers;

use App\Http\Requests\UpdatePasswordRequest;
use App\Http\Resources\UserResource;
use App\Models\User;

class AuthController extends Controller
{
    //TODO: add login, signup, reset_password to the controller

    public function update(UpdatePasswordRequest $request, User $user)
    {
        $userPassword = $request->validated();

        $user->update(['password' => $userPassword['new_password']]);

        return UserResource::make(['message' => 'Password updated successfully.']);
    }
}
