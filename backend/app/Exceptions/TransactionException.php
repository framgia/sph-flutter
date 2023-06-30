<?php

namespace App\Exceptions;

use Exception;

class TransactionException extends Exception
{
    private $data;

    public function __construct($message, object $data)
    {
        parent::__construct($message);
        $this->data = $data;
    }

    public function getError()
    {
        if ($this->data->transaction_type === 'CREDIT' | $this->data->transaction_type === 'TRANSFER') {
            error_log('here');
            if ($this->data->starting_balance < abs($this->data->transaction_amount)) {
                return 'Transaction Amount exceeds maximum possible value';
            }
        }

        return $this->message;
    }
}
