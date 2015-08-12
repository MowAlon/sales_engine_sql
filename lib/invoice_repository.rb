require_relative 'repository'
require_relative 'invoice'

class InvoiceRepository < Repository
  attr_reader :engine, :table_name, :child_class

  def initialize(engine)
    @engine = engine
  	@table_name = 'invoices'
    @child_class = Invoice
  end

  def create(invoice_info)
    customer_id = invoice_info[:customer].id
    merchant_id = invoice_info[:merchant].id
    status = invoice_info[:status]
    created_at = Time.now.utc.to_s[0..18]
    updated_at = created_at
    new_id = all.last.id + 1

    engine.db.execute "INSERT INTO invoices(customer_id,merchant_id,status,created_at,updated_at)
                       VALUES (?,?,?,?,?);", [customer_id,merchant_id,status,created_at,updated_at]

    items = invoice_info[:items]
    engine.invoice_item_repository.add_invoice_items(items, new_id)

    find_by(:id, new_id)
  end

end
