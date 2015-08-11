class Invoice
  attr_reader :id, :customer_id, :merchant_id,
              :status, :created_at, :updated_at,
              :repository, :fields

  def initialize(input_data, repository)
    @id = input_data[0]
    @customer_id = input_data[1]
    @merchant_id = input_data[2]
    @status = input_data[3]
    @created_at = input_data[4]
    @updated_at = input_data[5]
    @repository = repository
    @fields = [:id, :customer_id, :merchant_id,
                :status, :created_at, :updated_at]
  end

  def transactions
    repository.engine.transaction_repository.find_all_by(:invoice_id, id)
  end

  def invoice_items
    repository.engine.invoice_item_repository.find_all_by(:invoice_id, id)
  end

  def items

    invoice_items.each {|ii| puts ii.class}

    invoice_items.map do |invoice_item|
      repository.engine.item_repository.find_by(:id, invoice_item.item_id)
    end.uniq {|item| item.id}
  end

  def customer
    repository.engine.customer_repository.find_by(:id, customer_id)
  end

  def merchant
    repository.engine.merchant_repository.find_by(:id, merchant_id)
  end

  def revenue
    invoice_item_repository = repository.engine.invoice_item_repository
    invoice_items = invoice_item_repository.find_all_by(:invoice_id, id)
    # start_num = BigDecimal.new(0)
    total = invoice_items.reduce(0) do |sum, invoice_item|
      sum + invoice_item.revenue
    end
  end

  def successful?
    records = repository.engine.db.execute "SELECT * FROM transactions WHERE invoice_id = #{id} AND result = 'success'"
    records.size > 0
  end

  def charge(info)
    repository.engine.transaction_repository.add_transaction(id, info)
  end

end
