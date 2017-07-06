({
	doInit : function(component, event, helper) {
		//helper.populateCandidatePackage(component, event);
		//helper.populateRejectReason(component, event);
	},
	populateRecoReview : function(component, event, helper) {
		console.log("=============================================");
		console.log("INFO - TQBCPWizardReturnRejectReviewController : populateRecoReview : START");
		var candpkg = event.getParam("candpkg");
		component.set("v.candPackage",candpkg);
		//helper.populateCandidatePackage(component, event);
		console.log("INFO - TQBCPWizardReturnRejectReviewController : calling helper.populateRejectReason");
		helper.populateRejectReason(component, event);
    	component.set("v.messages", []);
		document.body.scrollTop = document.documentElement.scrollTop = 0;
	},
     cancelRejectReview : function(component, event, helper) {
        var evt = $A.get("e.c:TQBCPSummaryNavigator");
		evt.setParams({ "candpkg": component.get("v.candPackage")});
		evt.fire();
    },
	submitRejectReview : function(component, event, helper) {
		  var action = component.get("c.saveReviewCommentAndReject");
			action.setParams({
				"candidatePackageId" : component.get("v.candPackage.Id"),
				"reviewComment": component.get("v.newComment"),
				"rejectReason" : component.find("rejectReasonSelect").get("v.value")
			});
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var toggleText = component.find("rejectReasonView");
                    $A.util.addClass(toggleText,'toggle');
                    var toggleText = component.find("rejectCommentView");
                    $A.util.addClass(toggleText,'toggle');

					$A.createComponents([
						["ui:message",{
							"title" : "Success :",
							"severity" : "confirm",
							"class" : "slds-size--1-of-2"
						}],
						["ui:outputText",{
							"value" : "Candidate package has been rejected. You will now be transferred to the home page."
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
})