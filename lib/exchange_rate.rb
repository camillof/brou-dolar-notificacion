require 'net/http'
require 'uri'
require 'nokogiri'

module ExchangeRate
  class << self
    # @@last_dolar_value = getDolarValue

    def getDolarValue
      brou_url = "https://www.brou.com.uy/c/portal/render_portlet?p_l_id=20593&p_p_id=cotizacionfull_WAR_broutmfportlet_INSTANCE_otHfewh1klyS&p_p_lifecycle=0&p_t_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=0&p_p_col_count=2&p_p_isolated=1&currentURL=%2Fcotizaciones"
      brou_uri = URI.parse(brou_url)

      brou_response = Net::HTTP.get(brou_uri)
      parsed_brou_response = Nokogiri::HTML.parse(brou_response)
      parsed_brou_response.xpath("/html/body/div/div/div/div/table/tbody/tr[2]/td[5]/div/p").text.strip.gsub(',', '.').to_f
    end

    # def checkDolarValue
    #   current_dolar_value = getDolarValue
    #   if @@last_dolar_value != current_dolar_value
    #     last_dolar_value = current_dolar_value
    #     return current_dolar_value
    #   else
    #     return false
    #   end
    # end
  end



end
