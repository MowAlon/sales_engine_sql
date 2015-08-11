require_relative 'repository'
require_relative 'invoice_item'

class InvoiceItemRepository < Repository
  attr_reader :engine, :table_name, :child_class

  def initialize(engine)
    @engine = engine
  	@table_name = 'invoice_items'
    @child_class = InvoiceItem
  end

  def item_data_by_invoice(method_name)
    output_hash = {}

    engine.invoice_item_repository.all.each do |invoice_item|
      invoice_id = invoice_item.invoice_id
      item_id = invoice_item.item_id
      data = invoice_item.send(method_name)
      output_hash[invoice_id] ||= {}

      if output_hash[invoice_id][item_id].nil?
        output_hash[invoice_id][item_id] = data
      else
        output_hash[invoice_id][item_id] += data
      end

    end
    output_hash
  end

  def items_values(data_by_invoice)
    output = Hash.new(0)
    data_by_invoice.each do |invoice_id, items_with_values|
      invoice = engine.invoice_repository.find_by_id(invoice_id)
      if invoice.successful?
        items_with_values.each {|item_id, value| output[item_id] += value}
      end
    end
    output
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

end
