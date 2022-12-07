<% 
	String _jspName = this.getClass().getSimpleName().replaceAll("_", "."); //current jsp filename
%>

<div id="relaunch-tour-div" style="position:fixed; bottom:20px; right:20px;">
<image id="relaunch-tour" src="js/shepherd/relaunch_en.png" width="100" height="100">
</image>
</div>


<script>

let jspFile = "<%= _jspName%>";
let jsonFile = jspFile.split(".")[0] + ".json";
$("#relaunch-tour").hide();

launchTour(false);

document.getElementById("relaunch-tour").onclick = function(e) {
    launchTour(true);
    return true;
};

function launchTour(relaunch) {
	
	
	$.getJSON("js/shepherd/tours/" + jsonFile)
	.success(function(json) {
		$("#relaunch-tour").show();
		if (!relaunch) {
			console.log(document.cookie.match(/^(.*;)?\s*tourCompleted\s*=\s*[^;]+(.*)?$/));
			var match = document.cookie.match(/^(.*;)?\s*tourCompleted\s*=\s*[^;]+(.*)?$/);
			if (match == -1 || match == null) {
				document.cookie = "tourCompleted=true;";
			} else {
				return;
			}
		}
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
			if ("buttons" in json.steps[i]) {
				for (j in json.steps[i].buttons) {
					if ("action" in json.steps[i].buttons[j]) {
						//much more limited when importing from json file
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
		$("#relaunch-tour").hide();
	    //most likely no json file for this page, but print error
	});
}

</script>