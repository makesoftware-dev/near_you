class ProvidersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.provider?
      @provider = current_user.provider
      if @provider
        redirect_to provider_path(@provider)
      else
        redirect_to new_provider_path, "Please complete you provider profile"
      end
    else
      @service_types = Provider.distinct.service_types.values
      @providers = Provider.includes(:user)
      if params[:service_type].present?
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

  private

  def provider_params
    params.require(:provider).permit(:id, :service_type, :experience, :hourly_rate, :bio, :rating, :location, :name, :calendly_url)
  end
end
