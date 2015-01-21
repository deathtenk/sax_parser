require 'libxml'
require 'pry'
include LibXML

class Document
  include XML::SaxParser::Callbacks
  def initialize(data = [])
    @data = data
    @hash = {}
  end

  def on_start_element(element, attributes)
    if element.to_s == "liverailapi"
      puts 'requested : ' + attributes["requested"].to_s
      puts 'api_version = ' + attributes["api_version"].to_s
    end

    if element.to_s == 'row'
      @hash = {}
    end

    if @data.include? element.to_s
      @read_string = ""
    end
  end

  def on_cdata_block(cdata)
    puts "CDATA Found: " + cdata.to_s
  end

  def on_characters(chars)
    if @read_string != nil
      @read_string = @read_string + chars
    end
  end

  def on_end_element(element)
    if(element.to_s == "liverailapi")
      puts "LiveRailAPI Ended"
    end

    if(element.to_s == "report")
      puts "Report ended"
    end

    if element.to_s == "row"
      emit_block.call(@hash)
      
    end

    if @data.include? element.to_s
      @hash[element.to_s] = @read_string
      @read_string = nil
    end
  end
end

data = ['day','domain_name','site_id','site_name','country_name']
data = data.concat(['inventory','inventory_fill','impressions','accept_rate','ad_starts','bid','bid_rate','clickthroughs','close_rate','closes','error','error_rate','revenue','revenue_ecpm'])

parser = XML::SaxParser.file("response.xml")  

parser.callbacks = Document.new(data)
parser.parse 

