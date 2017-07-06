({
	doInit : function(component, event, helper) {
		var toggleText = component.find("adHocEditView"); //hide ad hoc new entry
		$A.util.addClass(toggleText,'toggle');

		//display list of ad hoc entries stored in the event attributes
		var listOfAdHocEntries = event.getParam("listOfAdHocEntries");
		component.set("v.listOfAdHocEntries",listOfAdHocEntries);

		helper.showHideAddAttachment(component, event);
		
		//helper.hideSupComments(component, event);
		//helper.populateCandidatePackage(component, event);
		//helper.populateCandidateLOI(component, event);
		helper.populateAttachments(component, event);
    	helper.getloggedInUserRole(component, event);
    	component.set("v.messages", []);
		document.body.scrollTop = document.documentElement.scrollTop = 0;
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
	 		//alert('Please select 3 ad hoc references before attempting to save.');
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
    	
      }//end error checking and message code
   	}, // end getSelectedAdhocEntries

    cancelApproveReview : function(component, event, helper) {
        var evt = $A.get("e.c:TQBCPSummaryNavigator");
		evt.setParams({ "candpkg": component.get("v.candPackage")});
		evt.fire();
    },
	submitApproveReview : function(component, event, helper) {
        component.set("v.messages", []);
  		var action = component.get("c.saveReviewCommentAndApprove");
			action.setParams({
				"candidatePackageId" : component.get("v.candPackage.Id"),
				"reviewComment": component.get("v.newComment"),
				"userRole": component.get("v.loggedInUserRole.UserRole.Name")
			});
	      //Error handling and messaging to the user interface so users know if the comment was saved
      //successfully.
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					//var toggleText = component.find("ListAttachmentView"); //hide
                   // $A.util.addClass(toggleText,'toggle');
                    var toggleText = component.find("addAttachmentView"); //hide
                    $A.util.addClass(toggleText,'toggle');

					$A.createComponents([
						["ui:message",{
							"title" : "Success :",
							"severity" : "confirm",
							"class" : "slds-size--1-of-2"
						}],
						["ui:outputText",{
							"value" : "Candidate package has been approved. You will now be transferred to the home page."
						}]
					],
					function(components) {
						var message = components[0];
						var outputText = components[1];
						// set the body of the ui:message to be the ui:outputText
						message.set("v.body", outputText);
						component.set("v.messages", message);
						document.body.scrollTop = document.documentElement.scrollTop = 0;
						window.setTimeout(
							$A.getCallback(function() {
								component.set("v.messages", []);
								var urlEvent = $A.get("e.force:navigateToURL");
							  urlEvent.setParams({
									"url": 'https://epaoei--ord.lightning.force.com/one/one.app#/home'
								});
								urlEvent.fire();
							}), 5000
						);
					} )
				} else if (state === "ERROR") {
					var errors = response.getError();
					console.log(errors[0]);
					console.log(errors[0].message);
					if (errors[0] && errors[0].pageErrors) {
						$A.createComponents([
							["ui:message",{
								"title" : "Error:",
								"severity" : "error",
								"class" : "slds-size--2-of-3"
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

							window.setTimeout(
								$A.getCallback(function() {
									component.set("v.messages", []);
								}), 5000
							);
						} )
					} else if (errors[0] && errors[0].message) {
						$A.createComponents([
							["ui:message",{
								"title" : "Error:",
								"severity" : "error",
								"class" : "slds-size--2-of-3"
							}],
							["ui:outputText",{
								"value" : errors[0].message,
								"aura:id" : "msgTextId"
							}]
						],
						function(components) {
							var message = components[0];
							var outputText = components[1];
							// set the body of the ui:message to be the ui:outputText
							message.set("v.body", outputText);
							component.set("v.messages", message);
              document.body.scrollTop = document.documentElement.scrollTop = 0;

							window.setTimeout(
								$A.getCallback(function() {
									component.set("v.messages", []);
								}), 5000
							);
						} )
					}
				}
			});
			$A.enqueueAction(action);

	},

	addNewAttachment : function(component, event, helper) {
		//hide comment box from supervisors when adding an attachment to the recommendation review.
		var toggleText = component.find("comment"); //hide comment box on add new attachment screen
		$A.util.addClass(toggleText,'toggle');		
		var toggleText = component.find("showHideCancelSubmitApprovalButtons"); //hide cancel/submit approval buttons on add new attach screen
		$A.util.addClass(toggleText,'toggle');
		
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPNewAttachment");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},

	// View the attachment.
	viewAttachment : function(component, event, helper) {
		helper.viewAttachment(component, event);
	},


	// Deletes the attachment.
	deleteAttachment : function(component, event, helper) {
		helper.deleteAttachment(component, event);

		
	},

	showHideAddAttachment : function(component, event, helper) {
		var toggleText = component.find("ListAttachmentView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("addAttachmentView");
		$A.util.removeClass(toggleText,'toggle');
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


	populateCandidatePackage : function(component, event) {
		var action = component.get("c.getCandidatePackage");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.candPackage", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},

	populateAllAttachment : function(component, event, helper) {
		helper.populateAttachments(component, event);
		//display list of ad hoc entries stored in the event attributes
		var listOfAdHocEntries = event.getParam("listOfAdHocEntries");
		component.set("v.listOfAdHocEntries",listOfAdHocEntries);
        component.set("v.messages", []);
        var toggleText = component.find("adHocEditView"); //hide ad hoc new entry
		$A.util.addClass(toggleText,'toggle');
	},

	save : function(component, event, helper) {
		helper.save(component, event);
	},

	waiting: function(component, event, helper) {
		$A.util.addClass(component.find("uploading").getElement(), "uploading");
		$A.util.removeClass(component.find("uploading").getElement(), "notUploading");
	},

	doneWaiting: function(component, event, helper) {
		$A.util.removeClass(component.find("uploading").getElement(), "uploading");
		$A.util.addClass(component.find("uploading").getElement(), "notUploading");
	},

	goToQuestionnaire : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPQuestionNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},

	goToAdHoc : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPAdHocNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	}

})