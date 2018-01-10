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
        helper.getFandP_Forms(component);
    },
    openModal: function(component, event, helper) {
       	console.log('They pressed the new button');
        var formID = event.currentTarget.id;
        var formName = event.currentTarget.name;
        console.log('The formName is = ' + formName);
        component.set("v.formOption", null); 
        if(formName != undefined && formName =='Purchase Card'){            
            formID = formName;// can not depend on 
	        console.log('formName '+formName);
            component.set("v.backupFormId",formID);
            component.set("v.backUpFormName",formName);            
            component.set("v.forceSelectFormOption",true);            
        }else{            
			helper.openFormModal(component, event,formID,formName,'');            
        }  
        
    },
    viewFormJS : function(component, event, helper){        
        var formID = event.currentTarget.id;
        var formName = event.currentTarget.name;        
        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "BAP_Admins@epa.gov";
        }
        else if (formName === "Purchase Card") {
            var hrefInfo = "mailto:Creed.Suzette@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "Creed.Suzette@epa.gov";
        }
        else {
            var hrefInfo = "mailto:McNeal.Detha@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
       	 	var hrefEmail = "McNeal.Detha@epa.gov";
        }
        component.set("v.viewFormID", formID);
        component.set("v.modalName", "viewForm");
        component.set("v.selectedFormName", formName);
        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);

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
        
        component.set("v.isSaveFired", true);
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
        helper.saveAndSubmit(component, event);
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
        component.set("v.backupFormId ", null);        
        component.set("v.newFormId", null);
        component.set("v.formOption", null); 
        component.set("v.trainingPageMode", "showRecords");
    },
	handleSaveSuccess : function(component, event, helper){
        var isSaveFired = component.get("v.isSaveFired");
        if(isSaveFired){
			console.log('Forms handleSaveSuccess Done.');
			component.set("v.isOpen", false);
    	    component.set("v.modalName", "");
			component.set("v.message", "Your Form was saved");
	        component.set("v.backupFormId",null); 
            component.set("v.newFormId", null);
            component.set("v.formOption", null); 
        }
		component.set("v.isSaveFired",false);        
	},
    cancelCreationModal : function(component, event, helper){
    	component.set("v.message", null);
        component.set("v.approvalSuccess", null);
        component.set("v.isOpen", false);
        component.set("v.modalName", "");
    	component.set("v.backupFormId",null);
        component.set("v.isSaveFired",false);
        component.set("v.newFormId", null);
        component.set("v.formOption", null); 
        component.set("v.trainingPageMode", "showRecords");
        
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
        component.set("v.isSaveFired",false);
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
                component.set("v.backupFormId",null);
                component.set("v.newFormId", null);
                component.set("v.trainingPageMode", "showRecords");
            }
            else if(state === 'ERROR'){
                component.set("v.backupFormId",null);
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
	confirmSubmit : function(component, event) {
		var resp = confirm("Are you sure you want to submit the form?");
        var action;
        var formID;
        if (component.get("v.modalName") == 'viewForm') {
            formID = component.get("v.viewFormID");
        }
        else {
            formID = component.get("v.newForm.Id");
        }
        
        if(resp === true){
            action = component.get("c.saveAndSubmit");
            action.setParams({
            "formID": formID,
        });
        	}
        else {action = component.get("c.viewFormJS");
            action.setParams({"formID": formID,});                       
        }
        $A.enqueueAction(action);
	},
    confirmDelete : function(component, event) {
		var resp = confirm("Are you sure you want to delete the form?");
        var action;
        var formID;
        if (component.get("v.modalName") == 'viewForm') {
            formID = component.get("v.viewFormID");
        }
        else {
            formID = component.get("v.newForm.Id");
        }
        
        if(resp === true){
            action = component.get("c.deleteFormJS");
            action.setParams({
            "formID": formID,
        });
        	}
        else {action = component.get("c.viewFormJS");
            action.setParams({"formID": formID,});                       
        }
        $A.enqueueAction(action);
	},
    handleFormSelEvent : function(component, event, helper) {
        console.log('handleFormSelEvent');
        component.set("v.forceSelectFormOption",false);
        var isCancelled = event.getParam("isCancelled");
        var formOption = event.getParam("formOption");
        if(isCancelled){
        	component.set("v.backupFormId",null);
            component.set("v.formOption", null); 
        }else{
			var formId = component.get("v.backupFormId");
	        var formName = component.get("v.backUpFormName");
            //helper.getFormIntroduction(component, event,formOption);
            console.log('This is were it was called');
    	    helper.openFormModal(component, event,formId,formName,formOption);            
        }                
    },
    viewMyTrainingForms: function(component, event, helper) {
        component.set("v.trainingPageMode", "showRecords");
        component.set("v.pageStatus", "viewMyTrainings");                
    },
    addTrainingRecords: function(component, event, helper) {

        document.getElementById('newFrmDiv').hidden = "hidden";
        component.set("v.trainingPageMode", "newPurchaseCard");
        component.set("v.pageStatus", "viewMyTrainings");        
        console.log('== '+component.get("v.trainingPageMode"));
    },
	handleTrainingBackEvent: function(component, event, helper) {
        
        var newFormDiv = document.getElementById('newFrmDiv');
        if(newFormDiv!=undefined){
			newFormDiv.hidden = "";            
        }        
        var sourceCmpUniqueId = event.getParam("sourceCmpUniqueId");
        
        component.set("v.trainingPageMode", null);
        component.set("v.pageStatus", null);
        
        if(sourceCmpUniqueId=='newPCTraingRecSuccess'){
            // Now save main form            
            helper.saveAndSubmit(component, event);
        }
        component.set("v.pageStatus", "viewFormTypes");
    }
})