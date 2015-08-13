require_relative 'test_helper'

class InvoiceTest < MiniTest::Test

  def test_transactions__it_gets_an_array_of_them
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)

    assert_equal Array, invoice.transactions.class
    assert invoice.transactions.all?{|transaction| transaction.class == Transaction}
  end

  def test_transactions__it_gets_the_correct_ones
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)
    transaction_ids = invoice.transactions.map {|transaction| transaction.id}
    cc_numbers = invoice.transactions.map {|transaction| transaction.credit_card_number}

    assert_equal [11, 12, 13], transaction_ids
  	assert_equal ["4800749911485986", "4017503416578382", "4536896898764278"], cc_numbers
  end

  def test_transactions__it_returns_an_empty_array_when_no_transactions_are_associated_with_the_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [999999, 9999999, 9999999, 'success', '99999999', '99999999']
    invoice = Invoice.new(input_data, engine.invoice_repository)

    assert_equal [], invoice.transactions
  end

  def test_invoice_items__it_gets_an_array_of_them
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)

    assert_equal Array, invoice.invoice_items.class
    assert invoice.invoice_items.all?{|invoice_item| invoice_item.class == InvoiceItem}
  end

  def test_invoice_items__it_gets_the_correct_ones
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 1)
    invoice_item_ids = invoice.invoice_items.map {|invoice_item| invoice_item.id}
    item_prices = invoice.invoice_items.map {|invoice_item| invoice_item.unit_price}

    assert_equal [1, 2, 3, 4, 5, 6, 7, 8], invoice_item_ids
    assert_equal [BigDecimal.new(22582), BigDecimal.new(34355),
                  BigDecimal.new(32301), BigDecimal.new(68723),
                  BigDecimal.new(22582), BigDecimal.new(75107),
                  BigDecimal.new(34018), BigDecimal.new(4291),
                  ], item_prices
  end

  def test_invoice_items__it_returns_an_empty_array_when_no_invoice_items_are_associated_with_the_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [999999, 999999, 99999999, 'success', '999999999', '99999999']
    invoice = Invoice.new(input_data, engine.invoice_repository)

    assert_equal [], invoice.invoice_items
  end

  def test_items__it_gets_an_array_of_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)

    assert_equal Array, invoice.items.class
    assert invoice.items.all?{|item| item.class == Item}
  end

  def test_items__it_gets_the_correct_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 1)
    item_ids = invoice.items.map {|item| item.id}

    assert_equal [9, 8, 3, 5, 1, 10, 4], item_ids
  end

  def test_items__it_returns_an_empty_array_when_no_items_are_associated_with_the_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    input_data = [999999, 999999, 999999, 'success', '999999', '999999']
    invoice = Invoice.new(input_data, engine.invoice_repository)

    assert_equal [], invoice.items
  end

  def test_customer__it_can_pull_a_customer
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)
    assert_equal Customer, invoice.customer.class
  end

  def test_customer__it_pulls_the_correct_customer
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)

    assert_equal "Mariah", invoice.customer.first_name
  end

  def test_merchant__it_can_pull_a_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)

    assert_equal Merchant, invoice.merchant.class
  end

  def test_merchant__it_pulls_the_correct_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)

    assert_equal "Osinski, Pollich and Koelpin", invoice.merchant.name
  end

  def test__revenue__it_returns_0_when_the_invoice_doesnt_have_a_corresponding_transaction
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    #we have made $0 from an invoice that has no transaction
    input_data = [2132123,2412312312,2312314123,'shipped','81231','123144']
    invoice = Invoice.new(input_data, engine.invoice_repository)

    assert_equal 0, invoice.revenue
  end

  def test__revenue__it_returns_a_big_decimal_when_given_a_valid_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 12)
    assert_equal BigDecimal, invoice.revenue.class
  end

  def test__revenue__it_returns_the_correct_revenue
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    invoice = engine.invoice_repository.find_by(:id, 1)

    assert_equal BigDecimal.new(1582109), invoice.revenue
  end

  def test__charge__it_results_in_new_transactions
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [3, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    invoice = engine.invoice_repository.all.last

    prior_transaction_count = engine.transaction_repository.all.count
    invoice.charge(credit_card_number: '1111222233334444',  credit_card_expiration_date: "10/14", result: "success")

    assert_equal prior_transaction_count.next, engine.transaction_repository.all.count
  end
end
