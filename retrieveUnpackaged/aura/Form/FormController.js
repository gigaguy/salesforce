({
    doInit : function(component, event, helper) {        
        var action = component.get("c.getFormRTs");
        action.setParams({
			"sID" : component.get("v.sessionID"),
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.forms", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
    },
    openModal: function(component, event, helper) {
        var formID = event.currentTarget.id;
        component.set("v.selectedFormId", formID);
        
		var action = component.get("c.insertNewForms");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "rtID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.newForm", resp.getReturnValue());
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    viewFormJS : function(component, event, helper){
        var formID = event.currentTarget.id;
        component.set("v.viewFormID", formID);
        component.set("v.modalName", "viewForm");
        
        var action = component.get("c.viewForm");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "formID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.oldForm", resp.getReturnValue());
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    viewExistingForms : function(component, event, helper){
        var formID = event.currentTarget.id;
        component.set("v.selectedFormId", formID);
        
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "rtID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.oldForms", resp.getReturnValue());
                component.set("v.modalName", "listModal");
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleSave : function(component, event, helper){
		//component.set("v.isOpen", false);
        //component.set("v.modalName", "");
		//component.set("v.message", "THIS FIRED");
		
	},
    saveOnly : function(component, event, helper){
        console.log('in c.saveOnly');
          try {
            component.find("edit").get("e.recordSave").fire();
              console.log('no error');
          }
          catch (e) {
            console.log(e);
          }
        
        /*component.find("edit").recordSave($A.getCallback(function(saveResult) {
            // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
            // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
                console.log("Save Successful");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));*/
        

        // Needed to update display of forms, sets display to "viewMyForms" for feedback to user that it was saved
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.oldForms", resp.getReturnValue());
                component.set("v.pageStatus", "viewMyForms");
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
	saveAndSubmit : function(component, event, helper){
        component.find("edit").get("e.recordSave").fire();
        component.set("v.isOpen2", false);
        
        // Temporary checking for modals to allow submitting from new form or view form
        var formID;
        if (component.get("v.modalName") == 'viewForm') {
            formID = component.get("v.viewFormID");
        }
        else {
            formID = component.get("v.newForm.Id");
        }
        
        var action = component.get("c.submitForApproval");
        action.setParams({
            "formID": formID,
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.message", resp.getReturnValue());
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
        // Needed to update display of forms, sets display to "viewMyForms" for feedback to user that it was submitted
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.oldForms", resp.getReturnValue());
                component.set("v.pageStatus", "viewMyForms");
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
	},
	openModal2: function(component, event, helper) {
        component.set("v.isOpen", true);
        component.set("v.modalName", "");
    },
    closeModal: function(component, event, helper) {
        component.set("v.message", null);
        component.set("v.approvalSuccess", null);
        component.set("v.isOpen", false);
        component.set("v.modalName", "");
    },
	handleSaveSuccess : function(component, event, helper){
		component.set("v.isOpen", false);
        component.set("v.modalName", "");
		component.set("v.message", "Your Form was saved");
	},
    cancelCreationModal : function(component, event, helper){
    	component.set("v.message", null);
        component.set("v.approvalSuccess", null);
        component.set("v.isOpen", false);
        component.set("v.modalName", "");
    	
        var action = component.get("c.deleteForm");
        action.setParams({
            "formID":component.get("v.newForm.Id"),
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.message", '');
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
	},
    deleteFormJS : function(component, event, helper){
    	var formID = component.get("v.viewFormID");
        console.log(formID);
		var action = component.get("c.deleteForm");
        action.setParams({
            "formID":formID,
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.message", resp.getReturnValue());
                component.set("v.oldForm", null);
                component.set("v.modalName", "");
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        // Needed to update display of forms
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.oldForms", resp.getReturnValue());
                component.set("v.pageStatus", "viewMyForms");
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
	}, 
    viewMyForms : function(component, event, helper){
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.oldForms", resp.getReturnValue());
                component.set("v.message", null);
                component.set("v.pageStatus", "viewMyForms");
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
	},
    viewFormTypes : function(component, event, helper){
        component.set("v.message", null);
		component.set("v.pageStatus", "viewFormTypes");
	},
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen2", true);
      component.set("v.isOpen", false);  
   },
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      //component.find("edit").get("e.recordSave").fire();
       
       component.set("v.isOpen2", false);
       component.set("v.isOpen", true);
       
       /* var formID;
        if (component.get("v.modalName") == 'viewForm') {
            formID = component.get("v.viewFormID");
        }
        else {
            formID = component.get("v.newForm.Id");
        }
        component.set("v.viewFormID", formID);
        component.set("v.modalName", "viewForm");
        
        var action = component.get("c.viewForm");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "formID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.oldForm", resp.getReturnValue());
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action); */
   }
	
})