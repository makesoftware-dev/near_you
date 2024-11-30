class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_provider
  before_action :ensure_provider_owner

  def index
    @availabilities = @provider.availabilities
    @days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  end

  def create
    @availability = @provider.availabilities.build(availability_params)
    @availability.available = true

    if @availability.save
      redirect_to provider_availabilities_path(@provider), notice: "Availability was successfully added."
    else
      redirect_to provider_availabilities_path(@provider), alert: "Error adding availability: #{@availability.errors.full_messages.join(", ")}"
    end
  end

  def update
    @availability = @provider.availabilities.find(params[:id])

    if @availability.update(availability_params)
      redirect_to provider_availabilities_path(@provider), notice: "Availability was successfully updated."
    else
      redirect_to provider_availabilities_path(@provider), alert: "Error updating availability."
    end
  end

  def destroy
    @availability = @provider.availabilities.find(params[:id])
    @availability.destroy

    redirect_to provider_availabilities_path(@provider), notice: "Availability was successfully removed."
  end

  private

  def set_provider
    @provider = Provider.find(params[:provider_id])
  end

  def ensure_provider_owner
    unless current_user == @provider.user
      redirect_to root_path, alert: "You are not authorized to manage this provider's availability"
    end
  end

  def availability_params
    params.require(:availability).permit(:day_of_week, :start_time, :end_time)
  end
end
