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
    openModal: function(component, event, helper) { //this needs to go away
        console.log('in openModal');
        component.set("v.onSubmit", false);
        component.set("v.modalName", "newModal");
          console.log('modalName: '+component.get("v.modalName"));
        var formID = event.currentTarget.id;
        var formName = event.currentTarget.name;
        
        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);
        
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
            var hrefInfo = "mailto:OHRLeaveQuestions@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "OHRLeaveQuestions@epa.gov";
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
			console.log('in openModal action');
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
    viewFormJS : function(component, event, helper){  //this needs to go away
        console.log('in viewFormJS');
        var formID = event.currentTarget.id;
    
        console.log('formID: '+ formID);
        var formName = event.currentTarget.name;
        component.set("v.message", null);
        component.set("v.onSubmit", false);

        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "BAP_Admins@epa.gov";
        }
        else if (formName === "EPA-3110-1") {
            var hrefInfo = "";
        	var hrefEmail = "David Ack";
        }
        else if (formName === "EPA-3160-6v5") {
            var hrefInfo = "mailto:OHRLeaveQuestions@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "OHRLeaveQuestions@epa.gov";
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
          console.log('modalName: '+component.get("v.modalName"));
        component.set("v.selectedFormName", formName);
        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);
        
        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);
		
        helper.show(component,event);
        var action = component.get("c.viewForm");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "formID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in viewFormJS action');

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
        console.log('in viewExistingForms');
        
        var formID = event.currentTarget.id;
        component.set("v.selectedFormId", formID);
        
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "rtID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in viewExistingForms action');
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
        
        
        if(component.get("v.testing") == true){   //this needs to be updated
        	component.get("v.theModal").getElement().scrollIntoView(); 
          }
        else { component.find("edit").getElement().scrollIntoView(); } 
        
	},
    saveStay : function(component, event, helper){ //this needs to go away
        console.log('in c.saveStay');
        component.set("v.addAttachments", false);
        component.set("v.hasAttachments", false);
        
        console.log('modalName: '+component.get("v.modalName"));
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
    saveOnly : function(component, event, helper){   //this needs to go away
        console.log('in c.saveOnly');
   
        console.log('modalName: '+component.get("v.modalName"));
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
        
        // Update display of forms, sets display to "viewMyForms" for feedback to user that it was saved
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in saveOnly action');
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
	saveAndSubmit : function(component, event, helper){   //this needs to go away
        console.log('in saveAndSubmit');
        component.set("v.onSubmit", true);

        console.log('modalName: '+component.get("v.modalName"));
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
	},
	openModal2: function(component, event, helper) {  
        console.log('in openModal2');
        
        if(component.get("v.testing")==false){		//this needs to go away
        component.set("v.isOpen", true);			//this needs to CHANGE
        component.set("v.modalName", "newModal");
          console.log('modalName: '+component.get("v.modalName"));
        }
    },
    closeModal: function(component, event, helper) {
        console.log('in closeModal');    
           
        component.set("v.message", null);
        component.set("v.approvalSuccess", null);
        component.set("v.isOpen", false);
        component.set("v.modalName", "");
          console.log('modalName: '+component.get("v.modalName"));
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);

        // Update display of forms, sets display to "viewMyForms" for feedback to user that it was submitted
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in closeModal action');
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
        
        // Update display of forms
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in handleSaveSuccess action');
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
		
        if(component.get("v.testing")==false){
            console.log('safeSave: '+component.get("v.safeSave"));
            if(component.get("v.safeSave")!=true){
                component.set("v.isOpen", false);        //this needs to go away
                component.set("v.modalName", '');
                  console.log('modalName: '+component.get("v.modalName"));
            
            console.log('onSubmit: '+component.get("v.onSubmit"));
            if (component.get("v.onSubmit") == false){
                component.set("v.message", "Form Saved | ");
                var a = component.get('c.createReopenModal');  //this needs to CHANGE
                $A.enqueueAction(a);
              }
            else if(component.get("V.onSubmit") == true){
                    var a = component.get('c.approvalSubmit');  
                	$A.enqueueAction(a);
                }
            }
         }
        else{
            console.log('in testing mode');
            console.log('safeSave: '+component.get("v.safeSave"));
            if(component.get("v.safeSave")!=true){
                console.log('modalName: '+component.get("v.modalName"));                
            
            console.log('onSubmit: '+component.get("v.onSubmit"));
            if (component.get("v.onSubmit") == false){
                component.set("v.message", "Form Saved | ");
                component.set("v.isNew", false);
                component.set("v.isCopy", false);
                component.set("v.message", "Form Saved | ");
                
                var a = component.get('c.newCreateModal');  //this needs to CHANGE
                $A.enqueueAction(a);
              }
                else if(component.get("V.onSubmit") == true){
                    var a = component.get('c.approvalSubmit');  
                	$A.enqueueAction(a);
                }
            }
         }
        
        component.set("v.safeSave", false);
        
	},
    cancelCreationModal : function(component, event, helper){
    	console.log('in cancelCreationModal'); 
        component.set("v.message", null);
        component.set("v.approvalSuccess", null);
        component.set("v.isOpen", false);
        component.set("v.modalName", "");
          console.log('modalName: '+component.get("v.modalName"));
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
    	
        var action = component.get("c.deleteForm");
        action.setParams({
            "formID":component.get("v.newForm.Id"),
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in cancelCreationModal action');
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
    	console.log('in deleteFormJS');
        
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
			console.log('in deleteFormJS action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.message", resp.getReturnValue());
                component.set("v.oldForm", null);
                component.set("v.modalName", "");
                  console.log('modalName: '+component.get("v.modalName"));
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
        
        // Update display of forms
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in deleteFormJS action2');
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
        console.log('in viewMyForms');
        
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in viewMyForms action');
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
        console.log('in viewFormTypes');
        
        component.set("v.message", null);
		component.set("v.pageStatus", "viewFormTypes");
	},
	confirmSubmit : function(component, event) {
        console.log('in confirmSubmit');
        
		var resp = confirm("Are you sure you want to submit the form?");
        
        if(component.get("v.testing")!=true){
        var action;
        var formID;
      
        console.log('modalName: '+component.get("v.modalName"));
        if (component.get("v.modalName") == 'viewForm' || component.get("v.modalName") == 'reopenForm') {   //this needs to go away
            formID = component.get("v.viewFormID");
        }
        else {												//this needs to go away
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
        }
        else {
            if(resp === true){
                var a = component.get("c.newSaveAndSubmit");
                $A.enqueueAction(a);
            }
        }
	},
    confirmDelete : function(component, event) {
        console.log('in confirmDelete');
        
		var resp = confirm("Are you sure you want to delete the form?");
        var action;
        var formID;
        
        console.log('modalName: '+component.get("v.modalName"));
        if (component.get("v.modalName") == 'viewForm' || component.get("v.modalName") == 'reopenForm') {		//this needs to go away
            formID = component.get("v.viewFormID");
        }
        else {													//this needs to go away
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
    deleteAttachment : function(component, event, helper){
        console.log('in deleteAttachment');
        
        var attID = event.currentTarget.id;
        console.log('attID: '+attID);
		var action = component.get("c.deleteFormAttachment");
        action.setParams({
            "attID":attID
        });
        action.setCallback(this,function(resp){
			console.log('in deleteAttachment action');
            var formID;
            console.log('modalName: '+component.get("v.modalName"))
                if (component.get("v.modalName") == 'viewForm' || component.get("v.modalName") == 'reopenForm') { 
                    formID = component.get("v.viewFormID"); }
                else { formID = component.get("v.newForm.Id"); }
            console.log('formID: '+formID);
            
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
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
        console.log('in hideAttachments');
        
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);
        
    },
	showAttachments: function(component, event, helper) {
        console.log('in showAttachments');
        
        var formID;
        console.log('modalName: '+component.get("v.modalName"));
            if (component.get("v.modalName") == 'viewForm' || component.get("v.modalName") == 'reopenForm' || component.get("v.modalName") == 'theModal') { 		//this needs to go away
                formID = component.get("v.viewFormID"); }
            else { formID = component.get("v.newForm.Id"); }		//this needs to go away
        
        console.log('formID: ' + formID);
        
        helper.getAttachList(component, formID);
        	component.set("v.addAttachments", true); 
     	var a = component.get("c.createAttachComp");
        $A.enqueueAction(a);
        
   },
    createReopenModal: function(component, event, helper) {            //this needs to go away
   		console.log('in createReopenModal');
        
        var formID = component.get("v.viewFormID");
        console.log('formID: ' + formID);

        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);
        component.set("v.onSubmit", false);
        component.set("v.viewFormID", formID);

        helper.show(component,event);
        var action = component.get("c.viewForm");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "formID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in createReopenModal action');

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
                console.log('in function of createReopenModal');
                component.set('v.edit2', edit2); 
                component.set("v.modalName", "reopenForm");
                  console.log('modalName: '+component.get("v.modalName"));
              }
                                          
           );
    },
	copyForm: function(component, event, helper) {
        console.log('in copyForm');
        component.set("v.onSubmit", false);
        
        var formID = event.currentTarget.id;
        var formName = event.currentTarget.name;
        console.log('form being copied ID: '+formID);
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
            var hrefInfo = "mailto:OHRLeaveQuestions@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "OHRLeaveQuestions@epa.gov";
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
        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);
        
         
		var action = component.get("c.cloneForm");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "FormID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in copyForm action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.newForm", resp.getReturnValue());
                component.set("v.viewFormID", component.get("v.newForm.Id"));
                console.log('new copy form formID: '+component.get("v.newForm.Id"))
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
    newOpenModal: function(component, event, helper) {  //this needs to be renamed
        console.log('in newOpenModal');
        
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
    newCreateModal: function(component, event, helper) {   //this needs to be renamed
        console.log('in newCreateModal');
        component.set("v.onSubmit", false);
        
        var isNew = component.get("v.isNew");
        console.log('isNew: ' + isNew);
        var formID = component.get("v.viewFormID");
        console.log('formID: ' + formID);
		var formName = component.get("v.viewFormName");        
        console.log('formName: ' + formName);
        
        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "BAP_Admins@epa.gov";
        }
        else if (formName === "EPA-3110-1") {
            var hrefInfo = "";
        	var hrefEmail = "David Ack";
        }
        else if (formName === "EPA-3160-6v5") {
            var hrefInfo = "mailto:OHRLeaveQuestions@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "OHRLeaveQuestions@epa.gov";
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
        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);    
            
        helper.show(component,event);
        if (isNew==true) {   // start creating new form
            component.set("v.message", null);
		var action = component.get("c.insertNewForms");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "rtID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in newCreateModal action');
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
                      console.log('modalName: '+component.get("v.modalName"));
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
          }                   // end creating new form
        
        else {         // combined
            console.log('in newCreateModal combined');
            console.log('formID: '+formID);
            component.set("v.isNew",false);
            helper.show(component,event);
            var action = component.get("c.viewForm");
            action.setParams({
                "sID" : component.get("v.sessionID"),
                "formID" : formID
            });
            action.setCallback(this,function(resp){
                console.log('in newCreateModal action');
                var state = resp.getState();
                console.log('state: ' +state);
                if(state === 'SUCCESS'){
                    console.log('formID: '+formID);
                    component.set("v.newForm", resp.getReturnValue());
                    $A.createComponent('force:recordEdit',
                      {
                        'aura:id': 'theModal',
                        'recordId': formID
                       },
                      function(theModal){
                        component.set('v.theModal', theModal); 
                        component.set("v.modalName", "theModal");
                          console.log('modalName: '+component.get("v.modalName"));
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
    },
    newSaveStay : function(component, event, helper){                  //this needs to be renamed
        console.log('in c.newSaveStay');
        console.log('modalname: ' + component.get("v.modalName"));
        
        try {
            	component.get('v.theModal').get("e.recordSave").fire();
                console.log('no error');
          	}
          catch (e) {
            console.log(e);
          }
        
    },
	newSaveAndSubmit : function(component, event, helper){                //this needs to be renamed
        console.log('in newSaveAndSubmit');
        component.set("v.onSubmit", true);
        component.set("v.isCopy", false);
               
        //Save the form
        try {
            component.get("v.theModal").get("e.recordSave").fire();
            console.log('no error');
     	  	}
          catch (e) {
            console.log(e);
          }   
	},
    newViewFormJS : function(component, event, helper){				//this needs to be renamed
        console.log('in newViewFormJS');
        var formID = event.currentTarget.id;   
        console.log('formID: '+ formID);
        
        var formName = event.currentTarget.name;
        
        component.set("v.isNew", false);
        component.set("v.viewFormID", formID); 
        component.set("v.viewFormName", formName);
        component.set("v.isCopy", false);
        
        var a = component.get("c.newCreateModal");
        $A.enqueueAction(a);
    },
    doSave: function(component, event, helper) {
        console.log('in doSave');
        
        //save form in case of issue with attachment upload
        console.log('modalName: '+component.get("v.modalName"));
        component.set("v.safeSave", true);
        console.log('safeSave: '+component.get("v.safeSave"));
        try {
            if (component.get("v.modalName") != 'reopenForm' && component.get("v.modalName") != 'theModal'){
            	console.log('1');
                component.find("edit").get("e.recordSave").fire();
                console.log('no error');
               }
            else if (component.get("v.modalName") == 'reopenForm'){
            	console.log('2');
                component.get("v.edit2").get("e.recordSave").fire();
                console.log('no error');
               }   
            else if (component.get("v.modalName") == 'theModal'){
            	console.log('3');
                component.get("v.theModal").get("e.recordSave").fire();
                console.log('no error');
               }  
          	}
          catch (e) {
            console.log(e);
          }
         
        if (component.get("v.uploadFiles").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
    handleFilesChange: function(component, event, helper) {
        console.log('in handleFilesChange');      
        
        var fileName = 'No File Selected..';
        console.log('976: ' + event.getSource().get("v.files").length);
        component.set("v.uploadFiles", event.getSource().get("v.files"));
        var files = component.get("v.uploadFiles");

        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        console.log('fileName: '+fileName);
        if(fileName != null || fileName != 'No File Selected..'){
        component.set("v.fileName", fileName);
        component.set("v.largeFile", false);
        var a = component.get("c.doSave");
        $A.enqueueAction(a);
          }
    },
    createAttachComp: function(component, event, helper) {
        console.log('in createAttachComp');
        
           $A.createComponent('lightning:input',
                           {
                               'aura:id':'fileUp', 
                               onchange:component.getReference("c.handleFilesChange"), 
                               type:'file', 
                               name:'fileUp',
                               label:'Upload Attachment', 
                               multiple:'false',
                           },
                               function(fileUp) {
                               component.set("v.fileUp", fileUp);
                           }
                               );   
    },
    confirmCancelCreationModal : function(component, event) {
        console.log('in confirmCancelCreationModal');
        
		var resp = confirm("Are you sure you want to close this form?\nYou will lose any unsaved changes.");
        var action;
        var formID = component.get("v.newForm.Id");
        console.log('formID: '+formID);
        
        if(resp === true){
            action = component.get("c.cancelCreationModal");
            action.setParams({
            "formID": formID,
        });
        	}
        else {action = component.get("c.viewFormJS");  //is this needed?  I think can be nothing like in confirmCloseModal
            action.setParams({"formID": formID,});                       
        }
        $A.enqueueAction(action);
	},
    confirmCloseModal : function(component, event) {
        console.log('in confirmCloseModal');
        
		var resp = confirm("Are you sure you want to close this form?\nYou will lose any unsaved changes.");
        
        if(resp === true){
            var a = component.get("c.closeModal");
            $A.enqueueAction(a);
        }
        else {
            //cancel
        }
        
	},
    newCopyForm: function(component, event, helper) {   //this needs to be renamed
        console.log('in newCopyForm');
        component.set("v.onSubmit", false);
        component.set("v.isCopy", true);
        
        var formID = event.currentTarget.id;
        var formName = event.currentTarget.name;
        console.log('form being copied ID: '+formID);
        component.set("v.message", null);

        component.set("v.viewFormName", formName);
        
		var action = component.get("c.cloneForm");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "FormID" : formID
        });
        action.setCallback(this,function(resp){
			console.log('in copyForm action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.newForm", resp.getReturnValue());
                component.set("v.viewFormID", component.get("v.newForm.Id"));
                console.log('new copy form formID: '+component.get("v.newForm.Id"))
                
                var a = component.get("c.newCreateModal");
        		$A.enqueueAction(a);
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
   approvalSubmit : function(component, event, helper) {
		console.log('in approvalSubmit');

        	var formID = component.get("v.viewFormID");
        	console.log('formID: '+ formID);
        
            var action = component.get("c.submitForApproval");
            action.setParams({
                "formID": formID,
                "sID" : component.get("v.sessionID")
            });
            action.setCallback(this,function(resp){
                console.log('in approvalSubmit action');
                var state = resp.getState();
                console.log('state: ' +state);
                if(state === 'SUCCESS'){
                    component.set("v.message", resp.getReturnValue());
                    component.set("v.modalName", '');
                    component.set("v.onSubmit", false)
                }
                else if(state === 'ERROR'){
                    var errors = resp.getError();
                    for(var i = 0 ;i < errors.length;i++){
                        console.log(errors[i].message);
                    }
                }
            });
            $A.enqueueAction(action);  	
        
        // Update display of forms, sets display to "viewMyForms" for feedback to user that it was submitted
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in approvalSubmit action2');
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
    }
    
})