require_relative 'test_helper'

class MerchantTest < MiniTest::Test

  def test__items__it_returns_an_array_of_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant = engine.merchant_repository.find_by(:id, 1)

    assert_equal Array, merchant.items.class
    assert merchant.items.all?{|item| item.class == Item}
  end

  def test__items__it_returns_the_correct_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant = engine.merchant_repository.find_by(:id, 1)
    item_ids = merchant.items.map {|item| item.id}

    assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], item_ids
  end

  def test__items__it_returns_an_empty_array_when_no_items_are_associated_with_the_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant = engine.merchant_repository.find_by(:id, 20)

    assert_equal [], merchant.items
  end

  def test__invoices__it_returns_an_array_of_invoices
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant = engine.merchant_repository.find_by(:id, 1)

    assert_equal Array, merchant.invoices.class
    assert merchant.invoices.all?{|invoice| invoice.class == Invoice}
  end

  def test__invoices__it_returns_the_correct_invoices
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant = engine.merchant_repository.find_by(:id, 1)
    invoice_ids = merchant.invoices.map {|invoice| invoice.id}
    customer_ids = merchant.invoices.map {|invoice| invoice.customer_id}

    assert_equal [5], invoice_ids
    assert_equal [1], customer_ids
  end

  def test__invoices__it_returns_an_empty_array_when_no_invoices_are_associated_with_the_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant = engine.merchant_repository.find_by(:id, 20)

    assert_equal [], merchant.invoices
  end

  def test__revenue__it_returns_total_revenue_when_no_date_is_given
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant = engine.merchant_repository.find_by(:id, 6)

    assert_equal (BigDecimal.new(1891304) * 0.01), merchant.revenue
  end

  def test__revenue__it_returns_total_revenue_when_a_date_is_given
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant = engine.merchant_repository.find_by(:id, 6)

    assert_equal (BigDecimal.new(1582109) * 0.01), merchant.revenue(Date.parse('2012-03-25'))
  end

  def test_it_returns_the_favorite_customer
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant1 = engine.merchant_repository.find_by(:id, 6)
    merchant2 = engine.merchant_repository.find_by(:id, 4)

    assert_equal 1, merchant1.favorite_customer.id
    assert_equal 4, merchant2.favorite_customer.id
  end

  def test_it_finds_customers_with_pending_invoices
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    merchant1 = engine.merchant_repository.find_by(:id, 4)
    merchant1_ids = merchant1.customers_with_pending_invoices.map{|customer| customer.id}
    merchant2 = engine.merchant_repository.find_by(:id, 8)
    merchant2_ids = merchant2.customers_with_pending_invoices.map{|customer| customer.id}

    assert_equal [3, 4], merchant1_ids
    assert_equal [1], merchant2_ids
  end
end
