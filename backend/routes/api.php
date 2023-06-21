<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\UserController;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('login', [UserController::class, 'login']);

Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::get('user', function (Request $request) {
        return UserResource::make($request->user());
    });
    Route::apiResource('users', UserController::class)->only(['index']);
    Route::apiResource('profile', ProfileController::class)->only('update')->parameters(['profile' => 'user_id']);
    Route::apiResource('auth', AuthController::class)->only('update')->parameters(['auth' => 'user_id']);
});
