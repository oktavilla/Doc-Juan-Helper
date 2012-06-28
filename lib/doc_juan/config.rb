module DocJuan

  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end

  class Configuration
    attr_accessor :host, :secret,
                  :username, :password
  end

end
