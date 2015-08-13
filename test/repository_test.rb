require_relative 'test_helper'

class RepositoryTest < MiniTest::Test

  def test_it_returns_all_instances
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Cecelia", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Mariah", "Toy", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]

    assert_equal Customer, engine.customer_repository.all.sample.class
    assert_equal 3, engine.customer_repository.all.size
  end

  def test_it_returns_an_empty_array_when_all_looks_for_data_in_an_empty_table
    engine = SalesEngine.new('./data_fixtures')

    assert_equal [], engine.customer_repository.all
  end

  def test_it_returns_a_random_instance
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Cecelia", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Mariah", "Toy", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]

    random_item1 = engine.customer_repository.random
    random_item2 = engine.customer_repository.random
    random_item3 = engine.customer_repository.random

    assert_equal Customer, random_item1.class
    assert_equal Customer, random_item2.class
    assert_equal Customer, random_item3.class
    refute [random_item1, random_item2, random_item3].all?{|item| (item == random_item1)}
    refute [random_item1, random_item2, random_item3].all?{|item| (item == random_item2)}
    refute [random_item1, random_item2, random_item3].all?{|item| (item == random_item3)}
  end

  def test_it_returns_nil_when_nothing_is_found_by_find_by
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Cecelia", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]

    assert_nil engine.customer_repository.find_by(:id, 3)
  end

  def test_it_returns_an_empty_array_when_nothing_is_found_by_find_all_by
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Cecelia", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]

    assert_equal [], engine.customer_repository.find_all_by(:id, 3)
  end

  def test_it_can_find_by_id
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Cecelia", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]

    assert_equal 1, engine.customer_repository.find_by(:id, 1).id
    assert_equal "Joey", engine.customer_repository.find_by(:id, 1).first_name
    assert_equal 2, engine.customer_repository.find_by_id(2).id
    assert_equal "Cecelia", engine.customer_repository.find_by_id(2).first_name
  end

  def test_it_can_find_by_first_name
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Cecelia", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]

    assert_equal 1, engine.customer_repository.find_by(:first_name, "Joey").id
    assert_equal "Joey", engine.customer_repository.find_by(:first_name, "Joey").first_name
    assert_equal 2, engine.customer_repository.find_by_first_name("Cecelia").id
    assert_equal "Cecelia", engine.customer_repository.find_by_first_name("Cecelia").first_name
  end

  def test_it_can_find_by_last_name
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Cecelia", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]

    assert_equal 1, engine.customer_repository.find_by(:last_name, "Ondricka").id
    assert_equal "Joey", engine.customer_repository.find_by(:last_name, "Ondricka").first_name
    assert_equal 2, engine.customer_repository.find_by_last_name("Osinski").id
    assert_equal "Cecelia", engine.customer_repository.find_by_last_name("Osinski").first_name
  end

  def test_it_can_find_by_customer_id
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [3, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [4, 75, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]

    assert_equal 1, engine.invoice_repository.find_by(:customer_id, 3).id
    assert_equal 26, engine.invoice_repository.find_by(:customer_id, 3).merchant_id
    assert_equal 2, engine.invoice_repository.find_by_customer_id(4).id
    assert_equal 75, engine.invoice_repository.find_by_customer_id(4).merchant_id
  end

  def test_it_can_find_by_merchant_id
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [3, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [4, 75, "shipped", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]

    assert_equal 1, engine.invoice_repository.find_by(:merchant_id, 26).id
    assert_equal 26, engine.invoice_repository.find_by(:merchant_id, 26).merchant_id
    assert_equal 2, engine.invoice_repository.find_by(:merchant_id, 75).id
    assert_equal 75, engine.invoice_repository.find_by(:merchant_id, 75).merchant_id
  end

  def test_it_can_find_by_status
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [3, 26, "shipped", "2012-03-25 09:54:09", "2012-03-25 09:54:09"]
    engine.db.execute "INSERT INTO invoices(customer_id, merchant_id, status, created_at, updated_at) VALUES (?,?,?,?,?);",
      [4, 75, "pending", "2012-03-12 05:54:09", "2012-03-12 05:54:09"]

    assert_equal 1, engine.invoice_repository.find_by(:status, "shipped").id
    assert_equal 26, engine.invoice_repository.find_by(:status, "shipped").merchant_id
    assert_equal 2, engine.invoice_repository.find_by_status("pending").id
    assert_equal 75, engine.invoice_repository.find_by_status("pending").merchant_id
  end

  def test_it_can_find_by_item_id
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO invoice_items(item_id, invoice_id, quantity, unit_price, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [539, 3, 5, 13635, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO invoice_items(item_id, invoice_id, quantity, unit_price, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [528, 4, 9, 23324, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    assert_equal 1, engine.invoice_item_repository.find_by(:item_id, 539).id
    assert_equal 539, engine.invoice_item_repository.find_by(:item_id, 539).item_id
    assert_equal 2, engine.invoice_item_repository.find_by_item_id(528).id
    assert_equal 528, engine.invoice_item_repository.find_by_item_id(528).item_id
  end

  def test_it_can_find_by_invoice_id
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO invoice_items(item_id, invoice_id, quantity, unit_price, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [539, 3, 5, 13635, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO invoice_items(item_id, invoice_id, quantity, unit_price, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [528, 4, 9, 23324, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    assert_equal 1, engine.invoice_item_repository.find_by(:invoice_id, 3).id
    assert_equal 539, engine.invoice_item_repository.find_by(:invoice_id, 3).item_id
    assert_equal 2, engine.invoice_item_repository.find_by(:invoice_id, 4).id
    assert_equal 528, engine.invoice_item_repository.find_by(:invoice_id, 4).item_id
  end

  def test_it_can_find_by_quantity
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO invoice_items(item_id, invoice_id, quantity, unit_price, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [539, 3, 5, 13635, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO invoice_items(item_id, invoice_id, quantity, unit_price, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [528, 4, 9, 23324, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    assert_equal 1, engine.invoice_item_repository.find_by(:quantity, 5).id
    assert_equal 539, engine.invoice_item_repository.find_by(:quantity, 5).item_id
    assert_equal 2, engine.invoice_item_repository.find_by(:quantity, 9).id
    assert_equal 528, engine.invoice_item_repository.find_by(:quantity, 9).item_id
  end

  def test_it_can_find_by_unit_price
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO invoice_items(item_id, invoice_id, quantity, unit_price, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [539, 3, 5, 13635, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO invoice_items(item_id, invoice_id, quantity, unit_price, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [528, 4, 9, 23324, "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    assert_equal 1, engine.invoice_item_repository.find_by_unit_price(BigDecimal.new("136.35")).id
    assert_equal 539, engine.invoice_item_repository.find_by_unit_price(BigDecimal.new("136.35")).item_id
    assert_equal 2, engine.invoice_item_repository.find_by_unit_price(BigDecimal.new("233.24")).id
    assert_equal 528, engine.invoice_item_repository.find_by_unit_price(BigDecimal.new("233.24")).item_id
  end

  def test_it_can_find_by_description
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO items(name, description, unit_price, merchant_id, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      ["Item Qui Esse", "Nihil autem.", 75107, 1, "2012-03-27 14:53:59", "2012-03-27 14:53:59"]
    engine.db.execute "INSERT INTO items(name, description, unit_price, merchant_id, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      ["Item Autem Minima", "Cumque consequuntur.", 67076, 1, "2012-03-27 14:53:59", "2012-03-27 14:53:59"]

    assert_equal 1, engine.item_repository.find_by(:description, "Nihil autem.").id
    assert_equal "Item Qui Esse", engine.item_repository.find_by(:description, "Nihil autem.").name
    assert_equal 2, engine.item_repository.find_by(:description, "Cumque consequuntur.").id
    assert_equal "Item Autem Minima", engine.item_repository.find_by(:description, "Cumque consequuntur.").name
  end

  def test_it_can_find_by_name
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO merchants(name, created_at, updated_at) VALUES (?,?,?);",
      ["Schroeder-Jerde", "2012-03-27 14:53:59", "2012-03-27 14:53:59"]
    engine.db.execute "INSERT INTO merchants(name, created_at, updated_at) VALUES (?,?,?);",
      ["Klein, Rempel and Jones", "2012-03-27 14:53:59", "2012-03-27 14:53:59"]

    assert_equal 1, engine.merchant_repository.find_by(:name,"Schroeder-Jerde").id
    assert_equal "Schroeder-Jerde", engine.merchant_repository.find_by(:name,"Schroeder-Jerde").name
    assert_equal 2, engine.merchant_repository.find_by_name("Klein, Rempel and Jones").id
    assert_equal "Klein, Rempel and Jones", engine.merchant_repository.find_by_name("Klein, Rempel and Jones").name
  end

  def test_it_can_find_by_credit_card_number
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [3, "4654405418249632", nil, "success", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [4, "4580251236515201", nil, "success", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    assert_equal 1, engine.transaction_repository.find_by(:credit_card_number, "4654405418249632").id
    assert_equal 3, engine.transaction_repository.find_by(:credit_card_number, "4654405418249632").invoice_id
    assert_equal 2, engine.transaction_repository.find_by_credit_card_number("4580251236515201").id
    assert_equal 4, engine.transaction_repository.find_by_credit_card_number("4580251236515201").invoice_id
  end

  def test_it_can_find_by_result
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [3, "4654405418249632", nil, "success", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO transactions(invoice_id, credit_card_number, credit_card_expiration_date, result, created_at, updated_at) VALUES (?,?,?,?,?,?);",
      [4, "4580251236515201", nil, "failed", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]

    assert_equal 1, engine.transaction_repository.find_by(:result, "success").id
    assert_equal 3, engine.transaction_repository.find_by(:result, "success").invoice_id
    assert_equal 2, engine.transaction_repository.find_by(:result, "failed").id
    assert_equal 4, engine.transaction_repository.find_by(:result, "failed").invoice_id
  end

  def test_it_finds_all_by_various_parameters
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    assert_equal Customer, engine.customer_repository.find_all_by(:first_name, "Joey").sample.class
    assert_equal Customer, engine.customer_repository.find_all_by_first_name("Joey").sample.class
    assert_equal Customer, engine.customer_repository.find_all_by_last_name("Ondricka").sample.class
    assert_equal InvoiceItem, engine.invoice_item_repository.find_all_by_item_id(1).sample.class
    assert_equal Merchant, engine.merchant_repository.find_all_by_name("Schroeder-Jerde").sample.class
    assert_equal Invoice, engine.invoice_repository.find_all_by_customer_id(1).sample.class
    assert_equal Transaction, engine.transaction_repository.find_all_by_invoice_id(1).sample.class
    assert_equal InvoiceItem, engine.invoice_item_repository.find_all_by_quantity(9).sample.class
    assert_equal Invoice, engine.invoice_repository.find_all_by_status("shipped").sample.class
    assert_equal Transaction, engine.transaction_repository.find_all_by_result("success").sample.class
  end

  def test_it_finds_all_by_date
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Mariah", "Toy", "2012-03-28 14:54:10", "2012-03-28 14:54:10"]

      assert_equal Customer, engine.customer_repository.find_all_by(:created_at, "2012-03-27").sample.class
      assert_equal 2, engine.customer_repository.find_all_by(:created_at, "2012-03-27").size
  end

  def test_it_returns_an_empty_array_when_nothing_is_found_by_finds_all_by_date
    engine = SalesEngine.new('./data_fixtures')
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Ondricka", "2012-03-27 14:54:09", "2012-03-27 14:54:09"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Joey", "Osinski", "2012-03-27 14:54:10", "2012-03-27 14:54:10"]
    engine.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);",
      ["Mariah", "Toy", "2012-03-28 14:54:10", "2012-03-28 14:54:10"]

    assert_equal [], engine.customer_repository.find_all_by(:created_at, "2012-03-26")
  end
end
