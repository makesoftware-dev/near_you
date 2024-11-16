import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initializeCalendly()
    console.log("Calendly initialized")
  }

  initializeCalendly() {
    Calendly.initInlineWidget({
      url: this.element.dataset.calendlyUrl,
      prefill: {
        name: this.element.dataset.userName,
        email: this.element.dataset.userEmail
      },
      hooks: {
        eventScheduled: (event) => {
          this.handleEventScheduled(event)
        }
      }
    });
  }

  async handleEventScheduled(event) {
    const providerId = this.element.dataset.providerId
    const appointmentTime = event.payload.event.start_time

    try {
      const response = await fetch('/appointments', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({
          provider_id: providerId,
          appointment_time: appointmentTime
        })
      });

      const data = await response.json();
      
      if (data.stripe_url) {
        // Redirect to Stripe checkout for payment
        window.location.href = data.stripe_url;
      } else if (data.error) {
        alert(data.error);
      }
    } catch (error) {
      console.error("Error scheduling event:", error);
    }
  }
}