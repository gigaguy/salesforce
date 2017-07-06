({
	populateSummary : function(component, event, helper) {
		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
		var msg = event.getParam("msg");
		if (msg) {
			$A.createComponents([
				["ui:message",{
					"title" : "Success :",
					"severity" : "confirm",
					"class" : "slds-size--1-of-2"
				}],
				["ui:outputText",{
					"value" : msg
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
		}
		helper.populateCandidateLOI(component, event);
		helper.populateQA(component, event);
		helper.populateAttachments(component, event);
		helper.populateAdhoc(component, event);
		helper.populateComments(component, event);
		helper.getloggedInUserRole(component, event);
		document.body.scrollTop = document.documentElement.scrollTop = 0;
		component.set("v.messages", []);
	},
	goToAdHoc : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPAdHocNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},
	gotoReviewRecoApprove : function(component, event, helper) {
		console.log('INFO - APPROVE - TQBCPWizardSummaryController : gotoReviewRecoApprove firing TQBCPRecoNavigator event, candPackage Id = ' + component.get("v.candPackage.Id"));
		var pkg = component.get("v.candPackage");
		var adHocEntries = component.get("v.listOfAdHocEntries");

		var evt = $A.get("e.c:TQBCPRecoNavigator");
		evt.setParams({ "candpkg": pkg, "recoType": "approve", "listOfAdHocEntries" : adHocEntries });
		evt.fire();

	},
	gotoReviewRecoReturn : function(component, event, helper) {
		console.log('INFO - RETURN - TQBCPWizardSummaryController : gotoReviewRecoReturn firing TQBCPRecoNavigator event, candPackage Id = ' + component.get("v.candPackage.Id"));
		var pkg = component.get("v.candPackage");
		var adHocEntries = component.get("v.listOfAdHocEntries");

		var evt = $A.get("e.c:TQBCPRecoNavigator");
		evt.setParams({ "candpkg": pkg, "recoType": "return", "listOfAdHocEntries" : adHocEntries  });
		evt.fire();
	},
	gotoReviewRecoReject : function(component, event, helper) {
		console.log('INFO - REJECT - TQBCPWizardSummaryController : gotoReviewRecoReject firing TQBCPRecoNavigator event');
		var pkg = component.get("v.candPackage");
		var adHocEntries = component.get("v.listOfAdHocEntries");

		var evt = $A.get("e.c:TQBCPRecoNavigator");
		evt.setParams({ "candpkg": pkg, "recoType": "reject", "listOfAdHocEntries" : adHocEntries  });
		evt.fire();
	},
	goToMeetPrep : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPMeetPrepNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},
	linkQuestionPage : function(component, event, helper) {

		var evt = $A.get("e.c:TQBCPQuestionNavigator");
		evt.setParams({ "candpkg": component.get("v.candPackage") });
		evt.fire();

		/* Added by Naveen Sadhu to test whether clicking upon question takes you to question view page
		instead of question list page
		var selectedQuestion = event.currentTarget;
		var question = selectedQuestion.dataset.record;
		var pkg = component.get("v.candPackage");

		console.log('value of pkg in linkQuestionPage:' + pkg);
		console.log('value of question in linkQuestionPage:' + question);

		var evt = $A.get("e.c:TQBCPViewQA");
		evt.setParams({ "candpkg": pkg, "question" : question });
		evt.fire();*/
	},
	linkAdhocPage : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPAdHocNavigator");
		evt.setParams({ "candpkg": pkg});
		evt.fire();
	},
	linkAttachmentPage : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPAttachNavigator");
		evt.setParams({ "candpkg": pkg});
		evt.fire();
	},
	submitPackage : function(component, event, helper) {
		var action = component.get("c.submitCandidatePackage");
		action.setParams({
			"candidatePackageId" : component.get("v.candPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				$A.createComponents([
					["ui:message",{
						"title" : "Success :",
						"severity" : "confirm",
						"class" : "slds-size--1-of-2"
					}],
					["ui:outputText",{
						"value" : "Candidate package has been submitted. You will now be transferred to the home page."
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

	}
	/*selectQuestion : function(component, event, helper) {
	var pkg = component.get("v.candPackage");
	var quest = component.get("v.question");

	var evt = $A.get("e.c:TQBCPEditQA");
	evt.setParams({ "candpkg": pkg, "question": quest });
	evt.fire();
}*/
})