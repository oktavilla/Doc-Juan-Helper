require 'openssl'
require_relative 'config.rb'

module DocJuan
  class NoSecretGivenError < StandardError; end

  class Token
    def initialize url_generator
      @url_generator = url_generator

      raise NoSecretGivenError if secret == ''
    end

    def key
      sha1 = OpenSSL::Digest.new 'sha1'
      OpenSSL::HMAC.hexdigest sha1, secret, seed
    end

    def secret
      DocJuan.config.secret.to_s.strip
    end

    def seed
      seed = []
      seed << "filename:#{@url_generator.filename}"
      seed << "format:#{@url_generator.format}"
      Hash[(@url_generator.options).sort].each do |k,v|
        seed << "options_#{k}:#{v}"
      end
      seed << "url:#{@url_generator.url}"

      seed.join '-'
    end

  end
end
