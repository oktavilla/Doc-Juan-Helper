require_relative 'url_generator'

module DocJuan
  def self.url url, filename, options = {}
    generator = UrlGenerator.new url, filename, options
    generator.generate
  end
end
