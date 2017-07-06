({
    doInit : function(component, event, helper) {
         helper.hideSupComments(component, event, helper);
        //helper.populateCandidatePackage(component, event);
       // helper.populateCandidateLOI(component, event);
        helper.populatePackageAttachmentTypes(component, event);
    },

    createAddAttachment : function(component, event, helper) {
        //debugger;
        var pkg = component.get("v.candPackage");
        var selectedContentType = component.find("InputSelectDynamic").get("v.value");
        var evt = $A.get("e.c:TQBCPNewAttachment");
        evt.setParams({ "candpkg": pkg });
        evt.fire();
    },

    save : function(component, event, helper) {
        helper.save(component, event);
        // restore user screen controls after save
        var toggleText = component.find("comment"); //display add attachment view
        $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("showHideCancelSubmitApprovalButtons"); //show buttons
        $A.util.removeClass(toggleText,'toggle');

        
    },

    goToReco : function(component, event, helper) {
        //restore user controls 
        var toggleText = component.find("comment"); //display add attachment view
        $A.util.removeClass(toggleText,'toggle');
        var toggleText = component.find("showHideCancelSubmitApprovalButtons"); //show buttons
        $A.util.removeClass(toggleText,'toggle');

        

         var evt = $A.get("e.c:TQBCPRecoNavigator");
		 evt.setParams({ "candpkg": component.get("v.candPackage")});
		 evt.fire();
    }

})