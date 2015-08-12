require_relative 'test_helper'

class RepositoryTest < MiniTest::Test

  # def test_it_initializes_customer_repository_with_data
  #   engine = SalesEngine.new
  #   repository = CustomerRepository.new(engine)
  #
  #   assert_equal Customer, repository.table[1].class
  # end
  #
  # def test_it_initializes_transaction_repository_with_data
  #   engine = SalesEngine.new
  #   repository = TransactionRepository.new(engine)
  #
  #   assert_equal Transaction, repository.table[1].class
  # end
  #
  # def test_it_initializes_invoices_repository_with_data
  #   engine = SalesEngine.new
  #   repository = InvoiceRepository.new(engine)
  #
  #   assert_equal Invoice, repository.table[1].class
  # end
  #
  # def test_it_initializes_invoice_item_repository_with_data
  #   engine = SalesEngine.new
  #   repository = InvoiceItemRepository.new(engine)
  #
  #   assert_equal InvoiceItem, repository.table[1].class
  # end
  #
  # def test_it_initializes_merchant_repository_with_data
  #   engine = SalesEngine.new
  #   repository = MerchantRepository.new(engine)
  #
  #   assert_equal Merchant, repository.table[1].class
  # end
  #
  # def test_it_initializes_items_repository_with_data
  #   engine = SalesEngine.new
  #   repository = ItemRepository.new(engine)
  #
  #   assert_equal Item, repository.table[1].class
  # end

  def test_it_returns_a_random_entry
    engine = SalesEngine.new
    engine.startup
    repository = ItemRepository.new(engine)

    assert_equal Item, repository.random.class
  end

  def test_it_can_find_by_id_with_FIND_BY
    engine = SalesEngine.new
    engine.startup

    assert_equal BigDecimal.new(1859), engine.invoice_item_repository.find_by(:id,10).unit_price
  end

  def test_it_can_find_by_first_name
    engine = SalesEngine.new
    engine.startup

    assert_equal 'Kris', engine.customer_repository.find_by(:first_name,'Logan').last_name
  end

  def test_it_can_find_by_name
    engine = SalesEngine.new
    engine.startup

    assert_equal 12, engine.merchant_repository.find_by(:name,'Kozey Group').id
  end

  def test_it_can_find_by_unit_price
    engine = SalesEngine.new
    engine.startup

    assert_equal 4, engine.item_repository.find_by(:unit_price,BigDecimal.new(4291)).id
  end

  def test_it_can_find_by_invoice_id
    engine = SalesEngine.new
    engine.startup

    assert_equal 13, engine.invoice_item_repository.find_by(:invoice_id,3).id
  end

  def test_it_can_find_by_credit_card_number
    engine = SalesEngine.new
    engine.startup

    assert_equal 1, engine.transaction_repository.find_by(:credit_card_number,'4654405418249632').id
  end

  def test_it_finds_all_by_a_parameter
    engine = SalesEngine.new
    engine.startup

    assert_equal 15, engine.item_repository.find_all_by(:merchant_id,1).size
  end

end
