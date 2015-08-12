class InvoiceItem
  attr_reader :id, :item_id, :invoice_id, :quantity,
  :unit_price, :created_at, :updated_at,
  :repository

  def initialize(input_data, repository)
    @id = input_data[0]
    @item_id = input_data[1]
    @invoice_id = input_data[2]
    @quantity = input_data[3]
    @unit_price = BigDecimal.new(input_data[4])
    @created_at = input_data[5]
    @updated_at = input_data[6]
    @repository = repository
  end

  def invoice
    repository.engine.invoice_repository.find_by(:id, invoice_id)
  end

  def item
    repository.engine.item_repository.find_by(:id, item_id)
  end

  def revenue
    if successful? then BigDecimal.new(quantity) * unit_price else 0 end
  end

  def simple_revenue
    quantity * unit_price
  end

  def merchant
    repository.engine.item_repository.find_by(:id, item_id).merchant
  end

  def successful?
    invoice_repository = repository.engine.invoice_repository
    invoice = invoice_repository.find_by(:id, invoice_id)

    invoice && invoice.successful?
  end

end
