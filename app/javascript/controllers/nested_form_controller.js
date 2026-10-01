import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['fieldsContainer', 'template'];

  addFields(event) {
    event.preventDefault();
    const id = `${Date.now()}_${this.fieldsContainerTarget.children.length}`;
    this.fieldsContainerTarget.insertAdjacentHTML('beforeend', this.templateTarget.innerHTML.replace(/NEW_RECORD/g, id));
  }

  removeFields(event) {
    event.preventDefault();
    const fields = event.currentTarget.closest('.nested-fields');
    if (fields.dataset.newRecord === 'true') {
      fields.remove();
    } else {
      fields.querySelector('input[name$="[_destroy]"]').value = '1';
      fields.hidden = true;
      fields.querySelectorAll('input, select, textarea').forEach(input => input.required = false);
    }
  }
}
