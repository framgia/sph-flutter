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

    public function store(TransactionPostRequest $request)
    {
        function processAccounts($payload)
        {

            $myAccount = Account::findOrFail($payload['account_id']);
            $myLatestTransaction = getLatestTransaction($myAccount->id);

            if ($payload['transaction_type'] !== 'TRANSFER') {

                return [
                    [
                        'account_id' => $myAccount->id,
                        'user_id' => $myAccount->user_id,
                        'starting_balance' => getStartingBalance($myLatestTransaction),
                    ],
                ];
            }

            $recAccount = Account::findOrFail($payload['receiver_id']);
            $recLatestTransaction = getLatestTransaction($recAccount->id);

            return [
                [
                    'account_id' => $myAccount->id,
                    'user_id' => $myAccount->user_id,
                    'starting_balance' => getStartingBalance($myLatestTransaction),
                ],
                [
                    'account_id' => $recAccount->id,
                    'user_id' => $recAccount->user_id,
                    'starting_balance' => getStartingBalance($recLatestTransaction),
                ],
            ];

        }

        //START

        $payload = $request->collect();

        $accounts = processAccounts($payload);

        if ($payload['transaction_type'] === 'CREDIT') {
            //TODO: Insert Credit Code
        }

        if ($payload['transaction_type'] === 'DEPT') {
            //TODO: Insert Deposit Code
        }

        if ($payload['transaction_type'] === 'TRANSFER') {
            $transaction_date = now();
            $senderData = [
                'account_id' => $accounts[0]['account_id'],
                'user_id' => $accounts[0]['user_id'],
                'transaction_type' => $payload['transaction_type'],
                'category' => 'SENDER',
                'description' => $payload['description'],
                'starting_balance' => $accounts[0]['starting_balance'],
                'transaction_amount' => $payload['amount'] * -1,
                'transaction_date' => $transaction_date,
            ];
            $receiverData = [
                'account_id' => $accounts[1]['account_id'],
                'user_id' => $accounts[1]['user_id'],
                'transaction_type' => $payload['transaction_type'],
                'category' => 'RECIPIENT',
                'description' => $payload['description'],
                'starting_balance' => $accounts[1]['starting_balance'],
                'transaction_amount' => $payload['amount'],
                'transaction_date' => $transaction_date,
            ];

            $sendRow = Transaction::create($senderData);
            $receiverData['transaction_id'] = $sendRow->id;
            Transaction::create($receiverData);

            return response()->json([
                'message' => sprintf('Successfully Transferred %s to %s', $payload['amount'], $accounts[1]['account_id']),
            ], 200);
        }
    }
}
