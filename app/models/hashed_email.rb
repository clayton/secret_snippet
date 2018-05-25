require 'digest'

class HashedEmail
  def initialize(email = '')
    @email = Digest::SHA256.hexdigest(email.downcase.strip)
  end

  def to_s
    @email
  end
end
