<%@ page errorPage="../ErrorPage.jsp" %>
<jsp:include page="../AdminHeader.jsp" />
<br/>
	
	<label for="label_title">Title:</label>
  <input type="text" id="title" name="title" maxlength="128" size="128"><br><br>
  <label for="label_id">ID:</label>
  <input type="text" id="id" name="id" maxlength="128" size="128"><br><br>
  <label for="label_text">Message Text:</label>
  <input type="text" id="text" name="text" maxlength="256" size="128"><br><br>
  <label for="label_css_sel">CSS selector:</label>
  <input type="text" id="css_sel" name="css_sel" maxlength="128" size="128"><br><br>

<button onclick="appendStep()">
        Append step to tour
    </button>
<button onclick="deleteLastStep()">
        Delete last step
    </button>
<br/>
Copy the output below to use when adding a tour to the database.
<br/>
<textarea id="jsonOutput" type="text" name="contents" maxlength="5000" rows="100" cols="50"></textarea>

<script>

function deleteLastStep() {
	
    var json = new Object();
    if (isFilled()) {
		oldJsonObj = JSON.parse(document.getElementById("jsonOutput").value);
		var len = oldJsonObj.steps.length;
		json.steps = [];
		for (var i = 0; i < len - 1; i++) {
			json.steps[i] = new Object();
			json.steps[i] = oldJsonObj.steps[i];
		}

		var jsonOutputField = document.getElementById("jsonOutput");
    	jsonOutputField.value = JSON.stringify(json, null, 4);

    }
}

/**
 * Appends a step to the tour.
 */
function appendStep() {

    var json = new Object();
    if (isFilled()) {
	oldJsonObj = JSON.parse(document.getElementById("jsonOutput").value);
	var len = oldJsonObj.steps.length;
	json = oldJsonObj;
	json.steps[len] = new Object();
	json.steps[len].title = new Object();
	json.steps[len].id = new Object();
	json.steps[len].text = new Object();
	
	var attachToFilled = document.getElementById("css_sel").value.length > 0;
	if (attachToFilled) {
		json.steps[len].attachTo = [];
		json.steps[len].attachTo[0] = new Object();
		json.steps[len].attachTo[0].element = new Object();
		json.steps[len].attachTo[0].element = document.getElementById("css_sel").value;
		json.steps[len].attachTo[0].on = new Object();
		json.steps[len].attachTo[0].on = "bottom-start";
	}

	json.steps[len].title = document.getElementById("title").value;
	json.steps[len].id = document.getElementById("id").value;
	json.steps[len].text = document.getElementById("text").value;

	if (json.steps[0].buttons != null) {
		json.steps[0].buttons[1] = new Object();
		json.steps[0].buttons[1].text = new Object();
		json.steps[0].buttons[1].text = "Back";
		json.steps[0].buttons[1].action = new Object();
		json.steps[0].buttons[1].action = "tour.back";
	}

	json.steps[len].buttons = [];
	json.steps[len].buttons[0] = new Object();
	json.steps[len].buttons[0].text = new Object();
	json.steps[len].buttons[0].text = "Next";
	json.steps[len].buttons[0].action = new Object();
	json.steps[len].buttons[0].action = "tour.next";
	json.steps[len].buttons[1] = new Object();
	json.steps[len].buttons[1].text = new Object();
	json.steps[len].buttons[1].text = "Back";
	json.steps[len].buttons[1].action = new Object();
	json.steps[len].buttons[1].action = "tour.back";	
    } else {
    	json.steps = [];
	json.steps[0] = new Object();
    	json.steps[0].title = new Object();
	json.steps[0].id = new Object();
	json.steps[0].text = new Object();

	json.steps[0].title = document.getElementById("title").value;
	json.steps[0].id = document.getElementById("id").value;
	json.steps[0].text = document.getElementById("text").value;

	json.steps[0].buttons = [];
	json.steps[0].buttons[0] = new Object();
	json.steps[0].buttons[0].text = new Object();
	json.steps[0].buttons[0].text = "Next";
	json.steps[0].buttons[0].action = new Object();
	json.steps[0].buttons[0].action = "tour.next";

	var attachToFilled = document.getElementById("css_sel").value.length > 0;
	if (attachToFilled) {
		json.steps[0].attachTo = [];
		json.steps[0].attachTo[0] = new Object();
		json.steps[0].attachTo[0].element = new Object();
		json.steps[0].attachTo[0].element = document.getElementById("css_sel").value;
		json.steps[0].attachTo[0].on = new Object();
		json.steps[0].attachTo[0].on = "bottom-start";
	}
    }

    var jsonOutputField = document.getElementById("jsonOutput");
    jsonOutputField.value = JSON.stringify(json, null, 4);
}

var isFilled = function() { return document.getElementById("jsonOutput").value.length > 0; }

window.onload = function() {
    window.addEventListener("beforeunload", function (e) {
        if (!isFilled()) {
            return undefined;
        }
        
        var confirmationMessage = 'There is an edited JSON tour available. '
                                + 'If you leave before saving it, your changes will be lost.';

        (e || window.event).returnValue = confirmationMessage; //Gecko + IE
        return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
    });
};

$.getJSON("js/shepherd/tours/" + jsonFile)
.success(function(json) {
	console.log("tour create");
	const tour = new Shepherd.Tour({
		  useModalOverlay: true,
		  defaultStepOptions: {
		    classes: 'shadow-md bg-purple-dark',
		    scrollTo: {
		          behavior: 'smooth',
		          block: 'center'
		    }
		}
	});

	for (let i in json.steps) {
		console.log("add step " + i);
		if ("buttons" in json.steps[i]) {
			for (j in json.steps[i].buttons) {
				if ("action" in json.steps[i].buttons[j]) {
					//much more limited when importing from json file since we dont have access to tour object in a file
					if (json.steps[i].buttons[j].action == "tour.next") {
						json.steps[i].buttons[j].action = tour.next;
					}
					if (json.steps[i].buttons[j].action == "tour.back") {
						json.steps[i].buttons[j].action = tour.back;
					}
				}
			}
		}
		tour.addStep(json.steps[i]);
	}
	tour.start();
}).error(function(error){
	console.log(error);
    //most likely no json file for this page, but print error
});
</script>

<%@ include file="../AdminFooter.jsp" %>