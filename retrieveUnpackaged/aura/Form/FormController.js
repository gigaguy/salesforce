({
    doInit : function(component, event, helper) {
        var action = component.get("c.getFormRTs");
        action.setParams({
			"sID" : component.get("v.sessionID"),
        });
        action.setCallback(this, function(response){
            console.log('in doInit action');
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.forms", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        helper.getFandP_Forms(component);
     
        //  set siteUserID and apiUserID for temp record sharing
        helper.setSiteUserID(component);
        helper.setAPIUserID(component);
    },
    approvalSubmit : function(component, event, helper) {  // submits Form for approval
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
                    component.set("v.viewTheModal", false);
                    component.set("v.hasAttachments", false);
        			component.set("v.addAttachments", false);
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
        
        // Update display to "viewMyForms"
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in approvalSubmit action2');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.mySavedForms", resp.getReturnValue());  // returned list of user's Saved Forms
                component.set("v.pageStatus", "viewMyForms");  // shows user list of Saved Forms
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
    cancelCreationModal : function(component, event, helper){ // Closes and deletes temp Form if user hits "cancel" button 
        													  // Once Form is saved by user, the "cancel" button is no longer available
    	console.log('in cancelCreationModal'); 
        component.set("v.message", null);
        component.set("v.viewTheModal", false);
          console.log('viewTheModal: '+component.get("v.viewTheModal"));
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
    closeModal: function(component, event, helper) {  // closes theModal
        console.log('in closeModal');    
           
        component.set("v.message", null);
        component.set("v.viewTheModal", false);
          console.log('viewTheModal: '+component.get("v.viewTheModal"));
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);

        // LS 2017/11/19: Added additional action below to remove FormShare on close of modal, there may be a better place or way to do this
        var removeShareAction = component.get("c.removeFormShare");
        removeShareAction.setParams({
			"formID" : component.get("v.viewFormID"),
            "siteUserID" : component.get("v.siteUserID")
        });
        $A.enqueueAction(removeShareAction);
        
        // Update  display to "viewMyForms" 
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in closeModal action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.mySavedForms", resp.getReturnValue());  // returned list of user's Saved Forms
                component.set("v.pageStatus", "viewMyForms");      // shows user list of Saved Forms
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
    confirmFormDelete : function(component, event) {
        console.log('in confirmFormDelete');
        
		var resp = confirm("Are you sure you want to delete the form?");
        var action;
        var formID = component.get("v.viewFormID");
        
        if(resp === true){
            action = component.get("c.deleteFormJS");
            action.setParams({
            "formID": formID,
        });
        	}
        else { //cancel   
          }
        $A.enqueueAction(action);
	},
    confirmSubmit : function(component, event) { 
        console.log('in confirmSubmit');
        
		var resp = confirm("Are you sure you want to submit the form?");
        
        var action;
        var formID = component.get("v.viewFormID");
        
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
    copyForm: function(component, event, helper) {   // process for copying an existing Form
        console.log('in copyForm');
        component.set("v.onSubmit", false);
        component.set("v.isCopy", true);
        component.set("v.isNew", false);
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
                
                var a = component.get("c.createTheModal");
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
    createAttachComp: function(component, event, helper) {  //creates upload attachment component
        console.log('in createAttachComp');
        
           $A.createComponent('lightning:input',
                           {
                               'aura:id':'fileUploadCmp', 
                               onchange:component.getReference("c.handleFilesChange"), 
                               type:'file', 
                               name:'fileUploadCmp',
                               label:'Upload Attachment', 
                               multiple:'false',
                           },
                               function(fileUploadCmp) {
                               component.set("v.fileUploadCmp", fileUploadCmp);
                           }
                               );   
    },
    createNewForm: function(component, event, helper) {  // opens theModal when user hits "New Form" button
   		console.log('in createNewForm');
        
        var formID = event.currentTarget.id;
        console.log('formID(rt): ' + formID);
        var formName = event.currentTarget.name;
        console.log('formName: ' + formName);
        
        component.set("v.isNew", true);
        component.set("v.viewFormID", formID); 
        component.set("v.viewFormName", formName);
        
        var a = component.get("c.createTheModal");
        $A.enqueueAction(a);
    },
    createTheModal: function(component, event, helper) {   // creates theModal component
        console.log('in createTheModal');
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
            var hrefInfo = "https://epaoei--c.na21.visual.force.com/resource/1515007760000/ORD_111_QARF_Instructions";
        	var hrefEmail = "ORDQARFinstructions073008.pdf";
        }
        else if (formName === "PRIAv5") {
            var hrefInfo = "";
        	var hrefEmail = "Nicole Williams, Hamaad Syed, and Patrick Dobak";
        }
        else if (formName === "SF-182") {
            var hrefInfo = "https://usepa.sharepoint.com/sites/OARM_Community/EPAU/SitePages/Training%20Officers%20&%20Coordinators.aspx";
        	var hrefEmail = "Here";
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
            console.log('in createTheModal new form')
            component.set("v.message", null);
		var action = component.get("c.insertNewForms");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "rtID" : formID,
            "siteUserID" : component.get("v.siteUserID"),
            "apiUserID" : component.get("v.apiUserID")
        });
        action.setCallback(this,function(resp){
			console.log('in createTheModal action');
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
                    component.set("v.viewTheModal", true);
                      console.log('viewTheModal: '+component.get("v.viewTheModal"));
                      console.log('in theModal function(createTheModal action) - formID: '+formID);
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
        }	// end if (isNew==true) creating new form
        
        else {         // combined
            console.log('in createTheModal existing form');
            console.log('formID: '+formID);
            component.set("v.isNew",false);
            helper.show(component,event);
            var action = component.get("c.viewForm");
            action.setParams({
                "sID" : component.get("v.sessionID"),
                "formID" : formID,
                "siteUserID" : component.get("v.siteUserID")
            });
            action.setCallback(this,function(resp){
                console.log('in createTheModal action');
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
                        component.set("v.viewTheModal", true);
                          console.log('viewTheModal: '+component.get("v.viewTheModal"));
                          console.log('in theModal function(createTheModal action) - formID: '+formID);
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
    deleteAttachment : function(component, event, helper){
        console.log('in deleteAttachment');
        
        var formID = component.get("v.viewFormID");
          console.log('formID: '+formID);
        var attID = event.currentTarget.id;
          console.log('attID: '+attID);
		var action = component.get("c.deleteFormAttachment");
        action.setParams({
            "attID":attID
        });
        action.setCallback(this,function(resp){
			console.log('in deleteAttachment action');
             
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
                component.set("v.viewTheModal", false);
                  console.log('viewTheModal: '+component.get("v.viewTheModal"));
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
        
        // Update  display to "viewMyForms"
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in deleteFormJS action2');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.mySavedForms", resp.getReturnValue());  // returned list of user's Saved Forms
                component.set("v.pageStatus", "viewMyForms");  // shows user list of Saved Forms
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
    doSave: function(component, event, helper) {    // saves Form before uploading attachment
        console.log('in doSave');
        
        //save form in case of issue with attachment upload
        component.set("v.saveAndClose", true);
        console.log('saveAndClose: '+component.get("v.saveAndClose"));
        try {
                component.get("v.theModal").get("e.recordSave").fire();
                console.log('no error');  
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
    enableAttachments: function(component, event, helper) {    // saves Form before allowing attachments
    	console.log('in enableAttachments');
        
        try {
           	component.get('v.theModal').get("e.recordSave").fire();
            console.log('no error');
          	}
        catch (e) {
            console.log(e);
          }
        
        var a = component.get("c.showAttachments");
        $A.enqueueAction(a);
    },
    handleFilesChange: function(component, event, helper) {  // runs when user selects file for attachment upload
        console.log('in handleFilesChange');      
        
        var fileName = 'No File Selected..';
       
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
    handleSave : function(cmp, event, helper){  //this runs at beginning of save, "handleSaveSuccess" runs after successful save
		console.log('in c.handleSave');       
        cmp.find("anchor").getElement().scrollIntoView();  //scrolls to top of form for user to see any error messages
	},
	handleSaveSuccess : function(component, event, helper){  //this runs after successful save, "handleSave" runs at beginning of Save process        
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
                component.set("v.mySavedForms", resp.getReturnValue());  // returned list of user's Saved Forms
                component.set("v.pageStatus", "viewMyForms");  // shows user list of Saved Forms
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
   			
        	// checks "saveAndClose" -- some save operations close modal (i.e. on submit for approval)
            console.log('saveAndClose: '+component.get("v.saveAndClose"));
            if(component.get("v.saveAndClose")!=true){
                console.log('viewTheModal: '+component.get("v.viewTheModal"));                
            
            console.log('onSubmit: '+component.get("v.onSubmit"));
            if (component.get("v.onSubmit") == false){
                component.set("v.message", "Form Saved | ");
                component.set("v.isNew", false);
                component.set("v.isCopy", false);
                component.set("v.message", "Form Saved | ");
                
                var a = component.get('c.createTheModal');  
                $A.enqueueAction(a);
              }
                else if(component.get("V.onSubmit") == true){
                    var a = component.get('c.approvalSubmit');  
                	$A.enqueueAction(a);
                }
            }
        
        component.set("v.saveAndClose", false);
        
	},
    hideAttachments: function(component, event, helper) { // hides list of attachments when user hits "hide attachments" button
        console.log('in hideAttachments');
        
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);
        
    },
    saveAndSubmit : function(component, event, helper){   // saves Form and submits for approval
        console.log('in saveAndSubmit');
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
    saveStay : function(component, event, helper){        // saves Form, does not close modal
        console.log('in c.saveStay');
        console.log('viewTheModal: ' + component.get("v.viewTheModal"));
        
        try {
            	component.get('v.theModal').get("e.recordSave").fire();
                console.log('no error');
          	}
          catch (e) {
            console.log(e);
          }
        
    },
    showAttachments: function(component, event, helper) {  // shows list of attachments when user hits "show/add attachments" button
        console.log('in showAttachments');
        
        var formID = component.get("v.viewFormID"); 
          console.log('formID: ' + formID);
        
        helper.getAttachList(component, formID);
        	component.set("v.addAttachments", true); 
     	var a = component.get("c.createAttachComp");
        $A.enqueueAction(a);
    },
    viewFormJS : function(component, event, helper){	  // queries for user's saved Forms
        console.log('in viewFormJS');
        var formID = event.currentTarget.id;   
        console.log('formID: '+ formID);
        
        var formName = event.currentTarget.name;
        
        component.set("v.message", "");
        component.set("v.isNew", false);
        component.set("v.viewFormID", formID); 
        component.set("v.viewFormName", formName);
        component.set("v.isCopy", false);
        
        var a = component.get("c.createTheModal");
        $A.enqueueAction(a);
    },
    viewFormTypes : function(component, event, helper){ // shows user list of available Workflow Forms
        console.log('in viewFormTypes');
        
        component.set("v.message", null);
		component.set("v.pageStatus", "viewFormTypes");  // shows user list of Available Workflow and Fill&Print Forms
	},
    viewMyForms : function(component, event, helper){  // gets list of user's existing Form records, adds to "v.mySavedForms"
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
                component.set("v.mySavedForms", resp.getReturnValue());  // returned list of user's Saved Forms
                component.set("v.message", null);
                component.set("v.pageStatus", "viewMyForms");  // shows user list of Saved Forms
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