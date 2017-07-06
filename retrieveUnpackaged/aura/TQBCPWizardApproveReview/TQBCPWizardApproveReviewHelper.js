({
	getloggedInUserRole : function(component, event) {
		var action = component.get("c.getUserRole"); // method in the apex class
		action.setCallback(this, function(a) {
		component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
		});
		$A.enqueueAction(action);
	},


  setAdhocEntriesSelected : function(component, event, candPkgId, adHocEntryName, newSelectedValue){
      console.log("==============================================");
      console.log("INFO - TQBCPWizardRecoHelper : setAdhocEntriesSelected : START");
     console.log("==============================================");
     console.log("INFO - TQBCPWizardRecoHelper : setAdhocEntriesSelected : candPkgId = " + candPkgId);
     console.log("INFO - TQBCPWizardRecoHelper : setAdhocEntriesSelected : adHocEntryName = " + adHocEntryName);
     console.log("INFO - TQBCPWizardRecoHelper : setAdhocEntriesSelected : newSelectedValue = " + newSelectedValue);
     console.log("==============================================");
      console.log("INFO - TQBCPWizardRecoHelper : setAdhocEntriesSelected : END");

  
    var action = component.get("c.markAdhocReferenceSelected");
    action.setParams({
      "candPkgId": candPkgId,
      "adHocEntryName" : adHocEntryName,
      "newSelectedValue"     : newSelectedValue
    });
},

	// Chris Alley delete candidate attachment
	deleteAttachment: function(component, event) {
		var Id = event.target.id;
		var action = component.get("c.deleteCPAttachment");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id"),
			attachId : Id
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var evt = $A.get("e.c:TQBCPRecoNavigator");
				evt.setParams({ "candpkg": component.get("v.candPackage")});
				evt.fire();
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
	},

	// Chris Alley view candidate attachment
	viewAttachment: function(component, event) {
		var Id = event.target.id;
		var action = component.get("c.viewCPAttachment");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id"),
			attachId : Id
		});
		$A.enqueueAction(action);

	},

	showHideAddAttachment : function(component, event) {
		var toggleText = component.find("ListAttachmentView"); //displays the list attachment view
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("addAttachmentView"); //hides the add attachment view
		$A.util.addClass(toggleText,'toggle');
	},

	hideSupComments : function(component, event) {
		var toggleText = component.find("1stLineComment");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("2ndLineComment");
		$A.util.removeClass(toggleText,'toggle');
	},

	populateCandidatePackage : function(component, event) {
		var action = component.get("c.getCandidatePackage");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.candPackage", response.getReturnValue());
				//var evt = $A.get("e.c:TQBCPAttachNavigator");
				//evt.setParams({ "candpkg": component.get("v.candPackage")});
				//evt.fire();
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
	},



	populateAttachments : function(component, event) {
		console.log("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		console.log('INFO - TQBCWizardApproveReviewHelper : populateAttachments: START');
		console.log("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		console.log('INFO - TQBCWizardApproveReviewHelper : populateAttachments: candPackage Id = ' + component.get("v.candPackage.Id"));
		
		//show the list of attachments and hide the add attchment controls
		var toggleText = component.find("ListAttachmentView"); //show
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("addAttachmentView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
		
		console.log('INFO - TQBCWizardApproveReviewHelper : populateAttachments: calling getCPAttachmentsServer role = supervisor');

		var action = component.get("c.getCPAttachmentsServer");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id"),
			"role" : "supervisor"
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.candAttachedDocs", response.getReturnValue());
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
	}
})