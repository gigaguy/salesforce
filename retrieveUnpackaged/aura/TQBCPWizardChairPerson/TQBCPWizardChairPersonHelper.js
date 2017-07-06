({
	selectedPanelMembers : function(component, event, checkedPanelMembersCount) {
		var action = component.get("c.setSelectedPanelMembers");
	    action.setParams({
	      "candPkgId": component.get("v.candPackage.Id") ,
	      "checkedPanelMembersCount" : checkedPanelMembersCount,
	       "checkedPanelMembersName" : component.get("v.checkedPanelMembersName")
	    });
	    action.setCallback(this, function(response) {
	    	var state = response.getState();
	       if (component.isValid() && state === "SUCCESS") {
				console.log("value of response from server in TQBCPWizardChairPersonHelper", response.getReturnValue());
			} else if (state === "ERROR") {
				console.log('Error from server');
			}
		});
	  $A.enqueueAction(action);	    
	},

	updatePanelMemberTable : function(component, event) {

		console.log('TQBCPWizardChairPersonHelper:updatePanelMemberTable' + component.get("v.selectedRecord"));

	  console.log('checking the duplicate of panel members');
	  var panelMemberList = component.get("v.listOfTQBPanelMembers");
	  console.log('Displaying the panel members list =' + panelMemberList);

	  var newPanelEntryId = component.get("v.selectedRecord.Id");
      console.log('selected panel member entry = '+ newPanelEntryId);
      
      var isDuplicatePanelEntry = false;
       for (var i = 0; i < panelMemberList.length; i++) { 
       	  if(newPanelEntryId === panelMemberList[i].Id) {
            console.log('Duplicate Entry added');
            isDuplicatePanelEntry = true;
       	  }
       }
       if(isDuplicatePanelEntry) {
          $A.createComponents([
                ["ui:message",{
                  "title" : "Error :",
                  "severity" : "error",
                  "class" : "slds-size--1-of-2"
                }],
                ["ui:outputText",{
                  "value" : "Panel Member already exists."
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
       }
       else{
       	  var action = component.get("c.setTQBPanelMembersList");
		    action.setParams({
		      "candPkgId": component.get("v.candPackage.Id") ,
		      "user" : component.get("v.selectedRecord")
		    });
		    action.setCallback(this, function(response) {
		    	var state = response.getState();
		       if (component.isValid() && state === "SUCCESS") {
					console.log("value of response from server in TQBCPWizardChairPersonHelper", response.getReturnValue());
					component.set("v.listOfTQBPanelMembers", response.getReturnValue());
				} else if (state === "ERROR") {
					console.log('Error from server');
				}
			});
	      $A.enqueueAction(action);
        }
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
				var evt = $A.get("e.c:TQBCPMeetPrepNavigator");
		        evt.setParams({ "candpkg": component.get("v.candPackage") });
		        evt.fire();
			} else if (state === "ERROR") {
				console.log('Error from server');
			}
		});
	  $A.enqueueAction(action);
   
	},

	alertMessage : function(component, event) {
		$A.createComponents([
                ["ui:message",{
                  "title" : "Error :",
                  "severity" : "error",
                  "class" : "slds-size--1-of-2"
                }],
                ["ui:outputText",{
                  "value" : "You should Select Minimum of 3 Panel Members and Maximum of 5 Panel Members "
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
	},

	sendNotifyEmail : function(component, event, chairPersonSelectedId){

		console.log('inside TQBCPWizardChairPersonHelper:sendNotifyEmail:');

	   var action = component.get("c.sendNotifyEmailCoordinator");
	   action.setParams({
	      "candPkgId": component.get("v.candPackage.Id"),
          "panelMemberList" : component.get("v.listOfTQBPanelMembers"),
          "coordinatorEmail" : component.get("v.coordinatorEmail")
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
	}
})