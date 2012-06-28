require_relative 'spec_helper'

require_relative '../lib/doc_juan/config.rb'

describe DocJuan::Configuration do
  after :each do
    DocJuan.config.secret = nil
    DocJuan.config.host = nil
    DocJuan.config.username = nil
    DocJuan.config.password = nil
  end

  it 'is configurable' do
    DocJuan.config.secret = 'very-secret'
    DocJuan.config.host = 'http://my-doc-juan-host.com'
    DocJuan.config.username = 'a-username'
    DocJuan.config.password = 'the-password'

    DocJuan.config.secret.must_equal 'very-secret'
    DocJuan.config.host.must_equal 'http://my-doc-juan-host.com'
    DocJuan.config.username.must_equal 'a-username'
    DocJuan.config.password.must_equal 'the-password'
  end

  it 'is configurable with a block' do
    DocJuan.configure do |config|
      config.secret = 'very-secret'
    end

    DocJuan.config.secret.must_equal 'very-secret'
  end
end
