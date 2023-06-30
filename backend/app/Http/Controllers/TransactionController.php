<?php

namespace App\Http\Controllers;

use App\Http\Requests\FilterTransactionRequest;
use App\Http\Requests\TransactionPostRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Account;
use App\Models\Transaction;
use Carbon\Carbon;
use Exception;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;

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

    public function store(Account $account, TransactionPostRequest $request)
    {
        //START
        $payload = $request->validated();

        try {
            // - to account
            if ($payload['transaction_type'] === 'CREDIT') {
                $sendRow = $this->creditTransaction($account, $payload);

                return TransactionResource::make($sendRow);
            }

            // + to $account
            if ($payload['transaction_type'] === 'DEPT') {
                abort(404, 'Transaction type not found'); //TODO: Insert Deposit Code
            }

            // - to $account , + to $receiverAccount
            $receiverAccount = Account::find($payload['receiver_id']);

            if ($payload['transaction_type'] === 'TRANSFER') {
                $sendRow = $this->transferTransaction($account, $receiverAccount, $payload);

                return TransactionResource::make($sendRow);
            }

        } catch (\Exception $e) {
            abort(403, $e->getMessage());
        }
    }

    private function creditTransaction(Account $account, $payload)
    {
        $transaction_date = now();
        $senderData = [
            'account_id' => $account->id,
            'user_id' => $account->user_id,
            'transaction_type' => $payload['transaction_type'],
            'category' => 'SENDER',
            'description' => $payload['description'],
            'starting_balance' => $account->getBalance(),
            'transaction_amount' => $payload['amount'] * -1,
            'transaction_date' => $transaction_date,
        ];

        return DB::transaction(function () use ($senderData) {

            try {

                $sendRow = Transaction::create($senderData);

                if (! $sendRow->created_at) {
                    throw new Exception('Transaction Failed. Please try again');
                }

                return $sendRow;
            } catch (\Exception $e) {
                throw $e;
            }

        }, 5);
    }

    private function transferTransaction(Account $account, Account $receiverAccount, $payload)
    {

        $transaction_date = now();
        $senderData = [
            'account_id' => $account->id,
            'user_id' => $account->user_id,
            'transaction_type' => $payload['transaction_type'],
            'category' => 'SENDER',
            'description' => $payload['description'],
            'starting_balance' => $account->getBalance(),
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

        return DB::transaction(function () use ($senderData, $receiverData) {
            try {
                $sendRow = Transaction::create($senderData);

                if (! $sendRow->created_at) {
                    throw new Exception('Transaction Failed. Please try again');
                }

                $receiverData['transaction_id'] = $sendRow->id;

                $receiverRow = Transaction::create($receiverData);

                if (! $receiverRow->created_at) {
                    throw new Exception('Transaction Failed. Please try again');
                }

                return $sendRow;
            } catch (\Exception $e) {
                throw $e;
            }
        }, 5);

    }
}
