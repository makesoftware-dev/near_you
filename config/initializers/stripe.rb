Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.stripe[:STRIPE_PUBLIC_KEY],
  secret_key: Rails.application.credentials.stripe[:STRIPE_SECRET_KEY]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
