require_relative 'spec_helper'
require 'mocha'

require_relative '../lib/doc_juan/url_helper'

describe 'DocJuan#url' do
  before :each do
    DocJuan.config.host = 'doc-juan.example.com'
    DocJuan.config.secret = 'zecret'
  end

  it 'passes its arguments to a UrlGenerator instance and uses it to generate the url' do
    generator = stub
    generator.expects(:generate).returns 'generated-url'
    DocJuan::UrlGenerator.expects(:new).
      with('http://example.com', 'the_file', 'pdf', size: 'A4').
      returns(generator)

    url = DocJuan.url 'http://example.com', 'the_file', size: 'A4'

    url.must_equal 'generated-url'
  end

  it 'passes format if set to UrlGenerator instance' do
    generator = stub
    generator.expects(:generate)
    DocJuan::UrlGenerator.expects(:new).
      with('http://example.com', 'the_file', 'jpg', {}).
      returns(generator)

    DocJuan.url 'http://example.com', 'the_file', format: 'jpg'
  end

end
