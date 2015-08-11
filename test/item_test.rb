require_relative 'test_helper'

class ItemTest < MiniTest::Test

  @@engine = SalesEngine.new
    @@engine.startup

    def engine
      @@engine
    end

    def test_invoice_items__it_returns_an_array_of_invoice_items
      item = engine.item_repository.find_by(:id, 127)

      assert_equal Array, item.invoice_items.class
      assert item.invoice_items.all?{|invoice_item| invoice_item.class == InvoiceItem}
    end


    def test_invoice_items__it_returns_the_correct_invoice_items
      item = engine.item_repository.find_by(:id, 127)
      invoice_item_ids = item.invoice_items.map {|invoice_item| invoice_item.id}
      quantities = item.invoice_items.map {|invoice_item| invoice_item.quantity}

      assert_equal [57, 60], invoice_item_ids[0..1]
      assert_equal [2, 3], quantities[0..1]
    end

    def test_invoice_items__it_returns_an_empty_array_when_no_invoice_items_are_associated_with_item
      input_data = [198273049,'dgsdfg','ofijalekrsa',94829834,98132135,'09834','24234']
      item = Item.new(input_data, engine.item_repository)

      assert_equal [], item.invoice_items
    end
    def test_merchant__it_can_pull_a_merchant
      item = engine.item_repository.find_by(:id, 127)

      assert_equal Merchant, item.merchant.class
    end

    def test_merchant__it_pulls_the_correct_merchant
      item = engine.item_repository.find_by(:id, 127)

      assert_equal 8, item.merchant.id
      assert_equal "Osinski, Pollich and Koelpin", item.merchant.name
    end
end
