require 'libxml'
include LibXML

class Parser
  include XML::SaxParser::Callbacks
  def on_start_element(element, attributes)
    if (element.to_s == "catalog")
      puts "Catalog Started"
    end

    if (element.to_s == 'book')
      puts 'ID : ' + attributes["id"].to_s
    end

    if element.to_s == "author"
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
    if(element.to_s == "catalog")
      puts "Catalog Ended"
    end

    if(element.to_s == "book")
      puts "n"
    end

    if element.to_s == "author"
      puts "Author :" + @read_string
      @read_string = nil
    end
  end
end


parser = XML::SaxParser.file("books.xml")
parser.callbacks = Parser.new
parser.parse
