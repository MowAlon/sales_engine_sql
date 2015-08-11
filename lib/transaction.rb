class Transaction
  attr_reader :id, :invoice_id, :credit_card_number,
  :credit_card_expiration_date,
  :result, :created_at, :updated_at,
  :repository, :fields

  def initialize(input_data, repository)
    @id = input_data[0]
    @invoice_id = input_data[1]
    @credit_card_number = input_data[2]
    @credit_card_expiration_date = input_data[3]
    @result = input_data[4]
    @created_at = input_data[5]
    @updated_at = input_data[6]
    @repository = repository
    @fields = [:id, :invoice_id, :credit_card_number,
    :credit_card_expiration_date,
    :result, :created_at, :updated_at]
  end

  def invoice
    repository.engine.invoice_repository.find_by(:id, invoice_id)
  end

  def successful?
    result == "success"
  end

end
