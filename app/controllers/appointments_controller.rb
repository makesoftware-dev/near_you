class AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.provider?
      # For providers: filter confirmed appointments into upcoming and previous
      @upcoming_appointments = current_user.provider.appointments
        .where(status: :confirmed)
        .where("appointment_time  <= ?", Time.now)
      @previous_appointments = current_user.provider.appointments
        .where(status: :confirmed)
        .where("appointment_time > ?", Time.now)
    else
      # For regular users: filter confirmed appointments into upcoming and previous
      @upcoming_appointments = current_user.appointments
        .where(status: :confirmed)
        .where("appointment_time <= ?", Time.now)
      @previous_appointments = current_user.appointments
        .where(status: :confirmed)
        .where("appointment_time > ?", Time.now)
    end
  end

  def create
    @provider = Provider.find(params[:provider_id])
    unless @provider.stripe_account_id.present?
      redirect_to provider_path(@provider), alert: "This provider hasn't set up payments yet"
      return
    end

    @appointment = Appointment.new(
      user: current_user,
      provider: @provider,
      appointment_time: params[:appointment_time],
      status: "pending"
    )

    if @appointment.save
      session = Stripe::Checkout::Session.create(
        payment_method_types: ["card"],
        line_items: [{
          price_data: {
            currency: "ron",
            product_data: {
              name: "Appointment with #{@provider.name}"
            },
            unit_amount: @provider.hourly_rate.to_i * 100
          },
          quantity: 1
        }],
        mode: "payment",
        success_url: success_appointment_url(@appointment),
        cancel_url: cancel_appointment_url(@appointment)
      )

      # Update the appointment with the Stripe session ID
      @appointment.update(stripe_session_id: session.id)

      # Redirect the user to the Stripe Checkout page
      redirect_to session.url, allow_other_host: true
    else
      redirect_to provider_path(@provider), alert: "Could not create appointment."
    end
  end

  def success
    @appointment = Appointment.find(params[:id])
    @appointment.update(status: :confirmed)
    # schedule_calendly_event(@appointment)
    redirect_to appointments_path, notice: "Appointment confirmed successfully!"
  end

  def cancel
    @appointment = Appointment.find(params[:id])
    @appointment.update(status: :cancelled)
    redirect_to appointments_path, alert: "Appointment cancelled."
  end

end
