({
	populateQA : function(component, event) {
		var action = component.get("c.getCandidateQuestions");
		//var self = this;
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.listOfQuestions", response.getReturnValue());
			} else if (state === "ERROR") {
				/*var errors = response.getError();
				if (errors) {
					$A.log("Errors", errors);
					if (errors[0] && errors[0].message) {
						$A.error("Error message: " + errors[0].message);
					}
				} else {
					$A.error("Unknown error");
				}*/
			}
		});
		$A.enqueueAction(action);
	},

	populateCandidateLOI : function(component, event) {
    	var selectedPackageId = component.get("v.candPackage.Id");
        var action = component.get("c.getCandidateLOI");
        action.setParams({
			"candPkgId" : selectedPackageId
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.candLOI", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

	populateAttachments : function(component, event) {
		var action = component.get("c.getCPAttachmentsServer");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id"),
			"role" : "candidate"
		});
        action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
                console.log('TQBCPWizardSummaryHelper : populateAttachments response values =' + response.getReturnValue());
                
				component.set("v.candAttachedDocs", response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					$A.logf("Errors", errors);
					if (errors[0] && errors[0].message) {
						$A.error("Error message: " + errors[0].message);
					}
				} else {
					$A.error("Unknown error");
				}
			}
		});
	  $A.enqueueAction(action);
	},

	populateAdhoc :function(component, event){

		var action = component.get("c.getCandidateAdHocEntries");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.listOfAdHocEntries", response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					$A.logf("Errors", errors);
					if (errors[0] && errors[0].message) {
						$A.error("Error message: " + errors[0].message);
					}
				} else {
					$A.error("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	populateComments : function(component, event){

		var action = component.get("c.getReviewComments");
		action.setParams({
			"candPkgId" : component.get("v.candPackage.Id")
		});
        action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.listofComments", response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					$A.logf("Errors", errors);
					if (errors[0] && errors[0].message) {
						$A.error("Error message: " + errors[0].message);
					}
				} else {
					$A.error("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	getloggedInUserRole : function(component, event) {
       var action = component.get("c.getUserRole"); // method in the apex class
	    action.setCallback(this, function(a) {
	      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
	      console.log ("TQBCPWizardSummaryHelper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
	    });
     $A.enqueueAction(action);
  }
})