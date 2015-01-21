require_relative './response_parser.rb'


def ParseResponse(report_path, data)
  parser = ResponseParser.new(report_path, data)
  parser.each do |row|
    p row
  end
end


data = ['day','domain_name','site_id','site_name','country_name']
data = data.concat(['inventory','inventory_fill','impressions','accept_rate','ad_starts','bid','bid_rate','clickthroughs','close_rate','closes','error','error_rate','revenue','revenue_ecpm'])

#binding.pry
ParseResponse("../response.xml.gz", data)

