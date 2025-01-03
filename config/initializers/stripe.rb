Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe, :STRIPE_PUBLIC_KEY) || ENV["STRIPE_PUBLIC_KEY"],
  secret_key: Rails.application.credentials.dig(:stripe, :STRIPE_SECRET_KEY) || ENV["STRIPE_SECRET_KEY"]
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
