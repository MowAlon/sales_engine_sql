require_relative 'repository'
require_relative 'invoice_item'

class InvoiceItemRepository < Repository
  attr_reader :engine, :table_name, :child_class

  def initialize(engine)
    @engine = engine
  	@table_name = 'invoice_items'
    @child_class = InvoiceItem
  end

  def add_invoice_items(items, invoice_id)
    items_by_id = items.group_by {|item| item.id}
    item_counts = items_by_id.map{|id, items| [id, items.count]}

    item_counts.each do |item_id, quantity|
      unit_price = engine.item_repository.find_by(:id, item_id).unit_price.to_i
      created_at = Time.now.utc.to_s[0..18]
      updated_at = created_at

      engine.db.execute "
      INSERT INTO invoice_items(item_id,invoice_id,quantity,unit_price,
        created_at,updated_at)
        VALUES (?,?,?,?,?,?);",
        [item_id,invoice_id,quantity,unit_price,created_at,updated_at]
    end
  end

  def create_successful_invoice_items_view
    engine.db.execute("
    CREATE VIEW successful_invoice_items AS
    SELECT invoice_items.invoice_id, invoice_items.item_id, invoice_items.quantity, invoice_items.unit_price
    FROM invoice_items JOIN transactions ON transactions.invoice_id=invoice_items.invoice_id
    WHERE transactions.result='success'")
  end

  def drop_successful_invoice_items_view
    engine.db.execute("DROP VIEW successful_invoice_items")
  end

end
