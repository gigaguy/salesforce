({



	populateReco : function(component, event, helper) {
	  	console.log("==============================================");
	  	console.log('INFO - TQBCPWizardRecoController : populateReco : START');
	  	var candpkg = event.getParam("candpkg");
			component.set("v.candPackage",candpkg);
		var recoType = event.getParam("recoType");
			component.set("v.recoType",recoType);
		var listOfAdHocEntries = event.getParam("listOfAdHocEntries");
			component.set("v.listOfAdHocEntries",listOfAdHocEntries);
		helper.populateCandidateLOI(component, event, candpkg);
		helper.getloggedInUserRole(component, event);
	    helper.populateAdHoc(component, event);
	    helper.populateAttachments(component, event);

	    if (recoType == 'approve') {
   		  	console.log('INFO - TQBCPWizardRecoController : populateReco : approve screen');

			var toggleText = component.find("adHocEditView"); //hide ad hoc new entry
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("approveReviewView"); //show
			$A.util.removeClass(toggleText,'toggle');
			var toggleText = component.find("returnReviewView"); //hide
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("rejectReviewView"); //hide
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("adHocListSelectionView"); //show
			$A.util.removeClass(toggleText,'toggle');
		}

	    if (recoType == 'return') {
   		  	console.log('INFO - TQBCPWizardRecoController : populateReco : return screen');

			var toggleText = component.find("adHocEditView"); //hide
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("approveReviewView"); //hide
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("returnReviewView"); //show
			$A.util.removeClass(toggleText,'toggle');
			var toggleText = component.find("rejectReviewView"); //hide
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("adHocListSelectionView"); //hide
			$A.util.addClass(toggleText,'toggle');
		}

	    if (recoType == 'reject') {
   		  	console.log('INFO - TQBCPWizardRecoController : populateReco : reject screen');

			var toggleText = component.find("adHocEditView"); //hide
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("approveReviewView"); //hide
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("returnReviewView"); //hide
			$A.util.addClass(toggleText,'toggle');
			var toggleText = component.find("rejectReviewView"); //show
			$A.util.removeClass(toggleText,'toggle');
			var toggleText = component.find("adHocListSelectionView"); //hide
			$A.util.addClass(toggleText,'toggle');			
		}

	},

// Developer: Chris Alley
// Added so supervisors can add another ad hoc entry to the CP.
	createAdHocEntry : function(component, event, helper) {

	  	console.log("==============================================");
	  	console.log("INFO - TQBCPWizardRecoController : createAdHocEntry : START");
		component.set("v.messages", []);
		var pkg = component.get("v.candPackage");
		var adhocentryVar = {
			"Name":"",
			"First_Name__c":"",
			"Last_Name__c":"",
			"Mailing_Address__c":"",
			"City__c":"",
			"State__c":"",
			"Postal_Code__c":"",
			"Phone__c":"",
			"Email__c":"",
			"Research_Area__c":"",
			"sobjectType":"TQB_Ad_Hoc_Entry__c"
		};

		var toggleText = component.find("adHocEditView"); //show ad hoc new entry
		$A.util.removeClass(toggleText,'toggle');
		var evt = $A.get("e.c:TQBCPNewAdHoc");
		evt.setParams({ "candpkg": pkg, "adhocNew": adhocentryVar });
		evt.fire();
	},


	linkAdhocPage : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPAdHocNavigator");
		evt.setParams({ "candpkg": pkg});
		evt.fire();
	},

	getSelectedAdhocEntries : function(component, event, helper){
		   	var candPkg  = component.get("v.candPackage");
		   	var candPkgId = candPkg.Id;
			var selectedEntryArray = [];
			var getAllCheckboxes = component.find("checkBox");
			var newSelectedValue = "";
			var adHocEntryName = "";
			var selectedEntryCounter = 0;
     		console.log('INFO - TQBCPWizardRecoController : getSelectedAdhocEntries : candPkgId = '+ candPkgId);
     		console.log('INFO - TQBCPWizardRecoController : getSelectedAdhocEntries : # of checkboxes found = '+ getAllCheckboxes.length);  
		  
			for (var i = 0; i < getAllCheckboxes.length; i++) {
				selectedEntryArray.push(getAllCheckboxes[i].get("v.text"));
				newSelectedValue = getAllCheckboxes[i].get("v.value");
				if (newSelectedValue == true) {
					selectedEntryCounter++;
				}
				component.set("v.adHocEntryName", selectedEntryArray[i]);
				adHocEntryName = selectedEntryArray[i];

				console.log('INFO - TQBCPWizardRecoController : getSelectedAdhocEntries : selectedEntryArray = '+ selectedEntryArray[i]);
				console.log('INFO - TQBCPWizardRecoController : getSelectedAdhocEntries : adHocEntryName = '+ adHocEntryName);
				console.log('INFO - TQBCPWizardRecoController : getSelectedAdhocEntries : newSelectedValue = '+ newSelectedValue);
				console.log('INFO - TQBCPWizardRecoController : getSelectedAdhocEntries : calling helper.setAdhocEntriesSelected');				
	 		}
	 	if (selectedEntryCounter != 3) {
	 		state = "ERROR";
	 		alert('Please select 3 ad hoc references before attempting to save.');
	 	} else {
	 		for (var i = 0; i < getAllCheckboxes.length; i++) {
				selectedEntryArray.push(getAllCheckboxes[i].get("v.text"));
				newSelectedValue = getAllCheckboxes[i].get("v.value");	
				component.set("v.adHocEntryName", selectedEntryArray[i]);
				adHocEntryName = selectedEntryArray[i];
	 			helper.setAdhocEntriesSelected(component, event, candPkgId, adHocEntryName, newSelectedValue);
	 		}
	 		state = "SUCCESS";
	 	}
      if (state === "SUCCESS") {
        $A.createComponents([
          ["ui:message",{
            "title" : "Success :",
            "severity" : "confirm",
            "class" : "slds-size--1-of-2"
          }],
          ["ui:outputText",{
            "value" : "Your ad hoc selections have been saved successfully."
          }]
        ],
        function(components) {
          var message = components[0];
          var outputText = components[1];
          // set the body of the ui:message to be the ui:outputText
          message.set("v.body", outputText);
          component.set("v.messages", message);
          window.setTimeout(
            $A.getCallback(function() {
              component.set("v.messages", []);
			document.body.scrollTop = document.documentElement.scrollTop = 0;

            }), 5000
          );
        } )
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors[0] && errors[0].pageErrors) {
          console.log(errors[0].pageErrors);
          $A.createComponents([
            ["ui:message",{
              "title" : "Save Failed:",
              "severity" : "error",
              "class" : "slds-size--1-of-2"
            }],
            ["ui:outputText",{
              "value" : "Please select 3 ad hoc references before attempting to save."
            }]
          ],
          function(components) {
            var message = components[0];
            var outputText = components[1];
            // set the body of the ui:message to be the ui:outputText
            message.set("v.body", outputText);
            component.set("v.messages", message);
            window.setTimeout(
              $A.getCallback(function() {
                component.set("v.messages", []);
				document.body.scrollTop = document.documentElement.scrollTop = 0;

              }), 5000
            );
          } )
        } else {
          //$A.error("Unknown error"); DEPRACATED
        }   	
      }//end error checking and message code
   	} // end getSelectedAdhocEntries
})