require_relative 'test_helper'
require_relative '../lib/invoice_item'
require 'bigdecimal'

class InvoiceItemTest < MiniTest::Test

  def test_it_can_pull_an_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice_item = engine.invoice_item_repository.find_by(:id, 13)

    assert_equal Invoice, invoice_item.invoice.class
  end

  def test_it_pulls_the_correct_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice_item = engine.invoice_item_repository.find_by(:id, 1)

    assert_equal 1, invoice_item.invoice.id
    assert_equal 6, invoice_item.invoice.merchant_id
  end

  def test_it_returns_nil_when_invoice_is_not_found
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [9013, 29, 9810293810293, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_nil invoice_item.invoice
  end

  def test_it_can_pull_an_item
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice_item = engine.invoice_item_repository.find_by(:id, 8)

    assert_equal Item, invoice_item.item.class
  end

  def test_it_pulls_the_correct_item
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice_item = engine.invoice_item_repository.find_by(:id, 1)

    assert_equal 9, invoice_item.item.id
    assert_equal 22582, invoice_item.item.unit_price
  end

  def test_it_returns_nil_when_item_is_not_found
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [901334, 223423429, 9810293810293, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_nil invoice_item.item
  end

  def test_revenue__it_returns_revenue_when_the_transaction_is_successful
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [1, 1, 1, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal BigDecimal.new(1846), invoice_item.revenue
  end

  def test_revenue__it_returns_0_when_the_transaction_doesnt_exist
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [1, 1, 999999999, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal 0, invoice_item.revenue.to_i
  end

  def test_simple_revenue_it_returns_unit_price_times_quantity
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [1, 1, 999999999, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal BigDecimal.new(1846), invoice_item.simple_revenue.to_i
  end

  def test_merchant__it_returns_a_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [1, 1, 999999999, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal Merchant, invoice_item.merchant.class
  end

  def test_merchant__it_returns_the_right_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [1, 1, 34, 2, 923, '09309', '09382']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert_equal "Schroeder-Jerde", invoice_item.merchant.name
  end

  def test_successful_it_returns_false_when_it_was_part_of_a_transaction_that_never_succeeded
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [1, 1, 13, 1, 1, '1', '1']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    refute invoice_item.successful?
  end

  def test_successful_it_returns_false_when_there_is_no_such_transaction
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [1, 1, 9999, 1, 1, '1', '1']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    refute invoice_item.successful?
  end

  def test_successful_it_returns_true_when_the_transaction_was_successful
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [1, 1, 2, 1, 1, '1', '1']
    invoice_item = InvoiceItem.new(input_data, engine.invoice_item_repository)

    assert invoice_item.successful?
  end

  def test__add_invoice_items__it_creates_new_invoice_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 1)
    invoice_item_count = invoice.items.count
    item1 = engine.item_repository.find_by(:id, 12)
    item2 = engine.item_repository.find_by(:id, 13)
    engine.invoice_item_repository.add_invoice_items([item1, item2], invoice.id)

    assert_equal invoice_item_count + 2, invoice.items.count
  end

  def test_it_creates_the_successful_invoice_items_view
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    engine.invoice_item_repository.create_successful_invoice_items_view
    data = engine.db.execute("SELECT * FROM successful_invoice_items")
    engine.invoice_item_repository.drop_successful_invoice_items_view

    assert data.size > 0
  end
end
