<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Arr;

class AccountResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {

        $data = parent::toArray($request);
        $transactions = $this->accountTransactions;
        unset($data['account_transactions']);

        if (count($transactions) === 0) {
            $data['balance'] = 0;

            return $data;
        }

        $sortedTransactions = Arr::sort($transactions, function ($value) {
            return $value['transaction_date'];
        });
        $latestTransaction = $sortedTransactions[0];

        $data['balance'] = $latestTransaction['starting_balance'] + $latestTransaction['transaction_amount'];

        return $data;
    }
}
