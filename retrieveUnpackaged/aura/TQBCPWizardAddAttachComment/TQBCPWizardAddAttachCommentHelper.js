({

  // Developer: Chris Alley
  // populate pre-existing comments on the CP wizard attachment screen
  populateAttachComments : function(component, event, SupervisorType, attachId) {
    //var Id = event.target.id;
    var selected = event.getParam("candpkg");
    component.set("v.candPackage",selected);
    var action = component.get("c.populateAttachCommentsServer");
    console.log ("TQBCPWizardAddAttachCommentHelper : populateAttachComments : TQB_Candidate_Package_ID = " + component.get("v.candPackage.Id"));
    console.log ("TQBCPWizardAddAttachCommentHelper : populateAttachComments : SupervisorType = " + SupervisorType);
    console.log ("TQBCPWizardAddAttachCommentHelper : populateAttachComments : attachId = " + attachId);
     console.log ("TQBCPWizardAddAttachCommentHelper : value returned from apex server class populateAttachCommentsServer : action = " + action);
    action.setParams({
     "candPkgId": component.get("v.candPackage.Id"),
      "SupervisorType" : SupervisorType,
      "attachId" : attachId
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        // component.find("firstLineSupComment");
        if ( SupervisorType == 'firstLineSupComment'){

          // strip out html tags from the server side return value
          var htmlComment = response.getReturnValue();
          var div = document.createElement("div");
          div.innerHTML = htmlComment;
          component.set("v.firstLineSupComment", div.innerText);
          console.log ("TQBCPWizardAddAttachCommentHelper : populateAttachComments : firstLineSupComment=response.getReturnValue() = " + response.getReturnValue());
            }
        else {
          // strip out html tags from the server side return value
          var htmlComment = response.getReturnValue();
          var div = document.createElement("div");
          div.innerHTML = htmlComment;
          component.set("v.secondLineSupComment", div.innerText);
          console.log ("TQBCPWizardAddAttachCommentHelper : populateAttachComments : secondLineSupComment=response.getReturnValue() = " + response.getReturnValue());
                     
        }
        //component.set("v.firstLineSupComment.First_Line_Sup_Attach_Comment__c", "TESTING COMMENT PRE-POPULATION");
      } else if (state === "ERROR") {
           alert('TQBCPWizardAddAttachCommentHelper : populateAttachComments : ERROR getting response from populateAttachCommentsServer cp Id = ' + component.get("v.candPackage.Id"));
         console.log ("TQBCPWizardAddAttachCommentHelper : populateAttachComments :firstLineSupComment=  response.getReturnValue() after server call = " +  component.get("v.candPackage.Id"));
        console.log ("TQBCPWizardAddAttachCommentHelper : populateAttachComments : SupervisorType after server call = " + SupervisorType);
      }
    });

    $A.enqueueAction(action);
  },
  // end populateAttachComments 

    showHideAddAttachComments : function(component, event) {
        var toggleText = component.find("ListAttachmentView"); //show list of attachments
		    $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("addAttachCommentView"); //display attach comment view
        $A.util.removeClass(toggleText,'toggle');
		    var toggleText = component.find("addAttachmentView"); //hide file upload view
		    $A.util.addClass(toggleText,'toggle');
    },

  getloggedInUserRole : function(component, event) {
    var action = component.get("c.getUserRole"); // method in the apex class
    action.setCallback(this, function(a) {
    component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
    console.log('=======================================================');
    console.log ("TQBCPWizardAddAttachCommentHelper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
    console.log('=======================================================');
    });
    $A.enqueueAction(action);
  },

    backToAttachView : function(component, event) {
       
        component.set("v.isOpen", false);
 /*       var pkg = component.get("v.candPackage");
        var attachEvent = $A.get("e.c:TQBCPAttachNavigator");
        attachEvent.setParams({ "candpkg": pkg });
        attachEvent.fire();

        var toggleText = component.find("ListAttachmentView"); //show list of attachments
        $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("addAttachCommentView"); //hide attach comment view
        $A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("addAttachmentView"); //hide file upload view
        $A.util.addClass(toggleText,'toggle');

*/
  },

})