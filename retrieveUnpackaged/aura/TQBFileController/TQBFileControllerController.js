//
// Developer: Chris Alley
// Purpose: File upload controller delegates the work to the helper.
//
({



   closeModal: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
      component.set("v.isOpen", false);
   },


  populateInitMethods : function(component, event, helper) {

        var selected = event.getParam("candpkg");
        component.set("v.candPackage",selected);
        console.log("INFO - TQBCPFileController : populateInitMethods : candpkg = " + selected);
        helper.showHideAddAttachment(component, event);
        //helper.populateCandidatePackage(component, event); //commented out by Chris 6/8 since
       // it was prohibiting supervisor names from displaying on attachments section of CP wizard
        helper.populateCandidateLOI(component, event);
        helper.populateAttachments(component, event);
        helper.getloggedInUserRole(component, event);
        //helper.populateAttachComments(component, event, 'firstLineSupComment');
        //helper.populateAttachComments(component, event, 'secondLineSupComment');
        component.set("v.messages", []);
    },


    addNewAttachment : function(component, event, helper) {
        var pkg = component.get("v.candPackage");
        var evt = $A.get("e.c:TQBCPNewAttachment");
        evt.setParams({ "candpkg": pkg });
        evt.fire();
	},

    addAttachmentComment : function(component, event, helper) {
        component.set("v.isOpen", true);
        var pkg = component.get("v.candPackage");
        var attachments = component.get("v.candAttachedDoc");
        var selectedItem = event.currentTarget;
        var IdP = selectedItem.dataset.record;
        
        component.set("v.candAttachedDocId", IdP);
        // get the attachment using the attached content ID so the file name and description field can be displayed on the 
        //modal pop up for adding supervisor comments.
        helper.getAttachment(component,event);

        console.log('================================');
        console.log('TQBCPFileController : addAttachmentComment : candpkg ID = ' + pkg.Id);
        console.log('TQBCPFileController : addAttachmentComment : attachments = ' + attachments);
        console.log('TQBCPFileController : addAttachmentComment :  attachId (IdP) = ' + IdP);
        console.log('================================');
        //get the attached doc ID from the event so it can be passed on to the save comment method
        var evt = $A.get("e.c:TQBCPAddAttachmentCommentEvent");
        evt.setParams({ "candpkg": pkg, "candAttachedDocId" : IdP});
        evt.fire();
        
    },


    // Deletes the attachment.
    deleteAttachment : function(component, event, helper) {
        helper.deleteAttachment(component, event);
    },

    showHideAddAttachComment : function(component, event, helper) {
                 console.log("INFO - TQBFileController : showHideAddAttachComment : START");

        var toggleText = component.find("ListAttachmentView"); //show the attachment list
        $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("addAttachmentView"); //hide add attachment view
        $A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("addAttachCommentView"); //show add attach commment view
        $A.util.removeClass(toggleText,'toggle');

    },

    showHideAddAttachment : function(component, event, helper) {
         console.log("INFO - TQBFileController : showHideAddAttachment : START");

        var toggleText = component.find("ListAttachmentView"); //hide the attachment list
		$A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("addAttachmentView"); //display add attachment view
        $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("addAttachCommentView"); //hide add attach commment view
        $A.util.addClass(toggleText,'toggle');

    },



    populateCandidatePackage : function(component, event) {
                 console.log("INFO - TQBFileController : populateCandidatePackage : START");

        var action = component.get("c.getCandidatePackage");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.candPackage", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    populateAllAttachment : function(component, event, helper) {
        console.log("INFO - TQBFileController : populateAllAttachment : START");

        helper.populateAttachments(component, event);
    },

    save : function(component, event, helper) {
        console.log("INFO - TQBFileController : save : START");
        helper.save(component, event);

    },

    waiting: function(component, event, helper) {
    	$A.util.addClass(component.find("uploading").getElement(), "uploading");
    	$A.util.removeClass(component.find("uploading").getElement(), "notUploading");
    },

    doneWaiting: function(component, event, helper) {
    	$A.util.removeClass(component.find("uploading").getElement(), "uploading");
    	$A.util.addClass(component.find("uploading").getElement(), "notUploading");
    },

    goToQuestionnaire : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPQuestionNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},

	goToAdHoc : function(component, event, helper) {
    var action = component.get("c.validateCandidateAttachments");
		action.setParams({
			"candidatePackageId" : component.get("v.candPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
        component.set("v.messages", []);
        var pkg = component.get("v.candPackage");
        var evt = $A.get("e.c:TQBCPAdHocNavigator");
        evt.setParams({ "candpkg": pkg });
        evt.fire();
			} else if (state === "ERROR") {
				var errors = response.getError();
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

	},

    // Developer: Chris Alley
    //save the comment from the list of attachments screen
   // saveCommentServer params String Comment, String Comment_Type, Id TQB_Candidate_Package_ID
    saveAttachCommentFirstLine : function(component, event) {
      console.log('In TQBFileControllerController : saveCommentFirstLine START');
      var action = component.get("c.saveAttachCommentServer");
      console.log("In TQBFileControllerController : saveCommentFirstLine : Comment= ");
      var firstCommentValue = component.get('v.firstLineSupComment');
      console.log(firstCommentValue);
        action.setParams({
            "Comment": firstCommentValue,
            "Comment_Type" : "firstLineSupComment",
            "TQB_Candidate_Package_ID": component.get("v.candPackage.Id")
        });

        $A.enqueueAction(action);
    },


    // Developer: Chris Alley
    //save the comment from the list of attachments screen
   // saveCommentServer params String Comment, String Comment_Type, Id TQB_Candidate_Package_ID
    saveAttachCommentSecondLine : function(component, event) {
      console.log('In TQBFileControllerController : saveCommentSecondLine START');
      var action = component.get("c.saveAttachCommentServer");
      console.log("In TQBFileControllerController : saveCommentSecondLine : Comment= ");
      var secondCommentValue = component.get('v.secondLineSupComment');
      console.log(secondCommentValue);
        action.setParams({
            "Comment": secondCommentValue,
            "Comment_Type" : "secondLineSupComment",
            "TQB_Candidate_Package_ID": component.get("v.candPackage.Id")
        });

        $A.enqueueAction(action);
    },
})