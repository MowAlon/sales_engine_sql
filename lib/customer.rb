class Customer
  attr_reader :id, :first_name, :last_name,
  :created_at, :updated_at, :repository

  def initialize(input_data, repository)
    @id = input_data[0]
    @first_name = input_data[1]
    @last_name = input_data[2]
    @created_at = input_data[3]
    @updated_at = input_data[4]
    @repository = repository
  end

  def invoices
    repository.engine.invoice_repository.find_all_by(:customer_id,id)
  end

  def transactions
    transaction_ids.map do |transaction_id|
      repository.engine.transaction_repository.find_by(:id, transaction_id)
    end
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

private

  def transaction_ids
    repository.engine.db.execute("
    SELECT transactions.id
    FROM transactions JOIN invoices ON transactions.invoice_id=invoices.id
    WHERE invoices.customer_id=#{id}").flatten
  end
end
