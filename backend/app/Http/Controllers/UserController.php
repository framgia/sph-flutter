<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProfileRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Exception;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\UnauthorizedException;

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

    public function show(User $user)
    {
        return UserResource::make($user);
    }

    public function destroy(User $user)
    {
        if (Auth::user()->is_admin) {
            if ($user->id == Auth::id()) {
                throw new Exception('You cannot delete your own account.', 403);
            } elseif ($user->is_admin) {
                throw new Exception('You cannot delete an admin user.', 403);
            } else {
                $user->delete();

                return UserResource::make(array_merge(['message' => 'User has been successfully deleted.']));
            }
        } else {
            throw new UnauthorizedException('This action is unauthorized.', 401);
        }
    }
}
