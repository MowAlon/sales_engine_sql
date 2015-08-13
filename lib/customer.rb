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
    invoices = invoices_by_merchant
    return nil if invoices.empty?
    merchant_id = invoices.sort_by{|merchant_id, data| data.size}.reverse[0][0]
    repository.engine.merchant_repository.find_by(:id, merchant_id)
  end

private

  def transaction_ids
    repository.engine.db.execute("
    SELECT transactions.id
    FROM transactions JOIN invoices ON transactions.invoice_id=invoices.id
    WHERE invoices.customer_id=#{id}").flatten
  end

  def invoices_by_merchant
    merchants_and_invoices = repository.engine.db.execute("
    SELECT invoices.id, invoices.merchant_id
    FROM invoices JOIN transactions on invoices.id=transactions.invoice_id
    WHERE transactions.result='success' and invoices.customer_id='#{id}'")

    merchants_and_invoices.group_by{|invoice_id, merchant_id| merchant_id}
  end
end
