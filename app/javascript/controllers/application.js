import { Application } from "@hotwired/stimulus"
import TextareaAutogrow from 'stimulus-textarea-autogrow';
import { Autocomplete } from 'stimulus-autocomplete';

const application = Application.start()
application.register('textarea-autogrow', TextareaAutogrow);
application.register('autocomplete', Autocomplete);

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
