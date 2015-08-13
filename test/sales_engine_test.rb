require_relative 'test_helper'

class SalesEngineTest < MiniTest::Test

  def test_it_joins_a_default_path
    engine = SalesEngine.new
    assert engine.csv_path
  end

  def test_it_joins_a_non_default_path
    engine = SalesEngine.new("./data")
    assert_equal "./data", engine.csv_path
  end

  def test_it_joins_a_non_default_path2
    engine = SalesEngine.new("asdf")
    assert_equal "asdf", engine.csv_path
  end

  def test_it_creates_repositories
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    assert_equal CustomerRepository, engine.customer_repository.class
    assert_equal InvoiceRepository, engine.invoice_repository.class
    assert_equal TransactionRepository, engine.transaction_repository.class
    assert_equal InvoiceItemRepository, engine.invoice_item_repository.class
    assert_equal MerchantRepository, engine.merchant_repository.class
    assert_equal ItemRepository, engine.item_repository.class
  end

  def test_it_loads_fixture_data
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    assert_equal 1, engine.customer_repository.find_by(:id, 1).id
    assert_equal 'Toy', engine.customer_repository.find_by(:id, 3).last_name
    assert_nil engine.customer_repository.find_by(:id, 21)
  end

  def test_it_loads_customer_records_properly
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    customer1_data = engine.db.execute("SELECT * FROM customers WHERE id = 1")

    assert_equal [[1, "Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]], customer1_data
  end

  def test_it_loads_invoice_records_properly
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    invoice1_data = engine.db.execute("SELECT * FROM invoices WHERE id = 1")

    assert_equal [[1, 1, 6, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]], invoice1_data
  end

  def test_it_loads_invoice_item_records_properly
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    invoice_item1_data = engine.db.execute("SELECT * FROM invoice_items WHERE id = 1")

    assert_equal [[1, 9, 1, 5, 22582, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]], invoice_item1_data
  end

  def test_it_loads_item_records_properly
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    item1_data = engine.db.execute("SELECT * FROM items WHERE id = 1")

    assert_equal [[1, "Item Qui Esse", "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.", 75107, 1, "2012-03-27 14:53:59", "2012-03-27 14:53:59"]], item1_data
  end

  def test_it_loads_merchant_records_properly
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    merchant1_data = engine.db.execute("SELECT * FROM merchants WHERE id = 1")

    assert_equal [[1, "Schroeder-Jerde", "2012-03-27 14:53:59", "2012-03-27 14:53:59"]], merchant1_data
  end

  def test_it_loads_transaction_records_properly
    engine = SalesEngine.new('./data_fixtures')
    engine.startup
    transaction1_data = engine.db.execute("SELECT * FROM transactions WHERE id = 1")

    assert_equal [[1, 1, "4654405418249632", nil, "success", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]], transaction1_data
  end
end
