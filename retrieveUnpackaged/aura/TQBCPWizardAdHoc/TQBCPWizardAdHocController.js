({
	backToAdHocList : function(component, event, helper) {
		var toggleText = component.find("adHocListView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("adHocDetailView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adHocEditView");
		$A.util.addClass(toggleText,'toggle');
	},
	backToAdHocDetail : function(component, event, helper) {
		var toggleText = component.find("adHocListView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adHocDetailView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("adHocEditView");
		$A.util.addClass(toggleText,'toggle');
	},
	handleDeleteAdHoc : function(component, event, helper) {
		var selected = event.getParam("adhocDelete");

	},
	populateAdHoc : function(component, event, helper) {
		component.set("v.messages", []);
		var toggleText = component.find("adHocListView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("adHocDetailView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adHocEditView");
		$A.util.addClass(toggleText,'toggle');

		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);

		//edited by Naveen Sadhu to populate candidate info correctly on top of Candidate package
		helper.populateCandidateLOI(component, event);

		var action = component.get("c.getCandidateAdHocEntries");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.listOfAdHocEntries", response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					$A.logf("Errors", errors);
					if (errors[0] && errors[0].message) {
						$A.error("Error message: " + errors[0].message);
					}
				} else {
					$A.error("Unknown error");
				}
			}
		});
		// Gets the logged in users' role so that the comment boxes can be enabled or disabled based on role name.
        helper.getloggedInUserRole(component, event);

        // populates any pre-existing 1st or 2nd line supervisor comments
        helper.populateAdHocComments(component, event, "firstLineSupComment");
        helper.populateAdHocComments(component, event, "secondLineSupComment");

		$A.enqueueAction(action);
	},
	goToAttach : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var attachEvent = $A.get("e.c:TQBCPAttachNavigator");
		attachEvent.setParams({ "candpkg": pkg });
		attachEvent.fire();
	},
	goToSummary : function(component, event) {
    var action = component.get("c.validateAdHocMinMax");
    action.setParams({
      "candidatePackageId" : component.get("v.candPackage.Id")
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
				component.set("v.messages", []);
        var pkg = component.get("v.candPackage");
    		var summaryEvent = $A.get("e.c:TQBCPSummaryNavigator");
    		summaryEvent.setParams({ "candpkg": pkg });
    		summaryEvent.fire();
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
	showEditAdHocHideList : function(component, event, helper) {
		var toggleText = component.find("adHocListView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adHocDetailView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adHocEditView"); //show
		$A.util.removeClass(toggleText,'toggle');
	},
	showAdHocDetailHideList : function(component, event, helper) {
		var toggleText = component.find("adHocListView"); //hide
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adHocDetailView"); //show
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("adHocEditView"); //hide
		$A.util.addClass(toggleText,'toggle');
	},
	createAdHocEntry : function(component, event, helper) {
		var action = component.get("c.validateAdHocMax");
    action.setParams({
      "candidatePackageId" : component.get("v.candPackage.Id")
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
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
				var evt = $A.get("e.c:TQBCPNewAdHoc");
				evt.setParams({ "candpkg": pkg, "adhocNew": adhocentryVar });
				evt.fire();
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

	 // Developer: Chris Alley
    //save the comment from the list of attachments screen
   // saveCommentServer params String Comment, String Comment_Type, Id TQB_Candidate_Package_ID
    saveAdHocCommentFirstLine : function(component, event, helper) {
       console.log('In TQBCPWizardAdHocController : saveAdHocCommentFirstLine START');
       var action = component.get("c.saveAdHocCommentServer");
       console.log("In TQBCPWizardAdHocController : saveCommentFirstLine : Comment= ");
       var firstCommentValue = component.get('v.firstLineSupAdHocComment');
       console.log(firstCommentValue);
        action.setParams({
            "Comment": firstCommentValue,
            "Comment_Type" : "firstLineSupComment", //do not change, this is hard coded in apex server method
            "TQB_Candidate_Package_ID": component.get("v.candPackage.Id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            helper.validationMessageComment(component, event, state);
        });

        $A.enqueueAction(action);
    },


    // Developer: Chris Alley
    //save the comment from the list of attachments screen
   // saveCommentServer params String Comment, String Comment_Type, Id TQB_Candidate_Package_ID
    saveAdHocCommentSecondLine : function(component, event, helper) {
      console.log('In TQBCPWizardAdHocController : saveCommentSecondLine START');
      var action = component.get("c.saveAdHocCommentServer");
      console.log("In TQBCPWizardAdHocController : saveCommentFirstLine : Comment= ");
      var secondCommentValue = component.get('v.secondLineSupAdHocComment');
      console.log(secondCommentValue);
        action.setParams({
            "Comment": secondCommentValue,
            "Comment_Type" : "secondLineSupComment", //do not change, this is hard coded in apex server method
            "TQB_Candidate_Package_ID": component.get("v.candPackage.Id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            helper.validationMessageComment(component, event, state);
        });

        $A.enqueueAction(action);
    },

})