class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :provider

  enum status: {pending: 0, confirmed: 1, completed: 2, cancelled: 3}

  # Virtual attribute for appointment duration
  attr_accessor :duration

  before_save :set_end_time

  private

  def set_end_time
    return unless start_time
    # Default to provider's session duration or 60 minutes
    duration_minutes = provider&.availabilities&.first&.session_duration || 60
    self.end_time = start_time + duration_minutes.minutes
  end
end
