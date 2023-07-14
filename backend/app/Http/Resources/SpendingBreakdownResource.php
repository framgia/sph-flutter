<?php

namespace App\Http\Resources;

use Carbon\Carbon;
use Illuminate\Http\Resources\Json\JsonResource;

class SpendingBreakdownResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $data = collect(parent::toArray($request));

        $data->map(function ($item) {
            $item->diff_for_humans = Carbon::make($item->latest_transaction_date)
                ->diffForHumans(
                    ['options' => Carbon::JUST_NOW | Carbon::ONE_DAY_WORDS]
                );

            return $item;
        });

        return $data;
    }
}
