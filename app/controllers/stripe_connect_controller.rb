class StripeConnectController < ApplicationController
  before_action :authenticate_user!
  before_action :set_provider, only: [:create]
  NGROK_URL = "https://3195-109-166-129-187.ngrok-free.app"

  def create
    # Create a new Stripe Connect account if one doesn't exist
    create_stripe_account unless @provider.stripe_account_id

    # Generate the Stripe onboarding link
    account_link = Stripe::AccountLink.create({
      account: @provider.stripe_account_id,
      refresh_url: "#{NGROK_URL}/stripe/refresh",
      return_url: "#{NGROK_URL}/providers/#{@provider.id}",
      type: "account_onboarding",
      collect: "eventually_due"
    })

    # Redirect to the Stripe onboarding page
    redirect_to account_link.url, status: :see_other, allow_other_host: true
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Stripe Error: #{e.http_status} - #{e.code} - #{e.message}")
    flash[:alert] = "There was an error with Stripe: #{e.message}"
    redirect_to providers_path
  end

  private

  def set_provider
    @provider = Provider.find(params[:provider_id])
  end

  def create_stripe_account
    account = Stripe::Account.create({
      type: "express",
      email: @provider.user.email,
      country: "RO",
      business_type: "individual",
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      }
    })

    @provider.update!(stripe_account_id: account.id)
    Rails.logger.info("Stripe account create for Provider ID #{@provider.id}: #{account.id}")
  end
end
