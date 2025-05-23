class ProvidersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :authenticate_user!, only: [:show, :edit, :update, :available_slots]
  before_action :set_provider, only: [:show, :edit, :update, :available_slots]

  def index
    if current_user&.provider?
      @provider = current_user.provider
      if @provider
        redirect_to provider_path(@provider)
      else
        redirect_to new_provider_path, alert: "Please complete your provider profile"
      end
    else
      @categories = Provider.categories

      @providers = Provider.includes(:user)

      @providers = apply_filters(@providers, params)

      @service_types = params[:category].present? ? Provider.categories[params[:category]] : Provider.distinct.pluck(:service_type)

      respond_to do |format|
        format.html # Regular rendering
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("providers",
            partial: "providers_list",
            locals: {providers: @providers})
        end
      end
    end
  end

  def service_types
    @provider = current_user
    @service_types = Provider.categories[params[:category]] || []

    @frame_id = params[:frame_id]

    respond_to do |format|
      format.turbo_stream
    end
  end

  def new
    if current_user&.provider?
      redirect_to provider_path(current_user&.provider), alert: "You are already a provider"
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
      # Store the existing images before the update
      existing_images = @provider.images

      if @provider.update(provider_params)
        # Reattach existing images if no new images were uploaded
        if params[:provider][:images].blank?
          existing_images.each do |image|
            @provider.images.attach(image.blob)
          end
        end
        redirect_to provider_path(@provider), notice: "Profile updated successfully"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to root_path, alert: "You are not authorized to edit this profile"
    end
  end

  def purge_image
    @provider = Provider.find(params[:id])
    image = @provider.images.find(params[:image_id])
    image.purge_later
    redirect_back fallback_location: provider_path(@provider), notice: "Image deleted"
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
    params.require(:provider).permit(:name, :category, :service_type, :experience, :hourly_rate, :location, :bio, :profile_picture, images: [])
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

    session_duration = availability.session_duration || 60

    while current_time + session_duration.minutes <= end_time
      # Check if there are any active appointments in this slot
      slot_end_time = current_time + session_duration.minutes
      unless @provider.appointments.active.overlapping(current_time, slot_end_time).exists?
        slots << current_time.strftime("%I:%M %p")
      end
      current_time += session_duration.minutes
    end

    # Filter out past slots if date is today
    if date.today?
      current_time = Time.current
      slots.reject! { |slot| Time.parse(slot) <= current_time }
    end

    slots
  end

  def apply_filters(scope, params)
    scope = scope.where(category: params[:category]) if params[:category].present?

    if params[:service_type].present?
      scope = scope.where(service_type: params[:service_type])
    end

    if params[:location].present? && params[:location].strip.present?
      scope = scope.where("lower(location) LIKE ?", "%#{params[:location].downcase}%")
    end
    scope
  end

  def set_provider
    @provider = Provider.find(params[:id])
  end
end
