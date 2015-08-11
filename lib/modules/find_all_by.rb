module FindAllBy

  def find_all_by_last_name(last_name)
    find_all_by(:last_name, last_name)
  end

  def find_all_by_item_id(item_id)
    find_all_by(:item_id, item_id)
  end

  def find_all_by_first_name(first_name)
    find_all_by(:first_name, first_name)
  end

  def find_all_by_name(name)
    find_all_by(:name, name)
  end

  def find_all_by_customer_id(customer_id)
    customer_id = customer_id.to_i
    find_all_by(:customer_id, customer_id)
  end

  def find_all_by_invoice_id(invoice_id)
    invoice_id = invoice_id.to_i
    find_all_by(:invoice_id, invoice_id)
  end

  def find_all_by_quantity(quantity)
    quantity = quantity.to_i
    find_all_by(:quantity, quantity)
  end

  def find_all_by_status(status)
    find_all_by(:status, status)
  end

  def find_all_by_result(result)
    find_all_by(:result, result)
  end

end
