require_relative 'test_helper'

class InvoiceRepositoryTest < MiniTest::Test

  def test_it_can_create_a_new_invoice
    engine = SalesEngine.new('./data_fixtures')
    engine.startup

    previous_invoice_count = engine.invoice_repository.all.count
    customer = engine.customer_repository.find_by(:id, 1)
    merchant = engine.merchant_repository.find_by(:id, 1)
    item1 = engine.item_repository.find_by(:id, 1)
    item2 = engine.item_repository.find_by(:id, 2)
    new_invoice_id = engine.invoice_repository.all.last.id.next
    new_invoice = engine.invoice_repository.create(customer: customer, merchant: merchant, items: [item1, item2])

    assert_equal previous_invoice_count.next, engine.invoice_repository.all.count
    assert_equal customer.id, new_invoice.customer_id
    assert_equal merchant.id, new_invoice.merchant_id
  end
end
