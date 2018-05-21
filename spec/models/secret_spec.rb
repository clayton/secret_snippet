require 'rails_helper'

RSpec.describe Secret, type: :model do
  describe 'validations' do
    it 'requires a recipient email' do
      s = Secret.create(recipient_email: '')
      expect(s.errors).to be
      expect(s.valid?).to_not be
    end
  end

  describe 'defaults' do
    it 'uses a default expiration time' do
      s = Secret.create(recipient_email: 'user@example.com')
      expect(s.expires_at).to be
    end
  end

  describe 'hashing the recipient email' do
    it 'should not store the recipient email in plain text' do
      s = Secret.create(recipient_email: 'user@example.com')
      expect(s.recipient_email).to eq('b4c9a289323b21a01c3e940f150eb9b8c542587f1abfd8f0e1cc1ffc5e475514')
    end
  end
end
