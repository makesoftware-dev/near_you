// app/javascript/controllers/filters_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Filters controller connected!");
  }

  toggle(event) {
    // Find the dropdown element
    const dropdown = this.element.querySelector("#filter-dropdown");
    if (dropdown) {
      // Toggle visibility
      dropdown.classList.toggle("hidden");
    } else {
      console.error("Dropdown not found!");
    }
  }

  fetchServiceTypes(event) {
    const category = event.target.value;
    if (category) {
      fetch(`/providers/service_types?category=${encodeURIComponent(category)}`, {
        method: "GET",
        headers: { Accept: "text/vnd.turbo-stream.html" }
      })
        .then(response => response.text())
        .then(html => {Turbo.renderStreamMessage(html);})
        .catch(error => console.error("Error fetching service types:", error));
    } else {
      const serviceTypeFrame = document.getElementById("service_type_frame");
      if (serviceTypeFrame) {
        serviceTypeFrame.innerHTML = `
          <div>
            <label for="service_type" class="block text-gray-700 font-medium">Service Type</label>
            <select name="service_type" id="service_type" class="form-select w-full mt-2 p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
              <option value="">Select a Service Type</option>
            </select>
          </div>
        `;
      }
    }
  }
}