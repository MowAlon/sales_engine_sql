class Customer
  attr_reader :id, :first_name, :last_name,
  :created_at, :updated_at, :repository, :fields

  def initialize(input_data, repository)
    @id = input_data[0]
    @first_name = input_data[1]
    @last_name = input_data[2]
    @created_at = input_data[3]
    @updated_at = input_data[4]
    @repository = repository
    @fields = [:id, :first_name, :last_name,
      :created_at, :updated_at]
  end

  def invoices
    repository.engine.invoice_repository.find_all_by_customer_id(id)
  end

  def transactions
    customer_transactions =  []
    invoices.each do |invoice|
      transaction_repository = repository.engine.transaction_repository
      transaction = transaction_repository.find_all_by_invoice_id(invoice.id)
      customer_transactions << transaction
    end
    customer_transactions.flatten
  end

  def favorite_merchant
    merchants = Hash.new(0)
    invoices.each do |invoice|
      if invoice.successful?
        merchant_repository = repository.engine.merchant_repository
        merchant = merchant_repository.find_by(:id, invoice.merchant_id)
        merchants[merchant] += 1
      end
    end
    return nil if merchants.empty?
    merchants.sort_by{|merchant, count| count}.reverse[0][0]
  end

end
