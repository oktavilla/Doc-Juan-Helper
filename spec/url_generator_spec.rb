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
    url = subject.generate

    expected = 'http://doc-juan.example.com/render?'
    expected << "url=#{CGI.escape subject.url}"
    expected << "&filename=#{CGI.escape subject.filename}"
    expected << "&options[print_stylesheet]=true"
    expected << "&options[size]=A4"
    expected << "&options[title]=#{CGI.escape 'The Site'}"
    expected << "&key=#{subject.public_key}"

    url.must_equal expected
  end

  it 'generates the url with no options' do
    subject.stubs(:options).returns Hash.new
    url = subject.generate

    expected = 'http://doc-juan.example.com/render?'
    expected << "url=#{CGI.escape subject.url}"
    expected << "&filename=#{CGI.escape subject.filename}"
    expected << "&key=#{subject.public_key}"

    url.must_equal expected
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

  it 'has the secret key' do
    subject.secret_key.must_equal 'zecret'
  end

  it 'fails with NoSecretGivenError unless there is a secret set' do
    DocJuan.config.secret = nil

    proc {
      subject
    }.must_raise DocJuan::NoSecretGivenError
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

  it 'compiles into a seed string for the public key computation' do
    subject.seed_string.must_equal 'filename:file.pdf-options_print_stylesheet:true-options_size:A4-options_title:The Site-url:http://example.com'
  end

  it 'calculates the public key' do
    subject.public_key.must_equal 'b55142f9fdb148e8844e37e064e8eb2af6aabac6'
  end

  it 'calculates the public key with no options given' do
    url_generator = DocJuan::UrlGenerator.new 'http://example.com', 'file.pdf'
    key = url_generator.public_key

    key.must_equal '539ebb1f6cd3fec40591acdc756e9b047e7093b3'
  end

end
