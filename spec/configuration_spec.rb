require_relative 'spec_helper'

require_relative '../lib/doc_juans_helper/config.rb'

describe DocJuansHelper::Configuration do
  it 'is configurable with a block' do
    DocJuansHelper.configure do |config|
      config.secret = 'very-secret'
      config.host = 'http://my-doc-juan-host.com'
    end

    DocJuansHelper.config.secret.must_equal 'very-secret'
    DocJuansHelper.config.host.must_equal 'http://my-doc-juan-host.com'
  end
end
