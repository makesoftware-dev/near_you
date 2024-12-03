class CleanupPendingAppointmentsJob < ApplicationJob
  queue_as :default

  def perform
    # Clean up appointments that have been pending for more than 30 minutes
    cutoff_time = 30.minutes.ago
    Appointment.where(status: :pending)
      .where("created_at < ?", cutoff_time).destroy_all
  end
end
