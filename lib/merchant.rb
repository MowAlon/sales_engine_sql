class Merchant
  attr_reader :id, :name, :created_at, :updated_at, :repository

  def initialize(input_data, repository)
    @id = input_data[0]
    @name = input_data[1]
    @created_at = input_data[2]
    @updated_at = input_data[3]
    @repository = repository
  end

  def items
    repository.engine.item_repository.find_all_by(:merchant_id, id)
  end

  def invoices
    repository.engine.invoice_repository.find_all_by(:merchant_id, id)
  end

  def revenue(date = false)
    repository.engine.invoice_item_repository.create_successful_invoice_items_view

    revenue_data = if date
      repository.engine.db.execute("
        SELECT successful_invoice_items.quantity, successful_invoice_items.unit_price
        FROM successful_invoice_items JOIN invoices ON successful_invoice_items.invoice_id=invoices.id
        WHERE DATE(invoices.created_at)=DATE('#{date}') AND invoices.merchant_id=#{id}")
    else
      repository.engine.db.execute("
        SELECT successful_invoice_items.quantity, successful_invoice_items.unit_price
        FROM successful_invoice_items JOIN invoices ON successful_invoice_items.invoice_id=invoices.id
        WHERE invoices.merchant_id=#{id}")
    end
    repository.engine.invoice_item_repository.drop_successful_invoice_items_view

    total = revenue_data.reduce(0){|sum,data| sum + (data[0] * data[1])}
    BigDecimal.new(total) * 0.01
  end

  def favorite_customer
    records = repository.engine.db.execute("
      SELECT invoices.customer_id
      FROM invoices JOIN transactions
      ON transactions.invoice_id=invoices.id
      WHERE transactions.result='success' AND invoices.merchant_id = #{id}")
    records = records.flatten.group_by{|customer_id| customer_id}
    records = records.sort_by{|customer_id, appearances| appearances.size}
    favorite_customer_id = records.reverse[0][0]
    repository.engine.customer_repository.find_by(:id, favorite_customer_id)
  end

  def customers_with_pending_invoices
    repository.engine.invoice_repository.create_failed_invoices_view
    customer_ids = repository.engine.db.execute("
      SELECT failed_invoices.customer_id
      FROM failed_invoices
      WHERE failed_invoices.merchant_id=#{id}")
    repository.engine.invoice_repository.drop_failed_invoices_view

    customer_ids.flatten.uniq.map{|customer_id| repository.engine.customer_repository.find_by(:id, customer_id)}
  end
end
