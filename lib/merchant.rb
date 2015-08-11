class Merchant
  attr_reader :id, :name, :created_at, :updated_at, :repository, :fields

  def initialize(input_data, repository)
    @id = input_data[0]
    @name = input_data[1]
    @created_at = input_data[2]
    @updated_at = input_data[3]
    @repository = repository
    @fields = [:id, :name,
                :created_at, :updated_at]
  end

  def items
    repository.engine.item_repository.find_all_by(:merchant_id, id)
  end

  def invoices
    repository.engine.invoice_repository.find_all_by(:merchant_id, id)
  end

  def revenue(date = false)
    set_of_invoices = if date
      date = Date.parse(date) if date.class != Date
      date = date.strftime("%Y-%m-%d")
      invoices.select{|invoice| invoice.created_at[0..9] == date}
    else
      invoices
    end

    total = set_of_invoices.reduce(0) do |sum, invoice|
      sum + invoice.revenue
    end
    total * 0.01
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
    customers = []
    invoices.each do |invoice|
      if !invoice.successful?
        customer_repository = repository.engine.customer_repository
        customers << customer_repository.find_by(:id, invoice.customer_id)
      end
    end
    customers
  end

  # def inspect
  #   self.class.to_s
  # end

end
