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

      if (this.skillNameInputTarget.value == '') {
        alert('Please enter a skill name');
        return false;
      }

      // Make a GET request to skill/generate and fill in the form with the response
      fetch('/generate?message=' + this.skillNameInputTarget.value)
        .then((response) => {
          if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          try {
            console.log(data);

            // Check if the necessary keys exist in the data
            if (
              !(
                'reason' in data &&
                'steps' in data &&
                'notes' in data &&
                'tags' in data
              )
            ) {
              throw new Error('Missing required keys in the response data');
            }

            this.skillReasonInputTarget.value = data.reason;
            this.skillStepsInputTarget.value = Array.isArray(data.steps)
              ? data.steps.join('\n')
              : '';
            this.skillNotesInputTarget.value = data.notes;
            this.skillTagsInputTarget.value = Array.isArray(data.tags)
              ? data.tags.join(', ')
              : '';

            console.log('Data successfully parsed and form populated.');
          } catch (e) {
            console.error(
              'An error occurred while parsing or populating data:',
              e
            );
          }
        })
        .catch((error) => {
          console.error('An error occurred while fetching data:', error);
        });

      // stop and don't submit form
      // return false;

      //   // Simulated API response
      //   const apiResponse = {
      //     data: [
      //       `{
      //   "reason": "To control and submit an opponent from the spiderweb position",
      //   "note": "The Americana from Spiderweb is a highly effective submission technique that can be used when you have your opponent immobilized in the spiderweb position. It is a joint lock targeting the opponent's shoulder joint, causing immense pain and potential injury if applied correctly. This skill is commonly used in Brazilian Jiu-Jitsu and submission grappling competitions.",
      //   "steps": [
      //     "*set up",
      //     "Secure your grip on the opponent's left wrist with your right hand",
      //     "Slide your right knee over the opponent's left arm",
      //     "Bring your left hand through the gap created by your right knee and grab your own right wrist",
      //     "Apply downward pressure on the opponent's left wrist with your right hand while simultaneously lifting their elbow with your left hand",
      //     "Maintain control and gradually increase the pressure to achieve the submission",
      //     "Note: Be mindful of your partner's safety and tap out early when training",
      //     "*position",
      //     "You and your opponent are in the spiderweb position. Your right leg is over their left arm, and your left leg is over their head, trapping them in place.",
      //     "Next steps..."
      //   ],
      //   "tags": ["Brazilian Jiu-Jitsu", "Submission Grappling", "Joint Lock", "Spiderweb Position"]
      // }`,
      //     ],
      //   };

      // make a get request to skill/generate and fill in the form with the response
      //   fetch('/generate?message=' + this.skillNameInputTarget.value)

      //     .then(response => response.json())
      //     // need to catch errors here
      //     .catch(error => console.log(error))

      //     .then(data => {
      //       console.log(data);

      //       // this.skillNameInputTarget.value = data.res;
      //       this.skillReasonInputTarget.value = data.reason;
      //       this.skillStepsInputTarget.value = data.steps.join("\n");
      //       this.skillNotesInputTarget.value = data.notes;
      //       this.skillTagsInputTarget.value = data.tags.join(", ");
      //     });

      // try {
      //   // Access the data array
      //   const dataArray = apiResponse.data;

      //   // Get the first element, which is a JSON string
      //   const jsonString = dataArray[0];

      //   // Parse the JSON string into an object
      //   const parsedData = JSON.parse(jsonString);

      //   // Use the properties of the parsed object to populate your form
      //   // For example:
      //   // document.querySelector('#reason').value = parsedData.reason;
      //   // document.querySelector('#note').value = parsedData.note;

      //   this.skillReasonInputTarget.value = parsedData.reason;
      //   // this.skillStepsInputTarget.value = data.steps.join("\n");
      //   this.skillNotesInputTarget.value = parsedData.note;

      //   // Populate steps and tags similarly...
      //   console.log('Data successfully parsed and form populated.');
      // } catch (e) {
      //   // Log the exception and stop further execution
      //   console.error('An error occurred:', e);
      // }

      // }

      // generate2() {

      // make a get request to skill/generate and fill in the form with the response
      //   fetch('/generate?message=' + this.skillNameInputTarget.value)

      //     .then(response => response.json())
      //     // need to catch errors here
      //     .catch(error => console.log(error))

      //     .then(data => {
      //       console.log(data);

      //       // this.skillNameInputTarget.value = data.res;
      //       this.skillReasonInputTarget.value = data.reason;
      //       this.skillStepsInputTarget.value = data.steps.join("\n");
      //       this.skillNotesInputTarget.value = data.notes;
      //       this.skillTagsInputTarget.value = data.tags.join(", ");
      //     });
    }
}
