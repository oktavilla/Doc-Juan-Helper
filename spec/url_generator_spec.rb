require 'addressable/uri'

require_relative 'spec_helper'

require_relative '../lib/doc_juan/config.rb'
require_relative '../lib/doc_juan/url_generator.rb'

describe DocJuan::UrlGenerator do
  before :each do
    DocJuan.config.host = 'doc-juan.example.com'
    DocJuan.config.secret = 'zecret'
  end

  subject do
    DocJuan::UrlGenerator.new('http://example.com', 'file.pdf', {
      title: 'The Site',
      size: 'A4',
      print_stylesheet: true
    })
  end

  it 'generates the url' do
    uri = Addressable::URI.parse subject.generate
    query = CGI.parse uri.query

    uri.host.must_equal 'doc-juan.example.com'
    uri.path.must_equal '/render'

    query['url'].first.must_equal subject.url
    query['filename'].first.must_equal subject.filename
    query['key'].first.must_equal subject.public_key

    subject.options.each do |k, v|
      query["options[#{k}]"].first.must_equal v.to_s
    end
  end

  it 'has the host' do
    DocJuan.config.host = 'example.com'

    subject.host.must_equal 'http://example.com'
  end

  it 'fails with NoHostGivenError unless there is a host set' do
    DocJuan.config.host = nil

    proc {
      subject
    }.must_raise DocJuan::NoHostGivenError
  end

  it 'uses the token class to calculate the key' do
    DocJuan::Token.expects(:new).with(subject).returns stub(key: 'verypublickey')
    subject.public_key.must_equal 'verypublickey'
  end

  describe '#authentication' do
    before :each do
      DocJuan.config.username = 'xkcd'
      DocJuan.config.password = 'correct horse battery staple'
    end

    after :each do
      DocJuan.config.username = nil
      DocJuan.config.password = nil
    end

    it 'knows if authentication credentials is added' do
      subject.has_authentication_credentials?.must_equal true
    end

    it 'knows if authentication credentials is missing' do
      DocJuan.config.username = nil
      DocJuan.config.password = nil

      subject.has_authentication_credentials?.must_equal false
    end

    it 'appends username and password to options if set as config variables' do
      subject.options[:username].must_equal 'xkcd'
      subject.options[:password].must_equal 'correct horse battery staple'
    end

  end

end
