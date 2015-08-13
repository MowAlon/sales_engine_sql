require_relative 'test_helper'
require_relative '../lib/customer.rb'

class CustomerTest < MiniTest::Test

  def test_invoices__it_returns_an_array_of_invoices
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [1, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [1, 75, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]
    customer = engine.customer_repository.find_by_id(1)

    assert_equal Array, customer.invoices.class
    assert_equal 2, customer.invoices.size
    assert customer.invoices.all?{|invoice| invoice.class == Invoice}
  end

  def test_invoices__it_returns_the_correct_invoices
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [1, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [2, 75, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [1, 76, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]
    customer = engine.customer_repository.find_by_id(1)

    assert_equal 1, customer.invoices[0].id
    assert_equal 3, customer.invoices[1].id
  end

  def test_invoices__it_returns_an_empty_array_when_no_invoices_are_associated_with_the_customer
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [2, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [3, 75, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [4, 76, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]
    customer = engine.customer_repository.find_by_id(1)

    assert_equal [], customer.invoices
  end

  def test_transactions__it_returns_an_array_of_transactions
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [1, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [2, 75, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [1, 76, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]

    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [1, "4654405418249632", nil, "success", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [2, "4580251236515201", nil, "failed", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [3, "4580251236515201", nil, "failed", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    customer = engine.customer_repository.find_by_id(1)

    assert_equal Array, customer.transactions.class
    assert_equal 2, customer.transactions.size
    assert customer.transactions.all?{|transaction| transaction.class == Transaction}
  end

  def test_transactions__it_returns_an_empty_array_when_no_transactions_exist_for_that_customer
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [3, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [2, 75, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [3, 76, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]

    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [1, "4654405418249632", nil, "success", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [2, "4580251236515201", nil, "failed", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [3, "4580251236515201", nil, "failed", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    customer = engine.customer_repository.find_by_id(1)

    assert_equal [], customer.transactions
  end

  def test_favorite_merchant__it_returns_a_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    customer = engine.customer_repository.find_by(:id, 1)

    assert_equal Merchant, customer.favorite_merchant.class
  end

  def test_favorite_merchant__it_returns_the_right_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    customer = engine.customer_repository.find_by(:id, 1)
    assert_equal 6, customer.favorite_merchant.id
  end

  def test_favorite_merchant__it_returns_nil_when_the_customer_has_no_favorite_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    customer = engine.customer_repository.find_by(:id, 20)

    refute customer.favorite_merchant
  end
end
