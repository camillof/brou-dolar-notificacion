require 'net/http'
require 'uri'
require 'json'

module Ifttt
  KEY = "cFQzbC30_S2sNOTVBbfrOd".freeze

  class << self
    def triggerHook(endpoint, values)
      header = {'Content-Type': 'application/json'}
      hook_url = "https://maker.ifttt.com/trigger/#{endpoint}/with/key/#{KEY}"
      hook_uri = URI.parse(hook_url)
      http = Net::HTTP.new(hook_uri.host)
      request = Net::HTTP::Post.new(hook_uri.request_uri, header)
      payload = values
      request.body = payload.to_json

      http.request(request)
    end
  end

end
