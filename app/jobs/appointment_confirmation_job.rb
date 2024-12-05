class AppointmentConfirmationJob < ApplicationJob
  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.find(appointment_id)

    # Send emails
    AppointmentMailer.confirmation_email_user(appointment).deliver_now
    AppointmentMailer.confirmation_email_provider(appointment).deliver_now

    # Send notifications
    AppointmentConfirmationNotifier.with(appointment: appointment).deliver(appointment.user)
    AppointmentConfirmationNotifier.with(appointment: appointment).deliver(appointment.provider.user)
  end
end
