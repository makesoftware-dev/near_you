import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "timeSlot"]

  connect() {
    console.log("Appointment Calendar Controller connected")
  }

  show() {
    this.modalTarget.classList.remove("hidden")
  }

  hide() {
    this.modalTarget.classList.add("hidden")
  }

  selectDate(event) {
    const date = event.target.value
    const providerId = this.element.dataset.appointmentCalendarProviderIdValue;
  console.log("this is the value of provider id", providerId);
    console.log("provider: ", providerId)
    fetch(`/providers/${this.element.dataset.providerId}/available_slots?date=${date}`)
      .then(response => response.json())
      .then(data => {
        this.timeSlotTarget.innerHTML = data.slots.map(slot =>
          `<button data-time="${slot}" 
            class="slot-btn bg-gray-200 hover:bg-gray-400 text-black font-bold py-1 px-2 m-1 rounded">${slot}</button>`
        ).join("")
      })
  }
}