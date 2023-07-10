<?php

namespace App\Http\Controllers;

use App\Exceptions\TransactionException;
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
    public function index(FilterTransactionRequest $request, Account $account = null)
    {
        $filters = $request->validated();

        // Get transactions by all or through accounts
        // For shallow nesting see https://laravel.com/docs/8.x/controllers#shallow-nesting
        $transactions = ($account ? Transaction::where('account_id', $account['id']) : Transaction::all())
            ->with(['account'])
            ->orderBy('transaction_date')
            ->get();

        // Filter transactions by transaction type
        // TODO: add validation filter by transaction type
        if (in_array($request->type, config('enums.transaction_type'))) {
            $transactions = $transactions->where('transaction_type', $request->type);
        }

        // Filter transactions by date
        if (Arr::has($filters, ['from', 'to'])) {
            $transactions = $transactions->whereBetween('created_at', [$filters['from'], Carbon::make($filters['to'])->addDays(1)]);
        }

        return TransactionResource::collection($transactions);
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
            $sendRow = $this->creditTransaction($account, $payload);

            return TransactionResource::make($sendRow);
        }

        // + to $account
        if ($payload['transaction_type'] === 'DEPT') {
            $sendRow = $this->deptTransaction($account, $payload);

            return TransactionResource::make($sendRow);
        }

        // - to $account , + to $receiverAccount
        $receiverAccount = Account::find($payload['receiver_id']);

        if ($payload['transaction_type'] === 'TRANSFER') {
            $sendRow = $this->transferTransaction($account, $receiverAccount, $payload);

            return TransactionResource::make($sendRow);
        }
    }

    private function creditTransaction(Account $account, $payload)
    {
        $transaction_date = now();
        $creditData = [
            'account_id' => $account->id,
            'user_id' => $account->user_id,
            'transaction_type' => $payload['transaction_type'],
            'category' => $payload['category'],
            'description' => $payload['description'],
            'starting_balance' => $account->getBalance(),
            'transaction_amount' => $payload['amount'] * -1,
            'transaction_date' => $transaction_date,
        ];

        return DB::transaction(function () use ($creditData) {

            try {

                $creditRow = Transaction::create($creditData);

                if (! $creditRow->created_at) {
                    throw new TransactionException('Transaction Failed. Please try again', $creditRow);
                }

                return $creditRow;
            } catch (Exception $e) {
                throw $e;
            }
        }, 5);
    }

    private function deptTransaction(Account $account, $payload)
    {
        $transaction_date = now();
        $deptData = [
            'account_id' => $account->id,
            'user_id' => $account->user_id,
            'transaction_type' => $payload['transaction_type'],
            'category' => $payload['category'],
            'description' => $payload['description'],
            'starting_balance' => $account->getBalance(),
            'transaction_amount' => $payload['amount'],
            'transaction_date' => $transaction_date,
        ];

        return DB::transaction(function () use ($deptData) {

            try {

                $sendRow = Transaction::create($deptData);

                if (! $sendRow->created_at) {
                    throw new TransactionException('Transaction Failed. Please try again', $sendRow);
                }

                return $sendRow;
            } catch (Exception $e) {
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
                    throw new TransactionException('Transaction Failed. Please try again', $sendRow);
                }

                $receiverData['transaction_id'] = $sendRow->id;

                $receiverRow = Transaction::create($receiverData);

                if (! $receiverRow->created_at) {
                    throw new TransactionException('Transaction Failed. Please try again', $sendRow);
                }

                return $sendRow;
            } catch (Exception $e) {
                throw $e;
            }
        }, 5);
    }
}
