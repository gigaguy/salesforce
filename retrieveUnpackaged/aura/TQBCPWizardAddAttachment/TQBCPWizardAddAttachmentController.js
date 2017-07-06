// Developer: Chris Alley
// Purpose: TQBCPWizardAttach - sub component to allow user to add
// attachments and stay on same page.
({
    doInit : function(component, event, helper) {
        //helper.hideSupComments(component, event, helper);        
        helper.populateCandidatePackage(component, event);
       // helper.populateCandidateLOI(component, event);
        helper.populatePackageAttachmentTypes(component, event);
    },
    
    createAddAttachment : function(component, event, helper) {
        var pkg = component.get("v.candPackage");
        var selectedContentType = component.find("InputSelectDynamic").get("v.value");
        var evt = $A.get("e.c:TQBCPNewAttachment");
        evt.setParams({ "candpkg": pkg });
        evt.fire();
    },
    
    save : function(component, event, helper) {
        console.log("INFO - TQBCPWizardAddAttachmentController : save : START");
        helper.save(component, event);
    },
    
    showHideAddAttachment : function(component, event, helper) {
         console.log("INFO - TQBCPWizardAddAttachmentController : showHideAddAttachment : START");

        var toggleText = component.find("ListAttachmentView"); //hide the attachment list
        $A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("addAttachmentView"); //display add attachment view
        $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("addAttachCommentView"); //hide add attach commment view
        $A.util.addClass(toggleText,'toggle');

    },

    goToAttach : function(component, event, helper) {
        var toggleText = component.find("addAttachmentView"); //display add attachment view
        $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("addAttachCommentView"); //hide add attach commment view
        $A.util.addClass(toggleText,'toggle');

/*
        console.log("INFO - TQBCPWizardAddAttachmentController : showHideAddAttachment : firing TQBCPAttachNavigator event");

         var evt = $A.get("e.c:TQBCPAttachNavigator");
		 evt.setParams({ "candpkg": component.get("v.candPackage")});
		 evt.fire();

*/

    }
    
})