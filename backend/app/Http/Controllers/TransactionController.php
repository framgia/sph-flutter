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

    public function index(FilterTransactionRequest $request, Account $account = null)
    {
        $filters = $request->validated();

        // Get transactions by all or through accounts
        // For shallow nesting see https://laravel.com/docs/8.x/controllers#shallow-nesting
        $transactions = $account ? $account->accountTransactions : Transaction::all();

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
