class StripeConnectController < ApplicationController
  before_action :authenticate_user!
  before_action :set_provider, only: [:create]
  NGROK_URL = ENV["NGROK_URL"] || "https://abc123.ngrok.io"

  def create
    # Create a new Stripe Connect account
    create_stripe_account unless @provider.stripe_account_id

    # Generate the stripe onboarding link
    account_link = Stripe::AccountLink.create({
      account: account.id,
      refresh_url: "#{NGROK_URL}/stripe/onboarded",
      return_url: "#{NGROK_URL}/stripe/onboarded",
      type: "account_onboarding",
    })

    # Redirect to Stripe onboarding page
    redirect_to account_link.url, status: :see_other, allow_other_host: true
    resque Stripe::InvalidRequestError => e
    Rails.logger.error("Stripe Error: #{e.http_status} - #{e.code} - #{e.message}")
    flash[:alert] = "There was an error while Stripe: #{e.message}"
    redirect_to provider_path
  end

  private

  def set_provider
    @provider = Provider.find(params[:provider_id])
  end

  def create_stripe_account
    account = Stripe::Account.create(
      type: "express",
      email: @provider.user.email,
      country: "RO",
      business_type: "individual",
      capabilities: {
        card_payments: {requested: true},
        transfers: {requested: true}
      },
      tos_acceptance: {
        service_agreement: "recipient"
      }
    )

    @provider.update!(stripe_acount_id: account.id)
    Rails.logger.info("Stripe account create for Provider ID #{@provider.id}: #{account.id}")
  end
end
