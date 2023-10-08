import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {
  }

  close(e) {
    // Prevent default action
    e.preventDefault();
    // Remove from parent
    const modal = document.getElementById('modal');
    modal.innerHTML = '';
  }
}
