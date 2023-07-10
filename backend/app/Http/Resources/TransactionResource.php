<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
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
            $data['account_name'] = $this->account->account_name;
            if($data['transaction_type'] == "TRANSFER"){
                if ($data['category'] == 'SENDER') {
                    $data['account_name'] = $this->child->account->account_name;
                }
                if ($data['category'] == 'RECIPIENT') {
                    $data['account_name'] = $this->parent->account->account_name;
                }
            }
            return $data;
        }
}
