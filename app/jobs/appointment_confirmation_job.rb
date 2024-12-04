class AppointmentConfirmationJob < ApplicationJob
  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.find(appointment_id)

    AppointmentMailer.confirmation_email_user(appointment).deliver_now
    AppointmentMailer.confirmation_email_provider(appointment).deliver_now
  end
end
