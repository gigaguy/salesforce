({
	populateCandidatePackage : function(component, event) {   
     	console.log("INFO - TQBCPWizardReturnReviewHelper : populateCandidatePackage START");

		var action = component.get("c.getCandidatePackage");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.candPackage", response.getReturnValue());
				console.log("SUCCESS - TQBCPWizardReturnReviewHelper : populateCandidatePackage : candPackage = " + response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},

	populateCandidateLOI : function(component, event) {
		var action = component.get("c.getCandidateLOI");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.candLOI", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}
})