({
	
	populateAdHoc : function(component, event) {
		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);

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


    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
         console.log('TQBCPWizardRecoHelper : setAdhocEntriesSelected = '+ response.getReturnValue());
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

	populatePackageStatus : function(component, event) {
		var action = component.get("c.getCPStatusPickListValues");
		var inputsel = component.find("InputSelectDynamic");
		var opts=[];
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var returnVal = response.getReturnValue();
				console.log("SUCCESS - TQBCPWizardRecoHelper : populatePackageStatus : returnVal = " + returnVal);
				for(var i = 0; i< returnVal.length; i++){
					opts.push({"class": "optionClass", label: returnVal[i], value: returnVal[i]});
				}
			}
			inputsel.set("v.options", opts);
		});
		$A.enqueueAction(action);
	},



  // Developer: Chris Alley
  // populate pre-existing attachments on the CP wizard review recommendation attachment screen
  populateAttachments : function(component, event) {
    console.log("==============================================");
    console.log("INFO - TQBCPWizardRecoHelper : populateAttachments : START");
    console.log("==============================================");

    var toggleText = component.find("ListAttachmentView"); //show
    $A.util.removeClass(toggleText,'toggle');
    var toggleText = component.find("addAttachmentView"); //hide
    $A.util.addClass(toggleText,'toggle');

    var selected = event.getParam("candpkg");
    component.set("v.candPackage",selected);
    //console.log('TQBFileControllerHelper : populateAttachments: selected value');
    console.log("INFO - TQBCPWizardRecoHelper : populateAttachments: cp id = " + component.get("v.candPackage.Id"));
    var action = component.get("c.getCPAttachmentsServer");
    action.setParams({
      "candPkgId": component.get("v.candPackage.Id"),
      "role" : "supervisor"
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        component.set("v.candAttachedDoc", response.getReturnValue());
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

  populateCandidateLOI : function(component, event, candpkg) {
    
	var cpId = candpkg.Id;
    var action = component.get("c.getCandidateLOI");

    action.setParams({
      "candPkgId": cpId
    });
    console.log ("INFO - TQBCPWizardRecoHelper : populateCandidateLOI " + cpId);
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        component.set("v.candLOI", response.getReturnValue());
        console.log ("SUCCESS - TQBCPWizardRecoHelper : populateCandidateLOI response.getReturnValue() after server getCandidateLOI call = " + response.getReturnValue());

         } else if (state === "ERROR") {
       alert('ERROR - TQBCPWizardRecoHelper : populateCandidateLOI : ERROR returnd from Apex server getCandidateLOI');
      console.log ("ERROR - TQBCPWizardRecoHelper : populateCandidateLOI response.getReturnValue() after server getCandidateLOI call = " + response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  },

    getloggedInUserRole : function(component, event) {
	    var action = component.get("c.getUserRole"); // method in the apex class
	    action.setCallback(this, function(a) {
	      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
	      console.log ("INFO -TQBCPWizardRecoHelper :In helper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
	    });
	    $A.enqueueAction(action);
  }



})