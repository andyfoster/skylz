// app/javascript/controllers/nested_form_controller.js
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['fieldsContainer', 'template'];

  connect() {
    console.log('Hello, NestedForm!');
    // this.addFields = this.addFields.bind(this);
    // this.removeFields = this.removeFields.bind(this);
    // this.templateTarget.addEventListener('click', this.addFields);
    // this.fieldsContainerTarget.addEventListener('click', this.removeFields);
  }


  addFields(event) {
    event.preventDefault();
    const newId = new Date().getTime();
    const templateString = this.templateTarget.innerHTML.replace(
      /NEW_RECORD/g,
      newId
    );
    this.fieldsContainerTarget.insertAdjacentHTML('beforeend', templateString);
  }

  removeFields(event) {
    event.preventDefault();
    event.target.closest('.nested-fields').remove();
  }
}
