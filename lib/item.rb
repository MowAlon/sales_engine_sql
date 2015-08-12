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
    Date.parse(ranked_revenue_by_date.first[0])
  end

  def ranked_revenue_by_date
    revenue_by_date.sort_by{|date, revenue| revenue}.reverse
  end

  def revenue_by_date
    dates = Hash.new(0)
    revenues_by_invoice_id.each do |invoice_id, revenue|
      invoice = repository.engine.invoice_repository.find_by(:id, invoice_id)
      if invoice.successful?
        date = repository.good_date(invoice.created_at)
        dates[date] += revenue.to_f
      end
    end
    dates
  end

  def revenues_by_invoice_id
    invoice_ids = Hash.new(0)
    invoice_items = repository.engine.invoice_item_repository.all

    invoice_items.each do |invoice_item|
      if id == invoice_item.item_id
        invoice_ids[invoice_item.invoice_id] += invoice_item.simple_revenue
      end
    end
    invoice_ids
  end

end
