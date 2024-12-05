class AppointmentReminderNotifier < Noticed::Event
  deliver_by :database

  def message_provider
    "Upcoming appointment with #{params[:appointment].user.name} in 1 hour at #{params[:appointment].start_time.strftime("%I:%M %p")}"
  end

  def message_user
    "Upcoming appointment with #{params[:appointment].provider.name} in 1 hour at #{params[:appointment].start_time.strftime("%I:%M %p")}"
  end

  def notification_message
    {
      title: "Appointment Reminder",
      body: generate_message,
      url: url
    }
  end

  def url
    appointments_path
  end
end
