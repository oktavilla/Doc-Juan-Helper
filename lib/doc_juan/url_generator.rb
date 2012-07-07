require 'cgi'

require_relative 'token'
require_relative 'config'

module DocJuan
  class NoHostGivenError < StandardError; end

  class UrlGenerator
    attr_reader :url, :filename, :options

    def initialize url, filename, options = {}
      @url = url
      @filename = filename.to_s

      options = {} unless options
      options = options.merge authentication_credentials if has_authentication_credentials?
      @options = options

      raise NoHostGivenError if host == ''
    end

    def generate
      params = []
      params << "url=#{CGI.escape(url)}"
      params << "filename=#{CGI.escape(filename)}"
      options.each do |k,v|
        params << "options[#{CGI.escape(k.to_s)}]=#{CGI.escape v.to_s}"
      end
      params << "key=#{public_key}"

      "#{host}/render?#{params.join('&')}"
    end

    def public_key
      @public_key ||= DocJuan::Token.new(self).key
    end

    def host
      @host ||= DocJuan.config.host.to_s.strip.tap do |host|
        if host != '' && ! host.start_with?('http')
          host.replace "http://#{host}"
        end
      end
    end

    def authentication_credentials
      {
        username: DocJuan.config.username,
        password: DocJuan.config.password
      }
    end

    def has_authentication_credentials?
      authentication_credentials.values.compact.any?
    end
  end
end
