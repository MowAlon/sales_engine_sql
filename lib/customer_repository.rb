require_relative 'repository'
require_relative 'customer'

class CustomerRepository < Repository
  attr_reader :engine, :table_name, :child_class

  def initialize(engine)
    @engine = engine
  	@table_name = 'customers'
    @child_class = Customer
  end

end
