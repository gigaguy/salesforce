({
	gotoQAEditable : function(component, event, helper) {
		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
		selected = event.getParam("question");
		component.set("v.question",selected);
	},
	backToQAView : function(component, event, helper) {
			var evt = $A.get("e.c:TQBCPBackToQAView");
			evt.fire();
	},
	saveQuesAns : function(component, event, helper) {
		var action = component.get("c.saveQuest");
		action.setParams({
			"candidatePackageId": component.get("v.candPackage.Id"),
			"question": component.get("v.question")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				//var evt = $A.get("e.c:TQBCPBackToQAView");
				var evt = $A.get("e.c:TQBCPViewQA");
				evt.setParams({ "candpkg": component.get("v.candPackage"), "question": response.getReturnValue() });
				evt.fire();
				component.set("v.question", response.getReturnValue());
				$A.createComponents([
					["ui:message",{
						"title" : "Success :",
						"severity" : "confirm",
						"class" : "slds-size--1-of-2"
					}],
					["ui:outputText",{
						"value" : "Your answer has been saved successfully."
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
	},
	textCounter : function(component, event, helper) {
		var ans = component.get("v.question.Answer__c");

	  component.set("v.answerLength", ans.length);

		/*if (ans.length < 3840) {
			component.set("v.answerLength", 3840 - ans.length);
		} else {
			component.set("v.answerLength", 3840);
		}*/
	}
})