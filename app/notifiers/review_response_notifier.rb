class ReviewResponseNotifier < Noticed::Event
  deliver_by :email, mailer: "NotificationMailer"

  def message_user
    "Your review has received a response from #{params[:response].provider.name}."
  end

  def url
    provider_path(params[:response].review.provider)
  end
end
