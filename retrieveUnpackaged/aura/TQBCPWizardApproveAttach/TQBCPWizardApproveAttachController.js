({
    doInit : function(component, event, helper) {
        helper.showHideAddAttachment(component, event);
        /*helper.hideSupComments(component, event);
        helper.populateCandidatePackage(component, event);
        helper.populateCandidateLOI(component, event);
        helper.populateAttachments(component, event);*/
    },

    addNewAttachment : function(component, event, helper) {

        var pkg = component.get("v.candPackage");
        var evt = $A.get("e.c:TQBCPNewAttachment");
        evt.setParams({ "candpkg": pkg });
        evt.fire();
	},

    // View the attachment.
    viewAttachment : function(component, event, helper) {
        helper.viewAttachment(component, event);
    },


    // Deletes the attachment.
    deleteAttachment : function(component, event, helper) {
        helper.deleteAttachment(component, event);
    },

    showHideAddAttachment : function(component, event, helper) {
        var toggleText = component.find("ListAttachmentView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("addAttachmentView");
		$A.util.removeClass(toggleText,'toggle');
    },



    populateCandidatePackage : function(component, event) {
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
        helper.populateAttachments(component, event);
    },

    save : function(component, event, helper) {
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
		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPAdHocNavigator");
    evt.setParams({ "candpkg": pkg });
		evt.fire();
	}
})