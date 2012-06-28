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
      size: 'A4'
    })
  end

  it 'generates the url' do
    url = subject.generate

    expected = 'http://doc-juan.example.com?'
    expected << "url=#{CGI.escape subject.url}"
    expected << "&filename=#{CGI.escape subject.filename}"
    expected << "&options[size]=A4"
    expected << "&options[title]=#{CGI.escape 'The Site'}"
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

  it 'compiles into a seed string for the public key computation' do
    subject.seed_string.must_equal 'filename:file.pdf-options_size:A4-options_title:The Site-url:http://example.com'
  end

  it 'calculates the public key' do
    subject.public_key.must_equal 'df9515da45dd0cd445a678928bc3e575cc106793'
  end

  it 'calculates the public key with no options given' do
    url_generator = DocJuan::UrlGenerator.new 'http://example.com', 'file.pdf'
    key = url_generator.public_key

    key.must_equal '539ebb1f6cd3fec40591acdc756e9b047e7093b3'
  end

end
