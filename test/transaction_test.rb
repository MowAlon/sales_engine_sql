require_relative 'test_helper'
require_relative '../lib/transaction'

class TransactionTest < MiniTest::Test

  @@engine = SalesEngine.new
  @@engine.startup

  def engine
    @@engine
  end

  def test_invoice__it_can_pull_an_invoice
    transaction = engine.transaction_repository.find_by(:id, 3)

    assert_equal Invoice, transaction.invoice.class
  end

  def test_merchant__it_pulls_the_correct_invoice
    transaction = engine.transaction_repository.find_by(:id, 3)

    assert_equal 4, transaction.invoice.id
    assert_equal 33, transaction.invoice.merchant_id
  end

  def test_success__it_returns_true_when_a_given_transaction_is_sucessful
    input_data =[1, 2, '9381938102', nil, 'success', '08071902', '01929382']
    transaction = Transaction.new(input_data, engine.transaction_repository)

    assert transaction.successful?
  end

  def test_success__it_returns_false_when_a_given_transaction_is_unsuccessful
    #give invoice id that coudln't possibly exist elsewhere
    input_data =[1, 2342352352352, '9381938102', nil, 'failed', '08071902', '01929382']
    transaction = Transaction.new(input_data, engine.transaction_repository)

    assert_equal(false, transaction.successful?)
  end

end
