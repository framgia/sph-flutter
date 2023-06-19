<?php

namespace App\Exceptions;

use Exception;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Validation\ValidationException;
use Throwable;

class Handler extends ExceptionHandler
{
    /**
     * A list of the exception types that are not reported.
     *
     * @var array<int, class-string<Throwable>>
     */
    protected $dontReport = [
        //
    ];

    /**
     * A list of the inputs that are never flashed for validation exceptions.
     *
     * @var array<int, string>
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * Register the exception handling callbacks for the application.
     *
     * @return void
     */
    public function register()
    {
        $this->renderable(function (Exception $e, $request) {
            if (request()->wantsJson()) {
                if ($e instanceof ValidationException) {
                    $errors = $e->validator->errors()->getMessages();

                    return response()->json([
                        'error' => ['message' => $errors, 'code' => 400],
                    ], 400);
                }
            } else {
                return response()->json(['error' => $e->getMessage()], 500);
            }
        });
    }
}
