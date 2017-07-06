({

 
  populateInitMethods : function(component, event, helper) {
        var pkg = event.getParam("candpkg");
        component.set("v.candPackage",pkg);
        var attachId = event.getParam("candAttachedDocId");
        component.set("v.candAttachedDocId",attachId);
       // var attachName = event.getParam("candAttachedDocName");
       // component.set("v.candAttachedDocName",attachName);
      //  var attachType = event.getParam("candAttachedDocType");
        //component.set("v.candAttachedDocType",attachType);                
        
        console.log('================================');
        console.log('TQBCPWizardaddattachComment : populateInitMethods : candpkg Id = ' + pkg.Id);
        console.log('TQBCPWizardaddattachComment : populateInitMethods : attachment ID= ' + attachId);
       // console.log('TQBCPWizardaddattachComment : populateInitMethods : attachName = ' + attachName);
       // console.log('TQBCPWizardaddattachComment : populateInitMethods : attachType  = ' + attachType);        
        console.log('================================');
        //helper.showHideAddAttachComments(component, event);

        helper.getloggedInUserRole(component, event);
        helper.populateAttachComments(component, event, 'firstLineSupComment', attachId);
        helper.populateAttachComments(component, event, 'secondLineSupComment', attachId);
    },

  backToAttachView : function(component, event, helper) {
        component.set("v.isOpen", false);
        var pkg = component.get("v.candPackage");
        var attachEvent = $A.get("e.c:TQBCPAttachNavigator");
        attachEvent.setParams({ "candpkg": pkg });
        attachEvent.fire();

        var toggleText = component.find("ListAttachmentView"); //show list of attachments
        $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("addAttachCommentView"); //hide attach comment view
        $A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("addAttachmentView"); //hide file upload view
        $A.util.addClass(toggleText,'toggle');


  },

    // Developer: Chris Alley
    //save the comment from the list of attachments screen
   // saveCommentServer params String Comment, String Comment_Type, Id TQB_Candidate_Package_ID
    saveAttachCommentFirstLine : function(component, event) {
      console.log('In TQBCPWizardaddattachComment : saveCommentFirstLine START');
      var action = component.get("c.saveAttachCommentServer");
      var firstCommentValue = component.get('v.firstLineSupComment');
      console.log("In TQBCPWizardaddattachComment : saveCommentFirstLine : Comment= " + firstCommentValue);
      var attachId = component.get('v.candAttachedDocId');
      console.log("In TQBCPWizardaddattachComment : saveCommentFirstLine : attachId= " + attachId);
      //set the parameters to be passed in to the server side controller
        action.setParams({
            "Comment": firstCommentValue,
            "Comment_Type" : "firstLineSupComment",
            "TQB_Candidate_Package_ID": component.get("v.candPackage.Id"),
            "attachId" : attachId

        });
      //Error handling and messaging to the user interface so users know if the comment was saved
      //successfully.
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
            "value" : "Your attachment comments have been saved successfully."
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
          //$A.error("Unknown error"); DEPRACATED
        }
      }
    });


        $A.enqueueAction(action);
        component.set("v.isOpen", false);

    },


    // Developer: Chris Alley
    //save the comment from the list of attachments screen
   // saveCommentServer params String Comment, String Comment_Type, Id TQB_Candidate_Package_ID
    saveAttachCommentSecondLine : function(component, event) {
      console.log('In TQBCPWizardaddattachComment : saveCommentSecondLine START');
      var action = component.get("c.saveAttachCommentServer");
      console.log("In TQBCPWizardaddattachComment : saveCommentSecondLine : Comment= ");
      var secondCommentValue = component.get('v.secondLineSupComment');
      console.log(secondCommentValue);
      var attachId = component.get("v.candAttachedDocId");
        //set the parameters to be passed in to the server side controller
        action.setParams({
            "Comment": secondCommentValue,
            "Comment_Type" : "secondLineSupComment",
            "TQB_Candidate_Package_ID": component.get("v.candPackage.Id"),
            "attachId" : attachId

        });
      //Error handling and messaging to the user interface so users know if the comment was saved
      //successfully.
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
            "value" : "Your attachment comments have been saved successfully."
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
          //$A.error("Unknown error"); DEPRACATED
        }
      }
    });
      $A.enqueueAction(action);
      component.set("v.isOpen", false);
   

    },



})