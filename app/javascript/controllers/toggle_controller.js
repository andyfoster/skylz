import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  lineThrough(event) {
    const targetElement = event.currentTarget;
    targetElement.classList.toggle('line-through');
    targetElement.classList.toggle('text-gray-500');
  }
}
