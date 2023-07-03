<?php

namespace App\Http\Controllers;

use App\Http\Requests\Auth\ForgotPasswordRequest;
use App\Http\Requests\Auth\ResetPasswordRequest;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\SignupRequest;
use App\Http\Requests\UpdatePasswordRequest;
use App\Http\Resources\ForgotPasswordResource;
use App\Http\Resources\LoginResource;
use App\Http\Resources\LogoutResource;
use App\Http\Resources\ResetPasswordResource;
use App\Http\Resources\SignupResource;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Str;
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

        if (!Auth::attempt($credentials)) {
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

    public function forgotPassword(ForgotPasswordRequest $request)
    {
        $validated = $request->validated();

        $status = Password::sendResetLink(
            ['email' => $validated['email']]
        );

        Log::debug("Send Reset Link Status: [ $status ]");

        if ($status === Password::RESET_LINK_SENT) {
            return ForgotPasswordResource::make([
                'message' => 'The link was sent, please check your email',
            ]);
        } else {
            throw ValidationException::withMessages([
                'email' => ['Unable to send the reset link again, please double check your email'],
            ]);
        }
    }

    public function resetPassword(ResetPasswordRequest $request)
    {
        // Reset the user's password
        $validated = $request->validated();

        $user = User::where('email', $validated['email'])->first();

        if (!$user || Hash::check($validated['password'], $user->password)) {
            throw ValidationException::withMessages([
                'password' => 'password should not be an old password',
            ]);
        }

        $status = Password::reset(
            [
                'email' => $validated['email'],
                'password' => $validated['password'],
                'token' => $validated['token'],
            ],
            function ($user) use ($validated) {
                $user->forceFill([
                    'password' => $validated['password'],
                    'remember_token' => Str::random(60),
                ])->save();

                // Delete all existing tokens associated with the user
                $user->tokens()->delete();

                // Trigger the PasswordReset event
                event(new PasswordReset($user));
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return ResetPasswordResource::make([
                ['message' => 'Password was reset successfully'],
            ]);
        } else {
            throw ValidationException::withMessages([
                'password' => 'Your provided token could not be verified.',
            ]);
        }
    }
}
