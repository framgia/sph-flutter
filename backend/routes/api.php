<?php

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

    //Users custom routes
    Route::prefix('users')->group(function () {
        Route::put('info', [UserController::class, 'updateInfo']);
        Route::put('password', [UserController::class, 'updatePassword']);
    });
});
