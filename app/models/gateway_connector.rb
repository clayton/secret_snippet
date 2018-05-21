#
## Helps with the OIDC flow to TruGateway
class GatewayConnector
  attr_accessor :session_nonce, :session_state, :client_id, :redirect_uri,
                :discovery_url, :auth_url

  def initialize(options: {}, client: nil, jwk_set: nil, jwt_decoder: nil)
    @client = client || HTTParty
    @jwk_set = jwk_set || JSON::JWK::Set
    @jwt_decoder = jwt_decoder || JSON::JWT
    options.symbolize_keys! # we're in rails
    validate_options(options)
    assign_options(options)
    assign_auth_url
  end

  def decode(token = nil)
    raise 'JWT is required' unless token
    jwks = @client.get(@oidc_config[:jwks_uri]).response.body
    jwks_set = @jwk_set.new(
      JSON.parse(jwks)
    )

    decoded = @jwt_decoder.decode(token, jwks_set)
    validate_token(decoded)
    decoded
  end

  private

  def validate_options(options)
    raise 'redirect URI is required' unless options[:redirect_uri]
    raise 'client ID is required' unless options[:client_id]
    raise 'discovery URL is required' unless options[:discovery_url]
  end

  def assign_options(options)
    @client_id     = options[:client_id]
    @redirect_uri  = options[:redirect_uri]
    @discovery_url = options[:discovery_url]
    @session_nonce = options[:session_nonce]
    @session_state = options[:session_state]
  end

  def assign_auth_url
    @oidc_config = auto_configure_oidc
    @auth_url = @oidc_config[:auth_url]
  end

  def validate_token(decoded)
    validate_content_presence(decoded)
    validate_content_matches(decoded)
    validate_timeliness(decoded)
  end

  def validate_timeliness(decoded)
    raise 'Invalid Token: not yet issued' unless
      decoded[:iat].between?(30.seconds.ago.to_i, Time.now.to_i)
    raise 'Invalid Token: token has expired' unless
      decoded[:exp] > Time.now.to_i
  end

  def validate_content_matches(decoded)
    raise 'Invalid Token: audience/client id mismatch' unless
      decoded[:aud] == @oidc_config[:client_id]
    raise 'Invalid Token: nonce mismatch' unless
      decoded[:nonce] == @session_nonce
  end

  def validate_content_presence(decoded)
    raise 'Invalid Token: missing audience' unless
      decoded[:aud].present?
    raise 'Invalid Token: missing subject' unless
      decoded[:sub].present?
  end

  def auto_configure_oidc
    JSON.parse(@client.get(@discovery_url).response.body)
        .merge('client_id' => @client_id)
        .symbolize_keys!
  end
end