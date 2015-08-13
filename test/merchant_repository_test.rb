require_relative 'test_helper'

class MerchantRepositoryTest < MiniTest::Test

  def test_it_finds_the_merchants_with_the_most_revenue
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    best_merchant_id = engine.merchant_repository.most_revenue(1)[0].id

    assert_equal 6, best_merchant_id
  end

  def test_it_returns_all_the_merchants_requested_through_most_revenue
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    best_merchants1 = engine.merchant_repository.most_revenue(1)
    best_merchants2 = engine.merchant_repository.most_revenue(2)

    assert_equal 1, best_merchants1.size
    assert_equal 2, best_merchants2.size
  end

  def test_it_finds_the_merchants_with_the_most_units_sold
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    best_merchant_id = engine.merchant_repository.most_items(1)[0].id

    assert_equal 6, best_merchant_id
  end

  def test_it_returns_all_the_merchants_requested_through_most_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    best_merchants1 = engine.merchant_repository.most_items(1)
    best_merchants2 = engine.merchant_repository.most_items(2)

    assert_equal 1, best_merchants1.size
    assert_equal 2, best_merchants2.size
  end

  def test_calculates_total_revenue_on_a_given_date
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    date1 = Date.parse('2012-03-25')
    date2 = Date.parse('2012-03-12')

    assert_equal (BigDecimal.new(1582109) * 0.01), engine.merchant_repository.revenue(date1)
    assert_equal (BigDecimal.new(1156058) * 0.01), engine.merchant_repository.revenue(date2)
  end
end
