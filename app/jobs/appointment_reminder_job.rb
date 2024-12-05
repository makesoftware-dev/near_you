class AppointmentReminderJob < ApplicationJob
  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.find(appointment_id)

    return unless appointment.confirmed?

    # Send emails
    AppointmentMailer.reminder_email_user(appointment).deliver_now
    AppointmentMailer.reminder_email_provider(appointment).deliver_now

    # Send notifications
    AppointmentReminderNotifier.with(appointment: appointment).deliver(appointment.user)
    AppointmentReminderNotifier.with(appointment: appointment).deliver(appointment.provider.user)
  end
end
