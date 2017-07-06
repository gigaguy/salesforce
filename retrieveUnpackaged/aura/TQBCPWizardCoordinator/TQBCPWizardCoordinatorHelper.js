({
	sendNotifyEmail : function(component, event, personSelectedId, personType){

	   var action = component.get("c.sendNotifyEmail");
	   action.setParams({
	   	  "candPkgId": component.get("v.candPackage.Id"),
	      "tqbPersonId": personSelectedId,
	      "personType": personType
	    });
	   action.setCallback(this, function(response) {
	      var state = response.getState();
	      if (component.isValid() && state === "SUCCESS") {
            console.log ("TQBCPWizardCoordinatorHelper : Email send  = " + response.getReturnValue());
            var result = response.getReturnValue();
	              $A.createComponents([
	                ["ui:message",{
	                  "title" : "Success :",
	                  "severity" : "confirm",
	                  "class" : "slds-size--1-of-2"
	                }],
	                ["ui:outputText",{
	                  "value" : result
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
	              } );
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
	                    "value" : result
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
	    $A.enqueueAction(action);
	},

	sendNotifyEmailtoAdhocMember : function(component, event, adhocPersonSelectedIds){

	   var action = component.get("c.sendNotifyEmailToAdhocMembers");
	   action.setParams({
	   	  "candPkgId": component.get("v.candPackage.Id"),
	      "tqbAdhocMembers": adhocPersonSelectedIds
	    });
	   action.setCallback(this, function(response) {
	      var state = response.getState();
	      if (component.isValid() && state === "SUCCESS") {
            console.log ("TQBCPWizardCoordinatorHelper : Email send  = " + response.getReturnValue());
            var result = response.getReturnValue();
	              $A.createComponents([
	                ["ui:message",{
	                  "title" : "Success :",
	                  "severity" : "confirm",
	                  "class" : "slds-size--1-of-2"
	                }],
	                ["ui:outputText",{
	                  "value" : result
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
	              } );
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
	                    "value" : result
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
	    $A.enqueueAction(action);
	},
	
	deletePanelMemberHelper : function(component, event, panelMemberSelectedId) {

	  console.log('Panel Member selected Id in deletePanelMemberHelper = '+ panelMemberSelectedId);
      var action = component.get("c.deleteSelectedPanelMember");
	    action.setParams({
	      "candPkgId": component.get("v.candPackage.Id") ,
	      "deletePanelMemberId" : panelMemberSelectedId
	    });
	    action.setCallback(this, function(response) {
	    	var state = response.getState();
	       if (component.isValid() && state === "SUCCESS") {
				console.log("value of response from server in TQBCPWizardChairPersonHelper:deletePanelMemberHelper", response.getReturnValue());
			} else if (state === "ERROR") {
				console.log('Error from server');
			}
		});
	  $A.enqueueAction(action);
   
	},

	getSelectedAdhocMember : function(component, event){
  	var action = component.get("c.getSelectedAdHocEntry"); // method in the apex class
       action.setParams({
	      "candPkgId": component.get("v.candPackage.Id")
	    });
	    action.setCallback(this, function(a) {
	      console.log('TQBWizardMeetPrepHelper:getSelectedAdhocMember'+a.getReturnValue());
	      var retrievedAdhocEntryId = a.getReturnValue();
	      var getAllCheckboxes = component.find("checkBox");
	       if(getAllCheckboxes) {
              for (var i = 0; i < getAllCheckboxes.length; i++) {
	             var newSelectedIdValue = getAllCheckboxes[i].get("v.text");
	            if (newSelectedIdValue && newSelectedIdValue == retrievedAdhocEntryId) {
	              getAllCheckboxes[i].set("v.value", true);
	            }
	         }
	       }
	    });
	 
	 $A.enqueueAction(action);
  }

})