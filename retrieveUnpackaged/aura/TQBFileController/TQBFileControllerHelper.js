//
// Developer: Chris Alley
// Purpose: TQB CP Wizard Attachments Page
//
// TESTING SUBMLIME SAVE 2
//
// Purpose: File upload controller helper.
//
({

  // Developer: Chris Alley
  // populate pre-existing comments on the CP wizard attachment screen
  populateAttachComments : function(component, event, SupervisorType) {
    //var Id = event.target.id;
    var selected = event.getParam("candpkg");
    component.set("v.candPackage",selected);
    var action = component.get("c.populateAttachCommentsServer");
    console.log ("TQBFileControllerHelper : populateAttachComments : TQB_Candidate_Package_ID = " + component.get("v.candPackage.Id"));
    console.log ("TQBFileControllerHelper : populateAttachComments : SupervisorType = " + SupervisorType);
    action.setParams({
     "candPkgId": component.get("v.candPackage.Id"),
      "SupervisorType" : SupervisorType
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
          console.log ("TQBFileControllerHelper : populateAttachComments : firstLineSupComment=response.getReturnValue() = " + response.getReturnValue());
            }
        else {
          // strip out html tags from the server side return value
          var htmlComment = response.getReturnValue();
          var div = document.createElement("div");
          div.innerHTML = htmlComment;
          component.set("v.secondLineSupComment", div.innerText);
          console.log ("TQBFileControllerHelper : populateAttachComments : secondLineSupComment=response.getReturnValue() = " + response.getReturnValue());

        }
        //component.set("v.firstLineSupComment.First_Line_Sup_Attach_Comment__c", "TESTING COMMENT PRE-POPULATION");
      } else if (state === "ERROR") {
           alert('TQBFileControllerHelper : populateAttachComments : ERROR getting response from populateAttachCommentsServer cp Id = ' + component.get("v.candPackage.Id"));
         console.log ("TQBFileControllerHelper : populateAttachComments :firstLineSupComment=  response.getReturnValue() after server call = " +  component.get("v.candPackage.Id"));
        console.log ("TQBFileControllerHelper : populateAttachComments : SupervisorType after server call = " + SupervisorType);
      }
    });

    $A.enqueueAction(action);
  },
  // end populateAttachComments




  // Chris Alley delete candidate attachment
  deleteAttachment: function(component, event) {
    var Id = event.target.id;
    var action = component.get("c.deleteCPAttachment");
    action.setParams({
      "candPkgId": component.get("v.candPackage.Id"),
      attachId : Id
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var evt = $A.get("e.c:TQBCPAttachNavigator");
        evt.setParams({ "candpkg": component.get("v.candPackage")});
        evt.fire();
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

    $A.enqueueAction(action);
  },

  getAttachment: function(component, event) {
    var attachmentId = component.get("v.candAttachedDocId");
    var action = component.get("c.getCPAttachmentById"); 
    action.setParams({
      attachmentId : attachmentId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        console.log('getAttachment Attachment ='+response.getReturnValue());
        component.set("v.candAttachedDocName", response.getReturnValue().Name);
        component.set("v.candAttachedDocType", response.getReturnValue().Description);
      }
    });

    $A.enqueueAction(action);
  },



  showHideAddAttachment : function(component, event) {
    var toggleText = component.find("ListAttachmentView"); //displays the list attachment view
    $A.util.removeClass(toggleText,'toggle');
    var toggleText = component.find("addAttachCommentView"); //hides the add attachment view
    $A.util.addClass(toggleText,'toggle');
    var toggleText = component.find("addAttachmentView"); //hides the add attachment view
    $A.util.addClass(toggleText,'toggle');
  },

  getloggedInUserRole : function(component, event) {
    var action = component.get("c.getUserRole"); // method in the apex class
    action.setCallback(this, function(a) {
      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
      // component.set("v.loggedInUserRole.UserRole.Name", "TQB 1st Line Supervisor Role"); // variable in the component



      console.log ("TQBFileControllerHelper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
    });


    $A.enqueueAction(action);
  },

  populateCandidatePackage : function(component, event) {
    var action = component.get("c.getCandidatePackage");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        component.set("v.candPackage", response.getReturnValue());
      console.log ("TQBFileControllerHelper : populateCandidatePackage response.getReturnValue() after server call = " + response.getReturnValue());
      } else if (state === "ERROR") {
       alert('TQBFileControllerHelper : populateCandidatePackage : ERROR returnd from Apex server getCandidatePackage');
      console.log ("TQBFileControllerHelper : populateCandidatePackage response.getReturnValue() after server call = " + response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  },

  populateCandidateLOI : function(component, event) {
    var action = component.get("c.getCandidateLOI");
    action.setParams({
      "candPkgId": component.get("v.candPackage.Id")
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        component.set("v.candLOI", response.getReturnValue());
        console.log ("TQBFileControllerHelper : populateCandidatePackage response.getReturnValue() after server call = " + response.getReturnValue());

         } else if (state === "ERROR") {
       alert('TQBFileControllerHelper : populateCandidatePackage : ERROR returnd from Apex server getCandidatePackage');
      console.log ("TQBFileControllerHelper : populateCandidatePackage response.getReturnValue() after server call = " + response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  },



  populateAttachments : function(component, event) {
    var toggleText = component.find("ListAttachmentView");
    $A.util.removeClass(toggleText,'toggle');
    var toggleText = component.find("addAttachmentView");
    $A.util.addClass(toggleText,'toggle');

    var selected = event.getParam("candpkg");
    component.set("v.candPackage",selected);
    //console.log('TQBFileControllerHelper : populateAttachments: selected value');
    console.log('populateAttachments: cp id = ' + component.get("v.candPackage.Id"));
    var action = component.get("c.getCPAttachmentsServer");
    action.setParams({
      "candPkgId": component.get("v.candPackage.Id"),
      "role" : "candidate"
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        component.set("v.candAttachedDoc", response.getReturnValue());
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
    $A.enqueueAction(action);
  },



})