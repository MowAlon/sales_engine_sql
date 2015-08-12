require_relative 'repository'
require_relative 'transaction'

class TransactionRepository < Repository
  attr_reader :engine, :table_name, :child_class

  def initialize(engine)
    @engine = engine
  	@table_name = 'transactions'
    @child_class = Transaction
  end

  def add_transaction(invoice_id, info)
    credit_card_number = info[:credit_card_number]
    credit_card_expiration_date = info[:credit_card_expiration]
    result = info[:result]
    created_at = Time.now.utc.to_s[0..18]
    updated_at = created_at

    engine.db.execute "INSERT INTO transactions(invoice_id,credit_card_number,credit_card_expiration_date,result,created_at,updated_at)
                       VALUES (?,?,?,?,?,?);", [invoice_id,credit_card_number,credit_card_expiration_date,result,created_at,updated_at]
  end

  # def create_transactions_with_customers_view
  #   engine.db.execute("
  #   CREATE VIEW transactions_with_customers AS
  #   SELECT transactions.id, invoices.customer_id
  #   FROM transactions JOIN invoices ON transactions.invoice_id=invoices.id")
  # end
  #
  # def drop_transactions_with_customers_view
  #   engine.db.execute("DROP VIEW transactions_with_customers")
  # end

end
