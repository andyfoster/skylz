import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
      "skillNameInput",
      "skillReasonInput",
      "skillStepsInput",
      "skillNotesInput",
      "skillTagsInput"
    ]

    connect() {
        console.log("Hello, skill form!");
        // this.updateValue()

        // this.skillNameInputTarget.value = "Hello World!";
        // this.skillReasonInputTarget.value = "Give me one good reason!";
        // this.skillStepsInputTarget.value = "*Step 1\nStep 2\nStep 3\n*Sub step\nStep4";
        // this.skillNotesInputTarget.value = "Here are where my notes go";
        // this.skillTagsInputTarget.value = "tag1, tag2, tag3";
    }

    generate() {

      // pop up an alert with the value of the name field and stay on the page
      // alert(this.skillNameInputTarget.value);

      if (this.skillNameInputTarget.value == "") {
        alert("Please enter a skill name");
        return false;
      }

      // stop and don't submit form
      // return false;




    // }

    // generate2() {

      // make a get request to skill/generate and fill in the form with the response
      fetch('/generate?message=' + this.skillNameInputTarget.value)

        .then(response => response.json())
        .then(data => {
          console.log(data);

          // this.skillNameInputTarget.value = data.res;
          this.skillReasonInputTarget.value = data.reason;
          this.skillStepsInputTarget.value = data.steps.join("\n");
          this.skillNotesInputTarget.value = data.notes;
          this.skillTagsInputTarget.value = data.tags.join(", ");
        });
    }
}
