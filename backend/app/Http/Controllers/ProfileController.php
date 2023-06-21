<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProfileRequest;
use App\Http\Resources\UserResource;
use App\Models\User;

class ProfileController extends Controller
{
    public function update(ProfileRequest $request, $user_id)
    {
        $profileInfo = $request->validated();

        User::find($user_id)->update($profileInfo);

        return UserResource::make(array_merge(['message' => 'Profile info updated successfully.'], $profileInfo));
    }
}
