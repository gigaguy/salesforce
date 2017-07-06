({
	doInit : function(component, event, helper) {
		/*var action = component.get("c.getCandidateQuestions");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.listOfQuestions", response.getReturnValue());
			} else if (state === "ERROR") {

			}
		});
		$A.enqueueAction(action);
		*/
	},
	goToPackage : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPPackageNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},
	goToAttach : function(component, event, helper) {
		var action = component.get("c.validateCandidateQuestionnaire");
		action.setParams({
			"candidatePackageId" : component.get("v.candPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
        component.set("v.messages", []);
				var pkg = component.get("v.candPackage");
			  var evt = $A.get("e.c:TQBCPAttachNavigator");
			  evt.setParams({ "candpkg": pkg });
			  evt.fire();
			} else if (state === "ERROR") {
				var errors = response.getError();
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
						/*window.setTimeout(
							$A.getCallback(function() {
								component.set("v.messages", []);
							}), 5000
						);*/
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
						/*window.setTimeout(
							$A.getCallback(function() {
								component.set("v.messages", []);
							}), 5000
						);*/
					} )
				}
			}
		});
		$A.enqueueAction(action);

	},
	showEditQAHideList : function(component, event, helper) {
		var toggleText = component.find("questionListView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionDetailView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionEditView");
		$A.util.removeClass(toggleText,'toggle');
	},
	showQADetailHideList : function(component, event, helper) {
		var toggleText = component.find("questionListView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionDetailView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("questionEditView");
		$A.util.addClass(toggleText,'toggle');
	},
	/*backToQAList : function(component, event, helper) {
		var toggleText = component.find("questionListView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("questionDetailView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionEditView");
		$A.util.addClass(toggleText,'toggle');
	},*/
	populateQA : function(component, event, helper) {
    component.set("v.messages", []);
		var toggleText = component.find("questionListView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("questionDetailView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionEditView");
		$A.util.addClass(toggleText,'toggle');

		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
		console.log('INFO TQBCPWizardQuestionsController : populateQA : ');
		console.log(component.get("v.candPackage"));
		console.log(component.get("v.candPackage.Id"));

		//edited by Naveen Sadhu to populate candidate info correctly on top of Candidate package
		helper.populateCandidateLOI(component, event);

		helper.getloggedInUserRole(component, event);

		var action = component.get("c.getCandidateQuestions");
		//var self = this;
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.listOfQuestions", response.getReturnValue());
				console.log('SUCCESS - TQBCPWizardQuestionsController : populateQA : list of questions = ' + response.getReturnValue());

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

	saveQA : function(component, event, helper) {
		var mode;
		var qList = component.get("v.listOfQuestions");
		if (qList[0].Id) {
			//helper.updateQuestionnaire(component, event);
			//action = component.get("c.updateQuestionnaire");
			mode = 'update';
			for (var i = 0; i < qList.length; i++) {
				delete qList[i].Name;
				delete qList[i].TQB_Candidate_Package__c;
			}
		} else {
			//helper.insertQuestionnaire(component, event);
			//action = component.get("c.insertQuestionnaire");
			mode = 'insert';
		}

		var action = component.get("c.saveQuestionnaire");
		//var saveqs = event.getParam("actsave");
		//console.log(saveaccount);
		action.setParams({
			"questionnaire": JSON.stringify(qList),
			"sObjType" : "TQB_Candidate_Questionnaire__c",
			"mode" : mode
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log(response.getReturnValue());
				//component.set("v.newPackage", response.getReturnValue());
				$A.createComponents([
					["ui:message",{
						"title" : "Success :",
						"severity" : "confirm",
						"class" : "slds-size--1-of-2"
					}],
					["ui:outputText",{
						"value" : "Your answers have been saved successfully."
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
				if (errors[0] && errors[0].pageErrors) {
					console.log(errors[0].pageErrors);
					$A.createComponents([
						["ui:message",{
							"title" : "Save Failed:",
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
						window.setTimeout(
							$A.getCallback(function() {
								component.set("v.messages", []);
							}), 5000
						);
					} )
				} else {
					//$A.error("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	}
})