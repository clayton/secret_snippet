require 'rails_helper'

RSpec.describe HashedEmail do
  describe 'normalizing' do
    before do
      @expected = 'b4c9a289323b21a01c3e940f150eb9b8c542587f1abfd8f0e1cc1ffc5e475514'
    end
    it 'should strip whitespace' do
      sut = HashedEmail.new('  user@example.com ')
      expect(sut.to_s).to eq(@expected)
    end
    it 'should downcase the email' do
      sut = HashedEmail.new('  User@Example.com ')
      expect(sut.to_s).to eq(@expected)
    end
  end
end
