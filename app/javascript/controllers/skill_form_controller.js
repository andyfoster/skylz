import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['skillNameInput', 'skillReasonInput', 'skillStepsInput', 'skillNotesInput', 'skillTagsInput', 'generateButton', 'status'];

  async generate(event) {
    event.preventDefault();
    const name = this.skillNameInputTarget.value.trim();
    if (!name) {
      this.statusTarget.textContent = 'Enter a skill name first.';
      this.skillNameInputTarget.focus();
      return;
    }
    this.generateButtonTarget.disabled = true;
    this.statusTarget.textContent = 'Generating a draft…';
    try {
      const response = await fetch(`/generate?message=${encodeURIComponent(name)}`);
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || 'Unable to generate a draft. Please try again.');
      this.skillReasonInputTarget.value = data.reason || '';
      this.skillNotesInputTarget.value = data.notes || '';
      this.skillStepsInputTarget.value = Array.isArray(data.steps) ? data.steps.join('\n') : data.steps || '';
      this.skillTagsInputTarget.value = Array.isArray(data.tags) ? data.tags.join(', ') : data.tags || '';
      [this.skillNotesInputTarget, this.skillStepsInputTarget].forEach(field => field.dispatchEvent(new Event('input', { bubbles: true })));
      this.statusTarget.textContent = 'Draft ready. Review it before saving.';
    } catch (error) {
      this.statusTarget.textContent = error.message;
    } finally {
      this.generateButtonTarget.disabled = false;
    }
  }
}
