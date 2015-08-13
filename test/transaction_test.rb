require_relative 'test_helper'
require_relative '../lib/transaction'

class TransactionTest < MiniTest::Test

  def test__invoice__it_can_pull_an_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    transaction = engine.transaction_repository.find_by(:id, 1)

    assert_equal Invoice, transaction.invoice.class
  end

  def test__merchant__it_pulls_the_correct_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    transaction = engine.transaction_repository.find_by(:id, 1)

    assert_equal 1, transaction.invoice.id
    assert_equal 6, transaction.invoice.merchant_id
  end

  def test__successful__it_returns_true_for_a_successul_transaction
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    transaction = engine.transaction_repository.find_by(:id, 1)

    assert transaction.successful?
  end

  def test__successful__it_returns_false_for_a_successul_transaction
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    transaction = engine.transaction_repository.find_by(:id, 11)

    refute transaction.successful?
  end
end
