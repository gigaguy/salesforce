({
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

       // Chris Alley view candidate attachment
        viewAttachment: function(component, event) {
            var Id = event.target.id;
            var action = component.get("c.viewCPAttachment");
            action.setParams({
                "candPkgId": component.get("v.candPackage.Id"),
                 attachId : Id
            });
            $A.enqueueAction(action);

        },

    showHideAddAttachment : function(component, event) {
      var toggleText = component.find("ListAttachmentView"); //displays the list attachment view
      $A.util.removeClass(toggleText,'toggle');
      var toggleText = component.find("addAttachmentView"); //hides the add attachment view
      $A.util.addClass(toggleText,'toggle');
  },

    hideSupComments : function(component, event) {
      var toggleText = component.find("1stLineComment");
      $A.util.removeClass(toggleText,'toggle');
      var toggleText = component.find("2ndLineComment");
      $A.util.removeClass(toggleText,'toggle');
  },

	populateCandidatePackage : function(component, event) {
       var action = component.get("c.getCandidatePackage");
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (component.isValid() && state === "SUCCESS") {
               component.set("v.candPackage", response.getReturnValue());
                var evt = $A.get("e.c:TQBCPAttachNavigator");
				evt.setParams({ "candpkg": component.get("v.candPackage")});
				evt.fire();
           }
       });
       $A.enqueueAction(action);
	},

    populateCandidateLOI : function(component, event) {
       var action = component.get("c.getCandidateLOI");
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (component.isValid() && state === "SUCCESS") {
               component.set("v.candLOI", response.getReturnValue());
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
       // console.log(selected);
		var action = component.get("c.getCPAttachmentsServer");
		action.setParams({
			"candPkgId": component.get("v.candPackage.Id"),
      "role" : "reviewer"
		});
        action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
                //console.log('TQBFileControllerHelper: populateAttachments: response values');
                //console.log(response.getReturnValue());
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