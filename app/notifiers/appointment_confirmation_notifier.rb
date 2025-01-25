class AppointmentConfirmationNotifier < Noticed::Event
  deliver_by :email, mailer: "NotificationMailer"

  def message_provider
    "New appointment confirmed with #{params[:appointment].user.name} for #{formatted_time}"
  end

  def message_user
    "Your appointment with #{params[:appointment].provider.name} has been confirmed for #{formatted_time}"
  end

  def formatted_time
    params[:appointment].start_time.strftime("%B %d at %I:%M %p")
  end

  def url
    appointments_path
  end
end
