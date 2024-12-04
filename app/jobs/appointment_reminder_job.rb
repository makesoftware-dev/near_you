class AppointmentReminderJob < ApplicationJob
  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.find(appointment_id)

    # Only send reminders for confirmed appointments
    return unless appointment.confirmed?

    AppointmentMailer.reminder_email_user(appointment).deliver_now
    AppointmentMailer.reminder_email_provider(appointment).deliver_now
  end
end
