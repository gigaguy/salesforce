({
	populateStateValues : function(component) {
    console.log("==============================================");
    console.log("INFO - TQBCPWizardAdHocEditHelper : populateStateValues : START");
    console.log("==============================================");			
		var action = component.get("c.getStatePickListValues");
		var inputsel = component.find("statePickId");
		var opts=[];
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var returnVal = response.getReturnValue();
    				console.log("SUCCESS - TQBCPWizardAdHocEditHelper : populateStateValues : returnVal = " + response.getReturnValue());

				for(var i = 0; i< returnVal.length; i++){
					opts.push({"class": "optionClass", label: returnVal[i], value: returnVal[i]});
				}
			}
			inputsel.set("v.options", opts);
		});
		$A.enqueueAction(action);
	},


	validateAdHocFields : function(component, event) {
		var errorsExist = false;
		cmp = component.find("firstName");
		fld = cmp.get("v.value");
		if (!fld) {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

		cmp = component.find("lastName");
		fld = cmp.get("v.value");
		if (!fld) {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

		cmp = component.find("address");
		fld = cmp.get("v.value");
		if (!fld) {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

	  cmp = component.find("city");
		fld = cmp.get("v.value");
		if (!fld) {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

		cmp = component.find("statePickId");
		fld = cmp.get("v.value");
		if (!fld || fld == "--None--") {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

		cmp = component.find("postalCode");
		fld = cmp.get("v.value");
		if (!fld) {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else if (/(^\d{5}$)|(^\d{5}-\d{4}$)/.test(fld) == false) {
			cmp.set("v.errors", [{message:"US postal code should be in this format: xxxxx or xxxxx-xxxx"}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

		cmp = component.find("researchArea");
		fld = cmp.get("v.value");
		if (!fld) {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

		cmp = component.find("phone");
		fld = cmp.get("v.value");
		if (!fld) {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else if (/^\d{3}-\d{3}-\d{4}$/.test(fld) == false) {
			cmp.set("v.errors", [{message:"US phone numbers should be in this format: xxx-xxx-xxxx."}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

		cmp = component.find("email");
		fld = cmp.get("v.value");
		if (!fld) {
			cmp.set("v.errors", [{message:"This is a required field"}]);
			var errorsExist = true;
		} else {
			cmp.set("v.errors", null);
		}

		return errorsExist;
	},
	saveAdHoc: function(component, event) {
		console.log("==============================================");
	    console.log("INFO - TQBCPWizardAdHocEditHelper : saveAdHoc : START");
	    console.log("==============================================");	
		var mode;
		var ahe = component.get("v.adHocEntry.Id");
		if (ahe) {
			mode = 'update';
		} else {
			mode = 'insert';
		}
		var onRecoReviewScreen = component.get("v.onRecoReviewScreen");
  		console.log("INFO - TQBCPWizardAdHocEditHelper :  onRecoReviewScreen after component.get = " + onRecoReviewScreen);
		component.set("v.onRecoReviewScreen",onRecoReviewScreen);
   		console.log("INFO - TQBCPWizardAdHocEditHelper :  onRecoReviewScreen after component.set = " + onRecoReviewScreen);

		var action = component.get("c.saveAdHocEntry");
		action.setParams({
			"candidatePackageId": component.get("v.candPackage.Id"),
			"adHocEntry": component.get("v.adHocEntry"),
			"mode" : mode
		});


		if (onRecoReviewScreen == 'false'){


		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
    	   	 console.log("SUCCESS - TQBCPWizardAdHocEditHelper : saveAdHoc : saved ad hoc entry");



			  var evt = $A.get("e.c:TQBCPViewAdHoc");
				evt.setParams({ "candpkg": component.get("v.candPackage"), "adhocView" :  response.getReturnValue() });
				evt.fire();
				//console.log(response.getReturnValue());
				component.set("v.adHocEntry", response.getReturnValue());
				$A.createComponents([
					["ui:message",{
						"title" : "Success :",
						"severity" : "confirm",
						"class" : "slds-size--1-of-2"
					}],
					["ui:outputText",{
						"value" : "Ad Hoc Entry has been saved successfully."
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
						}), 5000
					);
				} )
			} else if (state === "ERROR") {
        var errors = response.getError();
    	   	 console.log("ERROR - TQBCPWizardAdHocEditHelper : saveAdHoc : failed to save ad hoc entry");
        
        console.log(errors[0]);
        console.log(errors[0].message);
        if (errors[0] && errors[0].pageErrors) {
          $A.createComponents([
            ["ui:message",{
              "title" : "Error:",
              "severity" : "error",
              "class" : "slds-size--1-of-2"
            }],
            ["ui:outputText",{
              "value" : errors[0].pageErrors[0].message
            }]
          ],
          function(components) {
            var message = components[0];
            var outputText = components[1];
            // set the body of the ui:message to be the ui:outputText
            message.set("v.body", outputText);
            component.set("v.messages", message);
            document.body.scrollTop = document.documentElement.scrollTop = 0;
          } )
        } else if (errors[0] && errors[0].message) {
          $A.createComponents([
            ["ui:message",{
              "title" : "Error:",
              "severity" : "error",
              "class" : "slds-size--1-of-2"
            }],
            ["ui:outputText",{
              "value" : errors[0].message
            }]
          ],
          function(components) {
            var message = components[0];
            var outputText = components[1];
            // set the body of the ui:message to be the ui:outputText
            message.set("v.body", outputText);
            component.set("v.messages", message);
            document.body.scrollTop = document.documentElement.scrollTop = 0;
          } )
        }
      }

	});
	
} // end if onRecoReviewScreen == false


		$A.enqueueAction(action);


if (onRecoReviewScreen == 'true') {
    		console.log("INFO - TQBCPWizardAdHocEditController : fire event: TQBCPRecoNavigator onRecoReviewScreen = " + onRecoReviewScreen);
			var pkg = component.get("v.candPackage");   
			var adHocEntries = component.get("v.listOfAdHocEntries");
			var evt = $A.get("e.c:TQBCPRecoNavigator");
			evt.setParams({ "candpkg": pkg, "recoType": "approve", "listOfAdHocEntries" : adHocEntries });
			evt.fire();

}


	}

})