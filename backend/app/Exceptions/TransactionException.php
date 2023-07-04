<?php

namespace App\Exceptions;

use Exception;

class TransactionException extends Exception
{
    public function __construct($message, private object $data)
    {
        parent::__construct($message);
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
