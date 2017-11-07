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
        var formID = event.currentTarget.id;
        var formName = event.currentTarget.name;
        
        component.set("v.message", null);
        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "BAP_Admins@epa.gov";
        }
        else if (formName === "EPA-3110-1") {
            var hrefInfo = "";
        	var hrefEmail = "David Ack";
        }
        else if (formName === "EPA-3160-6v5") {
            var hrefInfo = "";
        	var hrefEmail = "Bisa Cunningham";
        }
        else if (formName === "EPA-PCOR") {
            var hrefInfo = "";
        	var hrefEmail = "To be determined";
        }
        else if (formName === "ORD-111") {
            var hrefInfo = "https://intranet.ord.epa.gov/sites/default/files/media/qa/ORDQARFinstructions073008.pdf";
        	var hrefEmail = "ORDQARFinstructions073008.pdf";
        }
        else if (formName === "PRIAv5") {
            var hrefInfo = "";
        	var hrefEmail = "Nicole Williams, Hamaad Syed, and Patrick Dobak";
        }
        else if (formName === "SF-182") {
            var hrefInfo = "";
        	var hrefEmail = "Sharon Ridings";
        }
        else {
            var hrefInfo = "mailto:McNeal.Detha@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
       	 	var hrefEmail = "McNeal.Detha@epa.gov";
        }
        component.set("v.selectedFormId", formID);
        component.set("v.selectedFormName", formName);
        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);
        
        helper.show(component,event);
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
                component.set("v.viewFormID", component.get("v.newForm.Id"));
                helper.hide(component,event);
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                helper.hide(component,event);
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    viewFormJS : function(component, event, helper){
        console.log('in viewFormJS');
        var formID = event.currentTarget.id;
    
        console.log('formID: '+ formID);
        var formName = event.currentTarget.name;
        component.set("v.message", null);
        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "BAP_Admins@epa.gov";
        }
        else if (formName === "EPA-3110-1") {
            var hrefInfo = "";
        	var hrefEmail = "David Ack";
        }
        else if (formName === "EPA-3160-6v5") {
            var hrefInfo = "";
        	var hrefEmail = "Bisa Cunningham";
        }
        else if (formName === "EPA-PCOR") {
            var hrefInfo = "";
        	var hrefEmail = "To be determined";
        }
        else if (formName === "ORD-111") {
            var hrefInfo = "https://intranet.ord.epa.gov/sites/default/files/media/qa/ORDQARFinstructions073008.pdf";
        	var hrefEmail = "ORDQARFinstructions073008.pdf";
        }
        else if (formName === "PRIAv5") {
            var hrefInfo = "";
        	var hrefEmail = "Nicole Williams, Hamaad Syed, and Patrick Dobak";
        }
        else if (formName === "SF-182") {
            var hrefInfo = "";
        	var hrefEmail = "Sharon Ridings";
        }
        else {
            var hrefInfo = "mailto:McNeal.Detha@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
       	 	var hrefEmail = "McNeal.Detha@epa.gov";
        }
        component.set("v.viewFormID", formID);
        console.log('formID: ' + formID);
        component.set("v.modalName", "viewForm");
        component.set("v.selectedFormName", formName);
        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);
		
        helper.show(component,event);
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
                helper.hide(component,event);
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                helper.hide(component,event);
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
		console.log('in c.handleSave');
        component.find("edit").getElement().scrollIntoView();
        
	},
    saveStay : function(component, event, helper){
        console.log('in c.saveStay');
        console.log('modalname: ' + component.get("v.modalName"));
        
        try {
            if (component.get("v.modalName") != 'reopenForm'){
            	component.find("edit").get("e.recordSave").fire();
                console.log('no error');
               }
            else if (component.get("v.modalName") == 'reopenForm'){
            	component.get("v.edit2").get("e.recordSave").fire();
                console.log('no error');
               }    
   
          	}
          catch (e) {
            console.log(e);
          }
        
    },
    saveOnly : function(component, event, helper){
        console.log('in c.saveOnly');
   
        try {
            if (component.get("v.modalName") != 'reopenForm'){
            	component.find("edit").get("e.recordSave").fire();
                console.log('no error 1');
               }
            else if (component.get("v.modalName") == 'reopenForm'){
            	component.get("v.edit2").get("e.recordSave").fire();
                console.log('no error 2');
               }    
          	}
          catch (e) {
            console.log(e);
          }
        
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
        try {
            if (component.get("v.modalName") != 'reopenForm'){
            component.find("edit").get("e.recordSave").fire();
                console.log('no error 1');
     	       }
            else if (component.get("v.modalName") == 'reopenForm'){
            component.get("v.edit2").get("e.recordSave").fire();
                console.log('no error 2');
     	       }    
          	}
          catch (e) {
            console.log(e);
          }
 
        // Temporary checking for modals to allow submitting from new form or view form
        var formID;
        if (component.get("v.modalName") == 'viewForm') {
            formID = component.get("v.viewFormID"); }
        else if (component.get("v.modalName") == 'reopenForm') {
            formID = component.get("v.viewFormID"); }
        else { formID = component.get("v.newForm.Id"); }
        
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
        if(component.get("v.testing")==false){
        component.set("v.isOpen", true);
        component.set("v.modalName", "");
        }
    },
    closeModal: function(component, event, helper) {
        console.log('in closeModal');    
        	component.set("v.message", null);
            component.set("v.approvalSuccess", null);
            component.set("v.isOpen", false);
            component.set("v.modalName", "");
            component.set("v.hasAttachments", false);
            component.set("v.addAttachments", false);

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
	handleSaveSuccess : function(component, event, helper){
        console.log('in handleSaveSuccess');
        
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

            component.set("v.isOpen", false);
            component.set("v.message", "Form Saved | ");
            var a = component.get('c.createReopenModal');
        $A.enqueueAction(a);
	},
    cancelCreationModal : function(component, event, helper){
    	console.log('in cancelCreationModal'); 
        component.set("v.message", null);
        component.set("v.approvalSuccess", null);
        component.set("v.isOpen", false);
        component.set("v.modalName", "");
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
    	
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
    	component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
 
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
     onFileUploaded:function(component,event,helper){
        helper.show(component,event);
        var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.upload(component, file, content, function(answer) {
                    if (answer) {
                        helper.hide(component,event);
                        console.log('file uploaded successfully');                        
                        component.set("v.hasAttachments", true);
                        // Success
                    }
                    else{
                        // Failure
                    }
                });
            }
            reader.readAsDataURL(file);
        }
        else{            
            helper.hide(component,event);
        }
    },
    deleteAttachment : function(component, event, helper){
        var attID = event.currentTarget.id;
        console.log(attID);
		var action = component.get("c.deleteFormAttachment");
        action.setParams({
            "attID":attID
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var formID;
                if (component.get("v.modalName") == 'viewForm') { 
                    formID = component.get("v.viewFormID"); }
                else { formID = component.get("v.newForm.Id"); }
            
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.message", resp.getReturnValue());
                helper.getAttachList(component, formID);
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
	hideAttachments: function(component, event, helper) {
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
    },
	showAttachments: function(component, event, helper) {
        var formID;
                if (component.get("v.modalName") == 'viewForm') { 
                    formID = component.get("v.viewFormID"); }
                else { formID = component.get("v.newForm.Id"); }
        helper.getAttachList(component, formID);
        	component.set("v.addAttachments", true);        
   },
    createReopenModal: function(component, event, helper) {
   		console.log('in createReopenModal');
        
        var formID = component.get("v.viewFormID");
        console.log('formID: ' + formID);
		
        component.set("v.viewFormID", formID);
        helper.show(component,event);
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
                helper.hide(component,event);
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                helper.hide(component,event);
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
        
        $A.createComponent('force:recordEdit',
  {
    'aura:id': 'edit2',
    'recordId': formID
  },
  function(edit2){
    component.set('v.edit2', edit2); 
      component.set("v.modalName", "reopenForm");  
  }
                              
);
    },
	copyForm: function(component, event, helper) {
        console.log('in cloneForm');
        var formID = event.currentTarget.id;
        var formName = event.currentTarget.name;
        component.set("v.message", null);
        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "BAP_Admins@epa.gov";
        }
        else if (formName === "EPA-3110-1") {
            var hrefInfo = "";
        	var hrefEmail = "David Ack";
        }
        else if (formName === "EPA-3160-6v5") {
            var hrefInfo = "";
        	var hrefEmail = "Bisa Cunningham";
        }
        else if (formName === "EPA-PCOR") {
            var hrefInfo = "";
        	var hrefEmail = "To be determined";
        }
        else if (formName === "ORD-111") {
            var hrefInfo = "https://intranet.ord.epa.gov/sites/default/files/media/qa/ORDQARFinstructions073008.pdf";
        	var hrefEmail = "ORDQARFinstructions073008.pdf";
        }
        else if (formName === "PRIAv5") {
            var hrefInfo = "";
        	var hrefEmail = "Nicole Williams, Hamaad Syed, and Patrick Dobak";
        }
        else if (formName === "SF-182") {
            var hrefInfo = "";
        	var hrefEmail = "Sharon Ridings";
        }
        else {
            var hrefInfo = "mailto:McNeal.Detha@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
       	 	var hrefEmail = "McNeal.Detha@epa.gov";
        }
        component.set("v.selectedFormId", formID);
        component.set("v.selectedFormName", formName);
        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);
         
		var action = component.get("c.cloneForm");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "FormID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.newForm", resp.getReturnValue());
                console.log('v.newForm: ' + component.get("v.newForm"));
                component.set("v.viewFormID", component.get("v.newForm.Id"));
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
    newOpenModal: function(component, event, helper) {
        console.log('in newOpenModal');
        component.set("v.testing", true);
        var formID = event.currentTarget.id;
        console.log('formID(rt): ' + formID);
        var formName = event.currentTarget.name;
        console.log('formName: ' + formName);
        
        component.set("v.isNew", true);
        component.set("v.viewFormID", formID); 
        component.set("v.viewFormName", formName);
        
        var a = component.get("c.newCreateModal");
        $A.enqueueAction(a);
    },
    newCreateModal: function(component, event, helper) {
        console.log('in newCreateModal');
        
        var isNew = component.get("v.isNew");
        console.log('isNew: ' + isNew);
        var formID = component.get("v.viewFormID");
        console.log('formID: ' + formID);
		var formName = component.get("v.viewFormName");        
        console.log('formName: ' + formName);
        
        if (isNew==true) {
            component.set("v.message", null);
        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "BAP_Admins@epa.gov";
        }
        else if (formName === "EPA-3110-1") {
            var hrefInfo = "";
        	var hrefEmail = "David Ack";
        }
        else if (formName === "EPA-3160-6v5") {
            var hrefInfo = "";
        	var hrefEmail = "Bisa Cunningham";
        }
        else if (formName === "EPA-PCOR") {
            var hrefInfo = "";
        	var hrefEmail = "To be determined";
        }
        else if (formName === "ORD-111") {
            var hrefInfo = "https://intranet.ord.epa.gov/sites/default/files/media/qa/ORDQARFinstructions073008.pdf";
        	var hrefEmail = "ORDQARFinstructions073008.pdf";
        }
        else if (formName === "PRIAv5") {
            var hrefInfo = "";
        	var hrefEmail = "Nicole Williams, Hamaad Syed, and Patrick Dobak";
        }
        else if (formName === "SF-182") {
            var hrefInfo = "";
        	var hrefEmail = "Sharon Ridings";
        }
        else {
            var hrefInfo = "mailto:McNeal.Detha@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
       	 	var hrefEmail = "McNeal.Detha@epa.gov";
        }
        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);
        helper.show(component,event);
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
                component.set("v.viewFormID", component.get("v.newForm.Id"));
                formID = component.get("v.newForm.Id");
                console.log('formID: '+formID);
                
                $A.createComponent('force:recordEdit',
                  {
                    'aura:id': 'theModal',
                    'recordId': formID
                   },
                  function(theModal){
                    component.set('v.theModal', theModal); 
                    component.set("v.modalName", "theModal");  
                      console.log('in function - formID: '+formID);
                   }
                                              
                    );
                
                helper.hide(component,event);
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                helper.hide(component,event);
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
          }
        else {
            // combined 
          }
        component.set("v.isNew", false);
    }
    
})