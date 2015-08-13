require_relative 'test_helper'

class ItemRepositoryTest < MiniTest::Test

  def test_it_finds_the_items_with_the_most_revenue
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    best_item_id = engine.item_repository.most_revenue(1)[0].id

    assert_equal 5, best_item_id
  end

  def test_it_returns_all_the_items_requested_through_most_revenue
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    best_items1 = engine.item_repository.most_revenue(3)
    best_items2 = engine.item_repository.most_revenue(5)

    assert_equal 3, best_items1.size
    assert_equal 5, best_items2.size
  end

  def test_it_finds_the_items_with_the_most_units_sold
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    best_item_id = engine.item_repository.most_items(1)[0].id

    assert_equal 8, best_item_id
  end

  def test_it_returns_all_the_items_requested_through_most_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    best_items1 = engine.item_repository.most_items(2)
    best_items2 = engine.item_repository.most_items(4)

    assert_equal 2, best_items1.size
    assert_equal 4, best_items2.size
  end
end
