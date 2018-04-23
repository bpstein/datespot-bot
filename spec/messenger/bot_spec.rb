require 'spec_helper'

describe Facebook::Messenger::Bot do
  let(:fb_access_token) { 'access token' }
  let(:fb_verify_token) { 'verify token' }
  let(:fb_app_secret) { 'app secret' }
  

  before do
    ENV['FB_ACCESS_TOKEN'] = fb_access_token
    ENV['FB_APP_SECRET'] = fb_app_secret
    ENV['FB_ACCESS_TOKEN'] = fb_access_token
  end

  subject { Facebook::Messenger::Bot }

  describe '.on' do
    let(:hook) { proc { |_args| } }

    context 'with a valid event' do
      before { subject.on :message, &hook }

      it 'registers a hook' do
        expect(subject.hooks[:message]).to eq(hook)
      end
    end

    context 'with an invalid event' do
      it 'raises ArgumentError' do
        expect { subject.on :foo, &hook }.to raise_error(
          ArgumentError, /foo is not a valid event/
        )
      end
    end
  end

  describe '.receive' do 
    context 'with a message' do
      let(:message) { Facebook::Messenger::Incoming::Message.new({}) }

      it 'triggers a :message' do
        expect(Facebook::Messenger::Incoming).to receive(:parse)
          .and_return(message)

        expect(Facebook::Messenger::Bot).to receive(:trigger)
          .with(:message, message)

        subject.receive({})
      end
    end
  end

  context 'with a delivery' do
    let(:delivery) { Facebook::Messenger::Incoming::Delivery.new({}) }

    it 'triggers a :delivery' do
      expect(Facebook::Messenger::Incoming).to receive(:parse)
        .and_return(delivery)

      expect(Facebook::Messenger::Bot).to receive(:trigger)
        .with(:delivery, delivery)

      subject.receive({})
    end
  end

  context 'with a postback' do
    let(:postback) { Facebook::Messenger::Incoming::Postback.new({}) }

    it 'triggers a :delivery' do
      expect(Facebook::Messenger::Incoming).to receive(:parse)
        .and_return(postback)

      expect(Facebook::Messenger::Bot).to receive(:trigger)
        .with(:postback, postback)

      subject.receive({})
    end
  end

  context 'with an optin' do
    let(:optin) { Facebook::Messenger::Incoming::Optin.new({}) }

    it 'triggers a :delivery' do
      expect(Facebook::Messenger::Incoming).to receive(:parse)
        .and_return(optin)

      expect(Facebook::Messenger::Bot).to receive(:trigger)
        .with(:optin, optin)

      subject.receive({})
    end
  end

  context 'with a read' do
    let(:read) { Facebook::Messenger::Incoming::Read.new({}) }

    it 'triggers a :read' do
      expect(Facebook::Messenger::Incoming).to receive(:parse)
        .and_return(read)

      expect(Facebook::Messenger::Bot).to receive(:trigger)
        .with(:read, read)

      subject.receive({})
    end
  end
end