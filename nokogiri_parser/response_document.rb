require "nokogiri"

class ResponseDocument < Nokogiri::XML::SAX::Document

  def initialize(data, &emit_block)
    @data = data
    @emit_block = emit_block
    @header_mappings = {}
    @current_row = {}
  end

  def start_element(name, attributes = [])

    if name == "row"
      @current_row = {}
    end

    if data.include? name.to_s
      @current_value = ""
    end
  end

  def end_element(name)

    if name.to_s == "row"
      @emit_block.call(@current_row)
      @current_row = nil
    end

    if data.include? name.to_s
      @current_row[name.to_sym] = @current_value
      @current_value = nil
    end
  end

  def characters(chars)
    @current_value << chars if @current_value
  end

  #private

  attr_reader :emit_block, :data
  attr_accessor :current_row, :current_column_name, :current_value
end