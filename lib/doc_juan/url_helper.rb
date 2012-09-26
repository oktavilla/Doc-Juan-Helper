require_relative 'url_generator'

module DocJuan
  def self.url url, filename, options = {}
    UrlGenerator.new(url, filename, options.delete(:format), options).generate
  end
end
