import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  lineThrough(event) {
    const targetElement = event.currentTarget;
    const completed = targetElement.getAttribute('aria-pressed') !== 'true';
    targetElement.setAttribute('aria-pressed', String(completed));
  }
}
