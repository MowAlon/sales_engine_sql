require_relative 'test_helper'

class ItemTest < MiniTest::Test

  def test__invoice_items__it_returns_an_array_of_invoice_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    item = engine.item_repository.find_by(:id, 1)

    assert_equal Array, item.invoice_items.class
    assert item.invoice_items.all?{|invoice_item| invoice_item.class == InvoiceItem}
  end

  def test__invoice_items__it_returns_the_correct_invoice_items
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    item = engine.item_repository.find_by(:id, 1)
    invoice_item_ids = item.invoice_items.map {|invoice_item| invoice_item.id}
    quantities = item.invoice_items.map {|invoice_item| invoice_item.quantity}

    assert_equal [6, 13, 18], invoice_item_ids
    assert_equal [5, 4, 5], quantities
  end

  def test__invoice_items__it_returns_an_empty_array_when_no_invoice_items_are_associated_with_item
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    item = engine.item_repository.find_by(:id, 20)

    assert_equal [], item.invoice_items
  end

  def test__merchant__it_can_pull_a_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    item = engine.item_repository.find_by(:id, 1)

    assert_equal Merchant, item.merchant.class
  end

  def test__merchant__it_pulls_the_correct_merchant
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    item = engine.item_repository.find_by(:id, 1)

    assert_equal 1, item.merchant.id
    assert_equal "Schroeder-Jerde", item.merchant.name
  end

  def test__best_day__it_finds_the_correct_date
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    item = engine.item_repository.find_by(:id, 9)

    assert_equal Date.parse('2012-03-25'), item.best_day
  end
end
