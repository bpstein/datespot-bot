require 'rails_helper'

describe User, type: :model do 
  let(:user) { create :user }

  it { should validate_presence_of(:full_name) }

  it 'creates a user with valid input' do 
    expect { create :user }.to change { User.count }.by(1)
  end
end