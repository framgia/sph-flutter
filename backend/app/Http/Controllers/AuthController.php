<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\SignupRequest;
use App\Http\Requests\UpdatePasswordRequest;
use App\Http\Resources\LoginResource;
use App\Http\Resources\LogoutResource;
use App\Http\Resources\SignupResource;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    // access token name when user logs in
    private $LOGINTOKEN = 'login';

    public function store(SignupRequest $request)
    {
        $validated = $request->validated();

        $user = User::create($validated);
        $token = $user->createToken($this->LOGINTOKEN)->plainTextToken;

        return SignupResource::make(array_merge($validated, ['token' => $token]));
    }

    public function login(LoginRequest $request)
    {
        $credentials = $request->validated();

        if (! Auth::attempt($credentials)) {
            throw ValidationException::withMessages([
                'email' => 'Your provided credentials could not be verified.',
            ]);
        }

        $user = User::where(
            'email',
            $credentials['email']
        )->first();
        $user->tokens()->delete();
        $token = $user->createToken($this->LOGINTOKEN)->plainTextToken;

        return LoginResource::make(array_merge($user->toArray(), ['token' => $token]));
    }

    public function logout()
    {
        $user = User::findOrFail(Auth::id());
        $user->tokens()->delete();

        return LogoutResource::make([
            'message' => 'Logged out successfuly.',
        ]);
    }

    //TODO: add login, signup, reset_password to the controller

    public function update(UpdatePasswordRequest $request, User $user)
    {
        $userPassword = $request->validated();

        $user->update(['password' => $userPassword['new_password']]);

        return UserResource::make(['message' => 'Password updated successfully.']);
    }
}
