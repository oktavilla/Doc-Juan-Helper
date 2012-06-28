require_relative 'spec_helper'

require_relative '../lib/doc_juan/config.rb'

describe DocJuan::Configuration do
  it 'is configurable with a block' do
    DocJuan.configure do |config|
      config.secret = 'very-secret'
      config.host = 'http://my-doc-juan-host.com'
    end

    DocJuan.config.secret.must_equal 'very-secret'
    DocJuan.config.host.must_equal 'http://my-doc-juan-host.com'
  end
end
