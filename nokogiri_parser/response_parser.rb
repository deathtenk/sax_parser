require "active_support/benchmarkable"
require "zlib"
require "nokogiri"
require "pry"
require_relative "./response_document.rb"

# @see http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/SAX
# @see http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/SAX/Parser
class ResponseParser

  # attr_writer :logger

  def initialize(response_path, data)
    @data = data
    @response_path = response_path  
  end

  def each(&callback)
    callback_processor = ResponseDocument.new(data, &callback)

    parser = Nokogiri::XML::SAX::Parser.new(callback_processor)

    Zlib::GzipReader.open(response_path.to_s) do |gzip_reader|
      parser.parse_io(gzip_reader)
    end
  end

  private

  attr_reader :response_path, :data

  #def logger
  #  @logger ||= StaqIntegration.logger
  #end
end