({
    populateCandidateLOI : function(component, event) {
    	var selectedPackageId = component.get("v.candPackage.Id");
    	console.log('populateCandidateLOI:candPackage id =' + selectedPackageId);
        var action = component.get("c.getCandidateLOI");
        action.setParams({
			"candPkgId" : selectedPackageId
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.candLOI", response.getReturnValue());
                console.log('populateCandidateLOI:candLOI:currentworkLocation=');
                console.log(component.get("v.candLOI.Current_GS_Level__c"));
            }
        });
        $A.enqueueAction(action);
    },

    getloggedInUserRole : function(component, event) {
	    var action = component.get("c.getUserRole"); // method in the apex class
	    action.setCallback(this, function(a) {
	      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
	      console.log ("TQBCPWizardQuestion :In helper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
	    });
	    $A.enqueueAction(action);
  }

    
    /*updateQuestionnaire : function(component, event) {

	},

	insertQuestionnaire : function(component, event) {
		var action = component.get("c.insertQuestionnaire");
		action.setParams({
			"questionnaire": $A.util.json.encode(component.get("v.listOfQuestions")),
			"sObjType" : "TQB_Candidate_Questionnaire__c"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				alert('Success: ' + response.getReturnValue());
				//component.set("v.listOfQuestions", response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					$A.log("Errors", errors);
					if (errors[0] && errors[0].message) {
						$A.error("Error message: " + errors[0].message);
					}
				} else {
					$A.error("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	}*/
})