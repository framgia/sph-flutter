<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProfileRequest;
use App\Http\Resources\LoginResource;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class UserController extends Controller
{
    public function index()
    {
        return UserResource::collection(User::all());
    }

    public function login(Request $request)
    {
        $credentials = $this->validate($request, [
            'email' => ['required', Rule::exists('users', 'email')],
            'password' => ['required'],
        ]);

        if (! Auth::attempt($credentials)) {
            throw ValidationException::withMessages([
                'email' => 'Your provided credentials could not be verified.',
            ]);
        }

        $user = User::where('email', $credentials['email'])->first();
        $user->tokens()->delete();
        $token = $user->createToken('login')->plainTextToken;

        return LoginResource::make(array_merge($user->toArray(), ['token' => $token]));
    }

    public function update(ProfileRequest $request, User $user)
    {
        $profileInfo = $request->validated();

        $user->update($profileInfo);

        return UserResource::make(array_merge(['message' => 'Profile info updated successfully.'], $profileInfo));
    }
}
