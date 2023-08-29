import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["val", "sl"]

    connect() {
        console.log("Hello, Activity form!");
        // this.element.textContent = "Hello World!"
        this.updateValue()
    }

    // slide() {
    //     this.updateValue()
    // }

    updateValue() {
        const el = this.valTarget;
        const slider = this.slTarget;
        el.textContent = slider.value;
    }
}
