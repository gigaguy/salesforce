({
	/*editAdHoc : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var adhocentry = component.get("v.adHocEntry");
		var evt = $A.get("e.c:TQBCPEditAdHoc");
		evt.setParams({ "candpkg": pkg, "adhocEdit": adhocentry });
		evt.fire();
	}*/

	doInit : function(component, event, helper) {
      helper.getloggedInUserRole(component, event);
    },

	selectAdHocEntry : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var adhocentry = component.get("v.adHocEntry");
		var evt = $A.get("e.c:TQBCPViewAdHoc");
		evt.setParams({ "candpkg": pkg, "adhocView": adhocentry });
		evt.fire();
	},
	deleteAdHocEntry: function(component, event, helper) {
		var action = component.get("c.deleteAdHoc");
		action.setParams({
			"adHocEntry": component.get("v.adHocEntry")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var pkg = component.get("v.candPackage");
				var evt = $A.get("e.c:TQBCPAdHocNavigator");
				evt.setParams({ "candpkg": pkg });
				evt.fire();
				//component.set("v.adHocEntry", response.getReturnValue());
				$A.createComponents([
					["ui:message",{
						"title" : "Success :",
						"severity" : "confirm",
						"class" : "slds-size--1-of-2"
					}],
					["ui:outputText",{
						"value" : "Ad Hoc Entry has been deleted successfully."
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