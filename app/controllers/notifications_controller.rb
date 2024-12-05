class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def read
    @notification = current_user.notifications.find(params[:id])
    @notification.update(read_at: Time.current)

    redirect_to appointments_path
  end
end
