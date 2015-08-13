class Item
  attr_reader :id, :name, :description, :unit_price, :merchant_id, :created_at,
              :updated_at, :repository

  def initialize(input_data, repository)
    @id = input_data[0]
    @name = input_data[1]
    @description = input_data[2]
    @unit_price = BigDecimal.new(input_data[3])
    @merchant_id = input_data[4]
    @created_at = input_data[5]
    @updated_at = input_data[6]
    @repository = repository
  end

  def invoice_items
    repository.engine.invoice_item_repository.find_all_by(:item_id, id)
  end

  def merchant
    repository.engine.merchant_repository.find_by(:id, merchant_id)
  end

  def best_day
    Date.parse(ranked_quantities.first[0])
  end

private

  def ranked_quantities
  	quantity_by_date.sort_by{|date, quantity| quantity}.reverse
  end

  def quantity_by_date
  	quantity_totals = Hash.new(0)
    quantities_by_date.each do |date, quantity|
      quantity_totals[date] += quantity
    end
    quantity_totals
  end

  def quantities_by_date
    repository.engine.invoice_item_repository.create_successful_invoice_items_view
    quantity_data = repository.engine.db.execute("
      SELECT DATE(invoices.created_at), successful_invoice_items.quantity
      FROM successful_invoice_items JOIN invoices ON invoices.id=successful_invoice_items.invoice_id
      WHERE successful_invoice_items.item_id=#{id}")
    repository.engine.invoice_item_repository.drop_successful_invoice_items_view

    quantity_data
  end
end
