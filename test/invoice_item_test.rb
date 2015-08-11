require_relative 'test_helper'
require_relative '../lib/invoice_item'
require 'bigdecimal'

# TRANSACTIONS
# id,invoice_id,credit_card_number,credit_card_expiration_date,result,created_at,updated_at
# 59,53,4933369324075499,,failed,2012-03-27 14:54:12 UTC,2012-03-27 14:54:12 UTC

# INVOICE ITEM
# id,item_id,invoice_id,quantity,unit_price,created_at,updated_at
# 1,539,1,5,13635,2012-03-27 14:54:09 UTC,2012-03-27 14:54:09 UTC

class InvoiceItemTest < MiniTest::Test

  @@engine = SalesEngine.new
  @@engine.startup

  def engine
    @@engine
  end

  def test_it_can_pull_an_invoice
    invoice_item = engine.invoice_item_repository.find_by(:id, 13)

    assert_equal Invoice, invoice_item.invoice.class
  end

  def test_it_pulls_the_correct_invoice
    invoice_item = engine.invoice_item_repository.find_by(:id, 13)

    assert_equal 3, invoice_item.invoice.id
    assert_equal 78, invoice_item.invoice.merchant_id
  end

  def test_it_returns_nil_when_invoice_is_not_found
    input_data = [9013, 29, 9810293810293, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_nil invoice_item.invoice
  end

  def test_it_can_pull_an_item
    invoice_item = engine.invoice_item_repository.find_by(:id, 8)

    assert_equal Item, invoice_item.item.class
  end

  def test_it_pulls_the_correct_item
    invoice_item = engine.invoice_item_repository.find_by(:id, 8)

    assert_equal 534, invoice_item.item.id
    assert_equal 76941, invoice_item.item.unit_price
  end

  def test_it_returns_nil_when_item_is_not_found
    input_data = [901334, 223423429, 9810293810293, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_nil invoice_item.item
  end

  def test_revenue__it_returns_revenue_when_the_transaction_is_successful
    input_data = [1, 1, 1, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal BigDecimal.new(1846), invoice_item.revenue
  end

  def test_revenue__it_returns_0_when_the_transaction_doesnt_exist
    input_data = [1, 1, 999999999, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal 0, invoice_item.revenue.to_i
  end

  def test_simple_revenue_it_returns_unit_price_times_quantity
    input_data = [1, 1, 999999999, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal BigDecimal.new(1846), invoice_item.simple_revenue.to_i
  end

  def test_merchant__it_returns_a_merchant
    input_data = [1, 1, 999999999, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal Merchant, invoice_item.merchant.class
  end

  def test_merchant__it_returns_the_right_merchant
    input_data = [1, 1, 34, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal "Schroeder-Jerde", invoice_item.merchant.name
  end

  def test_successful_it_returns_false_when_it_was_part_of_a_transaction_that_never_succeeded
    input_data = [1, 1, 13, 1, 1, '1', '1']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    refute invoice_item.successful?
  end

  def test_successful_it_returns_false_when_there_is_no_such_transaction
    input_data = [1, 1, 9999, 1, 1, '1', '1']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    refute invoice_item.successful?
  end

  def test_successful_it_returns_true_when_the_transaction_was_successful
    input_data = [1, 1, 2, 1, 1, '1', '1']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert invoice_item.successful?
  end

end
