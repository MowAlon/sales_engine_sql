require_relative 'repository'
require_relative 'merchant'

class MerchantRepository < Repository
  attr_reader :engine, :table_name, :child_class

  def initialize(engine)
    @engine = engine
  	@table_name = 'merchants'
    @child_class = Merchant
  end

  def most_revenue(merchant_count)
    top_merchants(merchant_count, revenue_by_merchant)
  end

  def most_items(merchant_count)
    top_merchants(merchant_count, quantity_by_merchant)
  end

  def revenue(date)
    create_successful_invoice_items_view

    revenue_data_on_date = engine.db.execute("
    SELECT successful_invoice_items.quantity, successful_invoice_items.unit_price
    FROM successful_invoice_items JOIN invoices ON successful_invoice_items.invoice_id=invoices.id
    WHERE DATE(invoices.created_at)=DATE('#{date}')")
    drop_successful_invoice_items_view

    total = revenue_data_on_date.reduce(0){|sum,data| sum + (data[0] * data[1])}
    BigDecimal.new(total) * 0.01
  end

private

  def top_merchants(count, data_by_merchant)
    ranked_merchants(data_by_merchant)[0..count - 1].map{|merchant_id, data| find_by(:id, merchant_id)}
  end

  def ranked_merchants(data_by_merchant)
  	data_by_merchant.sort_by{|merchant_id, data| data}.reverse
  end

  def revenue_by_merchant
    revenue_totals = Hash.new(0)
    revenue_components_by_merchant.each do |merchant_id, quantity, price|
      revenue_totals[merchant_id] += (quantity * price)
    end
    revenue_totals
  end

  def quantity_by_merchant
    quantity_totals = Hash.new(0)
    quantities_by_merchant.each do |merchant_id, quantity|
      quantity_totals[merchant_id] += quantity
    end
    quantity_totals
  end

  def quantities_by_merchant
    create_successful_invoice_items_view
    quantity_data = engine.db.execute("
    SELECT invoices.merchant_id, successful_invoice_items.quantity
    FROM successful_invoice_items JOIN invoices ON successful_invoice_items.invoice_id=invoices.id")
    drop_successful_invoice_items_view
    quantity_data
  end

  def revenue_components_by_merchant
    create_successful_invoice_items_view
    revenue_data = engine.db.execute("
    SELECT invoices.merchant_id, successful_invoice_items.quantity, successful_invoice_items.unit_price
    FROM successful_invoice_items JOIN invoices ON successful_invoice_items.invoice_id=invoices.id")
    drop_successful_invoice_items_view
    revenue_data
  end

  def create_successful_invoice_items_view
    engine.db.execute("
    CREATE VIEW successful_invoice_items AS
    SELECT invoice_items.invoice_id, invoice_items.quantity, invoice_items.unit_price
    FROM invoice_items JOIN transactions ON transactions.invoice_id=invoice_items.invoice_id
    WHERE transactions.result='success'")
  end

  def drop_successful_invoice_items_view
    engine.db.execute("DROP VIEW successful_invoice_items")
  end

end
