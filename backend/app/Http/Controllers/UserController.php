<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProfileRequest;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\SignupRequest;
use App\Http\Resources\LoginResource;
use App\Http\Resources\SignupResource;
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

    public function update(ProfileRequest $request, User $user)
    {
        $profileInfo = $request->validated();

        $user->update($profileInfo);

        return UserResource::make(array_merge(['message' => 'Profile info updated successfully.'], $profileInfo));
    }
}
