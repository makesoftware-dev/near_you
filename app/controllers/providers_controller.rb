class ProvidersController < ApplicationController
  before_action :authenticate_user!

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
    provider = Provider.find(params[:id])
    date = Date.parse(params[:date])
    day_of_week = date.strftime("%A")

    availability = provider.availabilities.find_by(day_of_week: day_of_week)

    if availability&.available
      slots = generate_slots_for_date(date, availability.start_time, availability.end_time)
      render json: {slots: slots}
    else
      render json: {slots: []}
    end
  end

  private

  def provider_params
    params.require(:provider).permit(:id, :service_type, :experience, :hourly_rate, :bio, :rating, :location, :name)
  end

  def generate_slots_for_date(date, start_time, end_time)
    slots = []
    current_time = DateTime.new(
      date.year,
      date.month,
      date.day,
      start_time.hour,
      start_time.min
    )
    end_time = DateTime.new(
      date.year,
      date.month,
      date.day,
      end_time.hour,
      end_time.min
    )

    while current_time < end_time
      slots << current_time.strftime("%I:%M %p")
      current_time += 30.minutes
    end

    slots
  end
end
