<?php

namespace App\Http\Controllers;

use App\Http\Requests\TransactionPostRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Account;
use App\Models\Transaction;
use Exception;
use Illuminate\Support\Facades\DB;

class TransactionController extends Controller
{
    public static function transferTransaction(Account $account, Account $receiverAccount, $payload)
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

        DB::beginTransaction();
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
            DB::commit();
        } catch (\Exception $e) {
            DB::rollback();
            throw $e;
        }

        return $sendRow;
    }

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

        // - to account
        if ($payload['transaction_type'] === 'CREDIT') {
            //TODO: Insert Credit Code
        }

        // + to $account
        if ($payload['transaction_type'] === 'DEPT') {
            //TODO: Insert Deposit Code
        }

        // - to $account , + to $receiverAccount
        $receiverAccount = Account::find($payload['receiver_id']);

        if ($payload['transaction_type'] === 'TRANSFER') {
            try {
                $sendRow = $this->transferTransaction($account, $receiverAccount, $payload);

                return TransactionResource::make($sendRow);
            } catch (\Exception $e) {
                abort(403, $e->getMessage());
            }
        }
    }
}
