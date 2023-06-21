<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\UserController;
use App\Http\Resources\UserResource;
use App\Models\Account;
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
    Route::apiResource('users', UserController::class)->only(['index', 'update']);
    Route::apiResource('auth', AuthController::class)->only('update')->parameters(['auth' => 'user']);
    Route::apiResource('users.accounts', AccountController::class)->shallow()->only(['index']);
    Route::apiResource('accounts', AccountController::class)->only(['index', 'show']);
});

