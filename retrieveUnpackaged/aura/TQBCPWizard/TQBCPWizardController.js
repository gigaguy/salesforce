({
	doInit : function(component, event, helper) {
		/*var toggleText = component.find("questionsView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("attachView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adhocView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("summaryView");
		$A.util.addClass(toggleText,'toggle');

		var toggleText = component.find("questionStepId");
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("attachStepId");
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("adhocStepId");
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("summaryStepId");
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');*/
  		helper.populatePackage(component, event);
		helper.getloggedInUserRole(component, event);
	  	//helper.getPackage(component, event);
		//helper.populatePackageStatus(component, event);
    	//helper.goToQuestionnaire(component, event);

	},
	populate1stLineSup: function(component, event) {

		var action = component.get("c.get1stLineSupCurrentValue");
		action.setParams({
			"candPkgId": component.get("v.newPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				console.log('response.getReturnValue() = ' + response.getReturnValue());
				component.set("v.newPackage.Candidates_1st_Line_Supervisor_Name__c", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},

	goToQuestionnaire : function(component, event, helper) {
		var pkg = component.get("v.newPackage");
		var evt = $A.get("e.c:TQBCPQuestionNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},

	goToAttach : function(component, event, helper) {
		var pkg = component.get("v.newPackage");
		var evt = $A.get("e.c:TQBCPAttachNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},
	goToAdHoc : function(component, event, helper) {
		var pkg = component.get("v.newPackage");
		var evt = $A.get("e.c:TQBCPAdHocNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},
	goToSummary : function(component, event, helper) {
		var pkg = component.get("v.newPackage");
		var evt = $A.get("e.c:TQBCPSummaryNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},
	goToReviewReco : function(component, event, helper) {
		var pkg = component.get("v.newPackage");
		var evt = $A.get("e.c:TQBCPRecoNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},
    goTQBMeetPrep : function(component, event, helper) {
        var pkg = component.get("v.newPackage");
		var evt = $A.get("e.c:TQBCPMeetPrepNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
    },
	showPackageHideOther : function(component, event, helper) {
		var toggleText = component.find("addpackageView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("questionsView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("attachView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adhocView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("summaryView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("recoView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("MeetPrepView"); //show
		$A.util.addClass(toggleText,'toggle');

		//var toggleText = component.find("cpStepId");
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		//$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-current');
		var toggleText = component.find("questionStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("attachStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("adhocStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("summaryStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("recoStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("MeetPrepStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
	},
	showQuestionsHideOther : function(component, event, helper) {
		var toggleText = component.find("addpackageView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionsView");  //show questions
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("attachView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adhocView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("summaryView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("recoView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("MeetPrepView"); //show
		$A.util.addClass(toggleText,'toggle');

		//var toggleText = component.find("cpStepId");
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		//$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("questionStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-current');
		var toggleText = component.find("attachStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("adhocStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("summaryStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("recoStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("MeetPrepStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
	},
	showAttachHideOther : function(component, event, helper) {
		var toggleText = component.find("addpackageView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionsView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("attachView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("adhocView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("summaryView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("recoView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("MeetPrepView"); //show
		$A.util.addClass(toggleText,'toggle');

		//var toggleText = component.find("cpStepId");
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		//$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("questionStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("attachStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-current');
		var toggleText = component.find("adhocStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("summaryStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("recoStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("MeetPrepStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
	},
	showAdHocHideOther : function(component, event, helper) {
		var toggleText = component.find("addpackageView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionsView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("attachView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adhocView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("summaryView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("recoView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("MeetPrepView"); //show
		$A.util.addClass(toggleText,'toggle');

		//var toggleText = component.find("cpStepId");
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		//$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("questionStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("attachStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("adhocStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-current');
		var toggleText = component.find("summaryStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("recoStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("MeetPrepStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
	},
	showSummaryHideOther : function(component, event, helper) {
		var toggleText = component.find("addpackageView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionsView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("attachView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adhocView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("summaryView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("recoView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("MeetPrepView"); //show
		$A.util.addClass(toggleText,'toggle');

		//var toggleText = component.find("cpStepId");
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		//$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("questionStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("attachStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("adhocStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("summaryStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-current');
		var toggleText = component.find("recoStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("MeetPrepStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
	},
	showRecoHideOther : function(component, event, helper) {
		var toggleText = component.find("addpackageView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionsView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("attachView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adhocView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("summaryView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("recoView"); //show
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("MeetPrepView"); //show
		$A.util.addClass(toggleText,'toggle');

		//var toggleText = component.find("cpStepId");
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		//$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		//$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("questionStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("attachStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("adhocStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("summaryStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("recoStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-current');
		var toggleText = component.find("MeetPrepStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
	},

	showMeetPrepHideOther : function(component, event, helper) {
		var toggleText = component.find("addpackageView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("questionsView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("attachView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adhocView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("summaryView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("recoView"); //show
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("MeetPrepView"); //show
		$A.util.removeClass(toggleText,'toggle');

		var toggleText = component.find("questionStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("attachStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("adhocStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("summaryStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		var toggleText = component.find("recoStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-current');
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-complete slds-is-won');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		var toggleText = component.find("MeetPrepStepId");
		$A.util.removeClass(toggleText,'slds-tabs--path__item slds-is-incomplete');
		$A.util.addClass(toggleText,'slds-tabs--path__item slds-is-current');
	},
	savePackage: function(component,event) {
		console.log('newPackage = ' + component.get("v.newPackage"));
		var action = component.get("c.saveCandidatePackage");
		action.setParams({
			"candidatePackage": component.get("v.newPackage")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log(response.getReturnValue());
				component.set("v.newPackage", response.getReturnValue());
				$A.createComponents([
					["ui:message",{
						"title" : "Success :",
						"severity" : "confirm",
						"class" : "slds-size--1-of-2"
					}],
					["ui:outputText",{
						"value" : "Candidate Package has been saved successfully."
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
					$A.error("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	}
})