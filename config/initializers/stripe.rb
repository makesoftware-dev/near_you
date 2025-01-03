Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.stripe[:STRIPE_PUBLIC_KEY],
  secret_key: Rails.application.credentials.stripe[:STRIPE_SECRET_KEY]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

# Log the API key for debugging (remove this in production)
Rails.logger.info("Stripe API Key: #{Stripe.api_key}")
