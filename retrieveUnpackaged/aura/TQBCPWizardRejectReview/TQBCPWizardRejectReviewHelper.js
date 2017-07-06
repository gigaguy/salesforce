({
	populateCandidatePackage : function(component, event) {
		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
		/*var action = component.get("c.getCandidatePackage");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.candPackage", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);*/
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
	},
	populateRejectReason : function(component, event) {
	  	console.log("==============================================");
	  	console.log('INFO - TQBCPWizardRejectReviewHelper: populateRejectReason : START');		
		var action = component.get("c.getRejectReasonValues");
		var inputsel = component.find("rejectReasonSelect");
		var opts=[];
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var returnVal = response.getReturnValue();
				for(var i = 0; i< returnVal.length; i++){
					opts.push({"class": "optionClass", label: returnVal[i], value: returnVal[i]});
				}
			}
			inputsel.set("v.options", opts);
		});
		$A.enqueueAction(action);
	}
})