require 'digest'

##
# A Secret
class Secret < ApplicationRecord
  before_save :hash_email, :default_expiration

  validates :recipient_email, presence: true

  def to_param
    id
  end

  private

  def hash_email
    self.recipient_email = HashedEmail.new(recipient_email).to_s
  end

  def default_expiration
    self.expires_at = Time.now + 1.hour if expires_at.nil?
  end

end
