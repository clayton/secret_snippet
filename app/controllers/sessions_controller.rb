require 'digest'

class SessionsController < ApplicationController
  before_action :reset_session, except: [:create]
  before_action :configure_connector, only: %i[new create]
  skip_before_action :verify_authenticity_token

  def new
    @client_id    = @gateway_connector.client_id
    @auth_url     = @gateway_connector.auth_url
    @nonce        = @gateway_connector.session_nonce
    @state        = @gateway_connector.session_state
    @redirect_uri = @gateway_connector.redirect_uri
    @oidc_form_action = Rails.env.development? ? 'https://gateway.staging.trusona.net/oidc' : 'https://gateway.trusona.net/oidc'
  end

  def create
    id_token = @gateway_connector.decode(params[:id_token])

    session['email'] = Digest::SHA256.hexdigest(id_token[:email])
    redirect_to secrets_url
  end

  private

  def configure_connector
    state = session[:session_state] ||= SecureRandom.uuid
    nonce = session[:session_nonce] ||= SecureRandom.uuid
    options = {
      client_id: ENV['TRUSONA_CLIENT_ID'],
      redirect_uri: sessions_url,
      discovery_url: ENV['TRUSONA_DISCOVERY_URL'],
      session_state: state,
      session_nonce: nonce
    }
    @gateway_connector = GatewayConnector.new(options: options)
  end
end
