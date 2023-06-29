<?php

use App\Http\Controllers\AccountController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\TransactionController;
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

Route::get('health', function () {
    return 'healthy';
});
Route::post('login', [AuthController::class, 'login']);
Route::apiResource('auth', AuthController::class)->only('store');

Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('reset-password', [AuthController::class, 'resetPassword']);

Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::post('logout', [AuthController::class, 'logout']);
    Route::get('user', function (Request $request) {
        return UserResource::make($request->user());
    });
    Route::get('users/search', [UserController::class, 'search']);
    Route::apiResource('users', UserController::class)->only(['index', 'update', 'show', 'destroy']);
    Route::apiResource('auth', AuthController::class)->only('update')->parameters(['auth' => 'user']);
    Route::apiResource('users.accounts', AccountController::class)->shallow()->only(['index']);
    Route::apiResource('accounts', AccountController::class)->only(['index', 'show']);
    Route::apiResource('accounts.transactions', TransactionController::class)->shallow()->only(['index', 'store']);
    Route::apiResource('transactions', TransactionController::class)->only(['index', 'show']);
});
