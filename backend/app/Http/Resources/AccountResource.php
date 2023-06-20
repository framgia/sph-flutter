<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

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

        $data['amount'] = $this->getBalanceAttribute();
        $data['links'] = [
            'self' => route('accounts.show', ['account' => $this->id]),
        ];

        return $data;
    }
}
