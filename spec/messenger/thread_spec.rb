require 'spec_helper'

describe Facebook::Messenger::Thread do
  let(:fb_access_token) { 'fb access token' }

  let(:thread_settings_url) do
    Facebook::Messenger::Thread.base_uri + '/thread_settings'
  end

  before do
    ENV['ACCESS_TOKEN'] = access_token
  end
end
