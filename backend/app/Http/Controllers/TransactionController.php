<?php

namespace App\Http\Controllers;

use App\Http\Requests\TransactionPostRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Account;
use App\Models\Transaction;

class TransactionController extends Controller
{
    public function index(Account $account = null)
    {
        // For /accounts/{account_id}/transactions
        if ($account) {
            // For shallow nesting
            // See https://laravel.com/docs/8.x/controllers#shallow-nesting
            return TransactionResource::collection($account->accountTransactions);
        }

        // For /transactions
        return TransactionResource::collection(Transaction::all());
    }

    public function show(Transaction $transaction)
    {
        return TransactionResource::make($transaction);
    }

    public function store(Account $myAccount, TransactionPostRequest $request)
    {
        //START
        // die('here');
        $payload = $request->validated();
        $transaction_date = now();

        // if ($this->isInvalidTransaction($myAccount, $payload)) {
        //     return abort(403, 'Not enough credit. Please try again.');
        // }

        if ($payload['transaction_type'] === 'CREDIT') {
            //TODO: Insert Credit Code
        }

        if ($payload['transaction_type'] === 'DEPT') {
            //TODO: Insert Deposit Code
        }

        $receiverAccount = Account::find($payload['receiver_id']);

        if (! $receiverAccount) {
            return abort(403, 'Receiver does not exist. Please try again.');
        }

        if ($payload['transaction_type'] === 'TRANSFER') {
            $senderData = [
                'account_id' => $myAccount->id,
                'user_id' => $myAccount->user_id,
                'transaction_type' => $payload['transaction_type'],
                'category' => 'SENDER',
                'description' => $payload['description'],
                'starting_balance' => $myAccount->getBalance(),
                'transaction_amount' => $payload['amount'] * -1,
                'transaction_date' => $transaction_date,
            ];
            $receiverData = [
                'account_id' => $receiverAccount->id,
                'user_id' => $receiverAccount->user_id,
                'transaction_type' => $payload['transaction_type'],
                'category' => 'RECIPIENT',
                'description' => $payload['description'],
                'starting_balance' => $receiverAccount->getBalance(),
                'transaction_amount' => $payload['amount'],
                'transaction_date' => $transaction_date,
            ];

            $sendRow = Transaction::create($senderData);

            if (! $sendRow->created_at) {
                abort(403, 'Transaction Failed. Please try again');
            }

            $receiverData['transaction_id'] = $sendRow->id;

            $receiverRow = Transaction::create($receiverData);

            if (! $receiverRow->created_at) {
                abort(403, 'Transaction Failed. Please try again');
                $sendRow->delete();
            }

            return ( new TransactionResource($senderData))->response()->setStatusCode(200);
        }
    }
}
