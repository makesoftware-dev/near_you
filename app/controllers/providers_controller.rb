class ProvidersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_provider, only: [:show, :edit, :update, :available_slots]

  def index
    if current_user.provider?
      @provider = current_user.provider
      if @provider
        redirect_to provider_path(@provider)
      else
        redirect_to new_provider_path, alert: "Please complete you provider profile"
      end
    else
      @categories = Provider.categories
      @service_types = Provider.distinct.service_types.values
      @providers = Provider.includes(:user)
      if params[:category].present?
        @providers = @providers.where(service_type: @categories[params[:category]])
      elsif params[:service_type].present?
        @providers = @providers.where(service_type: params[:service_type])

      end
    end
  end

  def new
    if current_user.provider?
      redirect_to provider_path(current_user.provider), alert: "You are already a provider"
    else
      @provider = Provider.new
    end
  end

  def create
    if current_user.provider
      redirect_to provider_path(current_user.provider), alert: "You already have a provider profile"
      return
    end

    @provider = Provider.new(provider_params)
    @provider.user = current_user

    if @provider.save
      current_user.update(role: :provider)
      redirect_to provider_path(@provider), notice: "Successfully registered as a provider!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @provider = Provider.find(params[:id])
  end

  def edit
    @provider = Provider.find(params[:id])
    unless current_user == @provider.user
      redirect_to root_path, alert: "You are not authorized to edit this profile"
    end
  end

  def update
    @provider = Provider.find(params[:id])

    if current_user == @provider.user
      if @provider.update(provider_params)
        redirect_to provider_path(@provider), notice: "Profile updated successfully"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to root_path, alert: "You are not authorized to edit this profile"
    end
  end

  def available_slots
    date = Date.parse(params[:date])
    day_of_week = date.strftime("%A")

    availability = @provider.availabilities.find_by(day_of_week: day_of_week)

    if availability&.available?
      slots = generate_slots(date, availability)
      render json: {slots: slots}
    else
      render json: {slots: []}
    end
  end

  private

  def provider_params
    params.require(:provider).permit(:id, :service_type, :experience, :hourly_rate, :bio, :rating, :location, :name)
  end

  def set_provider
    @provider = Provider.find(params[:id])
  end

  def generate_slots(date, availability)
    slots = []
    current_time = DateTime.new(
      date.year,
      date.month,
      date.day,
      availability.start_time.hour,
      availability.start_time.min
    )

    end_time = DateTime.new(
      date.year,
      date.month,
      date.day,
      availability.end_time.hour,
      availability.end_time.min
    )

    session_duration = availability.session_duration || 60 # default to 60 minutes if not set

    while current_time + session_duration.minutes <= end_time
      slots << current_time.strftime("%I:%M %p")
      current_time += session_duration.minutes
    end

    # Filter out past slots if date is today
    if date.today?
      current_time = Time.current
      slots.reject! { |slot| Time.parse(slot) <= current_time }
    end

    slots
  end
end
