//
// Author: Chris Alley
// Purpose: Lightning Component controller for displaying the user controls and information necessary
// to attach files associated with the candidates promotion package.
//
({




    populateInitMethods : function(component, event, helper) {
       // helper.enableDisableCommentFieldByRole(component, event);
       //helper.insertComment(component, event, Comment_Type);
       //helper.getUsersRole(component, event);

        //get the candpkg object value from the event that fired to
        // run this method
       var selected = event.getParam("candpkg");
       component.set("v.candPackage",selected);

        // fire a new event using the value obtained above.
        var evt = $A.get("e.c:TQBCPFileControllerEvent");
        evt.setParams({ "candpkg": selected });
        evt.fire();

    },


    waiting: function(component, event, helper) {
    	$A.util.addClass(component.find("uploading").getElement(), "uploading");
    	$A.util.removeClass(component.find("uploading").getElement(), "notUploading");
    },

    doneWaiting: function(component, event, helper) {
    	$A.util.removeClass(component.find("uploading").getElement(), "uploading");
    	$A.util.addClass(component.find("uploading").getElement(), "notUploading");
    },

    showHideAddAttachment : function(component, event, helper) {
        var toggleText = component.find("ListAttachmentView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("addAttachmentView");
		$A.util.removeClass(toggleText,'toggle');
    },

  	populateAttach : function(component, event) {
        var toggleText = component.find("ListAttachmentView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("addAttachmentView");
		$A.util.addClass(toggleText,'toggle');

        var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
        console.log('selected value');
        console.log(selected);
		var action = component.get("c.getCPAttachmentsServer");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id"),
      "role" : "candidate"
		});
        action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
                console.log('response values');
                console.log(response.getReturnValue());
				component.set("v.candAttachedDocs", response.getReturnValue());
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
    }
})