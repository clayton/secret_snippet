class SecretsController < ApplicationController

  before_action :configure_connector, only: %i[show]
  before_action :reset_session, only: [:show]

  def index
    @list_secrets_status = 'active'
    @secrets = Secret.where(recipient_email: session[:email]).where(['expires_at > ?', Time.now]).order(:expires_at)
    session[:email] = nil
  end

  def new
    @new_secret_status = 'active'
    @secret = Secret.new
  end

  def create
    @secret = Secret.new(secret_params)

    if @secret.save
      flash[:error] = nil
      render 'create'
    else
      flash[:error] = "A recipient email is required."
      @recipient_email_valid_class = 'is-invalid'
      render 'new'
    end
  end

  def show
    @client_id    = @gateway_connector.client_id
    @auth_url     = @gateway_connector.auth_url
    @nonce        = @gateway_connector.session_nonce
    @state        = @gateway_connector.session_state
    @redirect_uri = @gateway_connector.redirect_uri
    @oidc_form_action = Rails.env.development? ? 'https://gateway.staging.trusona.net/oidc' : 'https://gateway.trusona.net/oidc'
  end

  private

  def secret_params
    params.require(:secret).permit(:recipient_email, :secret, :expires_at)
  end

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
