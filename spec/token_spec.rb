require_relative 'spec_helper'
require_relative '../lib/doc_juan/token.rb'
require 'mocha'

describe DocJuan::Token do
  before :each do
    DocJuan.config.secret = 'zecret'
  end

  let(:url_generator) do
    stub(url: 'http://example.com', filename: 'file', format: 'pdf', options: {
      title: 'The Site',
      size: 'A4',
      print_stylesheet: true
    })
  end

  subject { DocJuan::Token.new(url_generator) }

  it 'compiles into a seed string for the public key computation' do
    subject.seed.must_equal 'filename:file-format:pdf-options_print_stylesheet:true-options_size:A4-options_title:The Site-url:http://example.com'
  end

  it 'calculates the public key' do
    subject.key.must_equal '85906324d44df6d6309ad2a268841b8e127baf0c'
  end

  it 'calculates the public key with no options given' do
    url_generator = stub url: 'http://example.com', filename: 'file', format: 'pdf', options: {}
    token = DocJuan::Token.new(url_generator)

    token.key.must_equal '2fb616f00c7986e1d4ee31a2046f422640f35e2a'
  end

  it 'has the secret key' do
    subject.secret.must_equal 'zecret'
  end

  it 'fails with NoSecretGivenError unless there is a secret set' do
    DocJuan.config.secret = nil

    proc {
      subject
    }.must_raise DocJuan::NoSecretGivenError
  end


end
