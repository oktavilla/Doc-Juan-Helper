require 'openssl'
require 'cgi'

module DocJuan
  class NoHostGivenError < StandardError; end
  class NoSecretGivenError < StandardError; end

  class UrlGenerator
    attr_reader :url, :filename, :options

    def initialize url, filename, options = {}
      @url = url
      @filename = filename.to_s
      @options = Hash[(options || {}).sort]

      raise NoSecretGivenError if secret_key == ''
      raise NoHostGivenError if host == ''
    end

    def generate
      params = []
      params << "url=#{CGI.escape(url)}"
      params << "filename=#{CGI.escape(filename)}"
      options.each do |k,v|
        params << "options[#{CGI.escape(k.to_s)}]=#{CGI.escape v}"
      end
      params << "key=#{public_key}"

      "#{host}?#{params.join('&')}"
    end

    def public_key
      sha1 = OpenSSL::Digest::Digest.new 'sha1'
      OpenSSL::HMAC.hexdigest sha1, secret_key, seed_string
    end

    def seed_string
      seed = []
      seed << "filename:#{filename}"
      options.each do |k,v|
        seed << "options_#{k}:#{v}"
      end
      seed << "url:#{url}"

      seed.join '-'
    end

    def host
      @host ||= DocJuan.config.host.to_s.strip.tap do |host|
        if host != '' && ! host.start_with?('http')
          host.replace "http://#{host}"
        end
      end
    end

    def secret_key
      DocJuan.config.secret.to_s.strip
    end
  end
end
