require_relative 'repository'
require_relative 'item'

class ItemRepository < Repository
  attr_reader :engine, :table_name, :child_class

  def initialize(engine)
    @engine = engine
  	@table_name = 'items'
    @child_class = Item
  end

  def most_revenue(item_count)
    top_items(item_count, revenue_by_item)
  end

  def most_items(item_count)
    top_items(item_count, quantity_by_item)
  end

private

  def top_items(count, data_by_item)
    ranked_items(data_by_item)[0..count - 1].map{|item_id, data| find_by(:id, item_id)}
  end

  def ranked_items(data_by_item)
    data_by_item.sort_by{|item_id, data| data}.reverse
  end

  def revenue_by_item
    revenue_totals = Hash.new(0)
    revenue_components_by_item.each do |item_id, quantity, price|
      revenue_totals[item_id] += (quantity * price)
    end
    revenue_totals
  end

  def quantity_by_item
    quantity_totals = Hash.new(0)
    quantities_by_item.each do |item_id, quantity|
      quantity_totals[item_id] += quantity
    end
    quantity_totals
  end

  def revenue_components_by_item
    engine.invoice_item_repository.create_successful_invoice_items_view
    revenue_data = engine.db.execute("
    SELECT successful_invoice_items.item_id, successful_invoice_items.quantity, successful_invoice_items.unit_price
    FROM successful_invoice_items")
    engine.invoice_item_repository.drop_successful_invoice_items_view
    revenue_data
  end

  def quantities_by_item
    engine.invoice_item_repository.create_successful_invoice_items_view
    quantity_data = engine.db.execute("
    SELECT successful_invoice_items.item_id, successful_invoice_items.quantity
    FROM successful_invoice_items")
    engine.invoice_item_repository.drop_successful_invoice_items_view
    quantity_data
  end
end
