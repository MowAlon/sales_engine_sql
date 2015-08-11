require 'csv'

class FileIO

  attr_reader :file_name

  def initialize(file_name)
    @filename = file_name
  end

  def input_data
    CSV.read("#{@filename}")
  end

end
