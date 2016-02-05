require 'net/http'
require 'uri'
require 'json'
require 'openssl'

class CurlHandler
  attr_accessor :use_ssl, :verify_mode, :open_timeout, :read_timeout, :header

  def self.build
    new(true, OpenSSL::SSL::VERIFY_PEER, 3, 5, { 'Content-Type' => 'application/json' })
  end

  def initialize(use_ssl, verify_mode, open_timeout, read_timeout, header)
    @use_ssl      = use_ssl
    @verify_mode  = verify_mode
    @open_timeout = open_timeout
    @read_timeout = read_timeout
    @header       = header
  end

  def get(url)
    uri     = URI.parse(url)
    request = Net::HTTP::Get.new(
      uri.request_uri,
      initheader = @header
    )
    send_request(uri, request)
  end

  def post(url, data)
    uri     = URI.parse(url)
    request = Net::HTTP::Post.new(
      uri.request_uri,
      initheader = @header
    )
    request.body = data
    send_request(uri, request)
  end

  def put(url, data)
    uri     = URI.parse(url)
    request = Net::HTTP::Put.new(
      uri.request_uri,
      initheader = @header
    )
    request.body = data
    send_request(uri, request)
  end

  def delete(url)
    uri     = URI.parse(url)
    request = Net::HTTP::Delete.new(
      uri.request_uri,
      initheader = @header
    )
    send_request(uri, request)
  end

  def append_header(key, value)
    @header[key] = value
  end

  private

  def send_request(uri, request)
    begin
      http              = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl      = @use_ssl
      http.verify_mode  = @verify_mode
      http.open_timeout = @open_timeout
      http.read_timeout = @read_timeout

      http.request(request)
    rescue => e
      puts 'timed out!!'
      puts e
    end
  end
end

curl = CurlHandler.build
curl.verify_mode = OpenSSL::SSL::VERIFY_NONE
curl.append_header('Authorization', 'Bearer aKPuPYHUQ1C9DzpBl6cK4IAkuyihejHJhbZk2mxMo1biN5913cmRmtUT3TYc')
response = curl.get('https://api.kurashicom.dev/timeout')
puts JSON.parse(response.body) if response == Net::HTTPSuccess
