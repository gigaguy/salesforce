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
    approvalRecall : function(component, event, helper) {  // recalls Form from approval
    	console.log('in approvalRecall');
            
        	var formID = component.get("v.viewFormID");
        	console.log('formID: '+ formID);
        
            var action = component.get("c.recallApproval");
            action.setParams({
                "formID": formID,
                "sID" : component.get("v.sessionID")
            });
            action.setCallback(this,function(resp){
                console.log('in approvalRecall action');
                var state = resp.getState();
                console.log('state: ' +state);
                if(state === 'SUCCESS'){
                    component.set("v.message", resp.getReturnValue());
                    component.set("v.viewTheModal", false);
                    component.set("v.hasAttachments", false);
        			component.set("v.addAttachments", false);
                    component.set("v.onSubmit", false);
                    component.set("v.trySubmit", false);
                    component.set("v.submittedForm", false);
                    	console.log('submittedForm is False');
                    component.set("v.viewLineItemList", false);
        			component.set("v.showLineItem", false);
                    
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
			console.log('in approvalRecall action2');
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
                    component.set("v.onSubmit", false);
                    component.set("v.trySubmit", false);
                    component.set("v.submittedForm", true);
                    	console.log('submittedForm is True');
                    component.set("v.viewLineItemList", false);
        			component.set("v.showLineItem", false);
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
        component.set("v.viewLineItemList", false);
        component.set("v.showLineItem", false);
        component.set("v.trySubmit", false);
    	
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
    cancelLineItemModal : function(component, event, helper){ // Closes and deletes temp Line Item if user hits "cancel" button 
        													  // Once Line Item is saved by user, the "cancel" button is no longer available
    	console.log('in cancelLineItemModal'); 
        component.set("v.message", null);
        component.set("v.viewTheModal", false);
          console.log('viewTheModal: '+component.get("v.viewTheModal"));
  //      component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
  //      component.set("v.viewLineItemList", false);
    	
        var action = component.get("c.deleteLineItem");
        action.setParams({
            "liID":component.get("v.theLineItem.Id"),
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in cancelLineItemModal action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.message", '');
                component.set("v.showLineItem", false);
                component.set("v.newLineItem", false);
                
                var formID = component.get("v.viewFormID");
                helper.getLineItemList(component, formID);
                
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
    closeLineItemModal : function(component, event) {
        console.log('in closeLineItemModal');
    
            component.set("v.showLineItem", false);
            component.set("v.message", null);
            component.set("v.viewLineItemList", true);
            
            var a = component.get("c.createTheModal");
            $A.enqueueAction(a);
        
               
    },
    closeModal: function(component, event, helper) {  // closes theModal
        console.log('in closeModal');    
           
        component.set("v.message", null);
        component.set("v.viewTheModal", false);
          console.log('viewTheModal: '+component.get("v.viewTheModal"));
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
        component.set("v.rtLineItemEnabled",false);
        component.set("v.viewLineItemList", false);
        component.set("v.displayFieldsCount", 0);
        component.set("v.showLineItem", false);

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
    confirmCancelLineItemModal : function(component, event) {  
        console.log('in confirmCancelLineItemModal');
        
		var resp = confirm("Are you sure you want to close this Line Item?\nYou will lose any unsaved changes.");
        var action;
        var liID = component.get("v.theLineItem.Id");
        console.log('liID: '+liID);
        
        if(resp === true){          
            component.set("v.viewLineItemList", true);
            action = component.get("c.cancelLineItemModal");
            action.setParams({
            "liID": liID,
        });
        	$A.enqueueAction(action);
          }
        
        else {//no action
        }
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
    confirmCloseLineItemModal : function(component, event) {
        console.log('in confirmCloseLineItemModal');
    
    var resp = confirm("Are you sure you want to close this line item?\nYou will lose any unsaved changes.");
        
        if(resp === true){
            component.set("v.showLineItem", false);
            component.set("v.message", null);
            component.set("v.viewLineItemList", true);
	        component.set("v.hasAttachments", false);
            component.set("v.addAttachments", false);
            component.set("v.addLineItemAttachments", false);
            component.set("v.fileName", "No File Selected..");
            component.set("v.largeFile", false);            
            
            var a = component.get("c.createTheModal");
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
            component.set("v.rtLineItemEnabled",false);
            action = component.get("c.deleteFormJS");
            action.setParams({
            "formID": formID,
        });
        	}
        else { //cancel   
          }
        $A.enqueueAction(action);
	},
    confirmLineItemDelete : function(component, event) {
        console.log('in confirmLineItemDelete');
        
        var resp = confirm("Are you sure you want to delete this line item?");
        var action;
        var liID = component.get("v.viewLineItemID");
        
        if(resp === true){
            action = component.get("c.deleteLineItemJS");
            action.setParams({
            "liID": liID,
        });
            $A.enqueueAction(action);
        	}
        
        else { //cancel   
          }       
    },
    confirmRecall : function(component, event) { 
        console.log('in confirmRecall');
        
		var resp = confirm("Are you sure you want to recall the approval for this form?");
        if(resp === true){
            var a = component.get("c.approvalRecall");
                $A.enqueueAction(a);
              }
        else {
             //cancel
          }           
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
        console.log('sid: '+component.get("v.sessionID"));
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
        component.set("v.rtLineItemEnabled", false);
        
        var a = component.get("c.createTheModal");
        $A.enqueueAction(a);
    },
    createNewLineItem : function(component, event, helper) {   // inserts new line item for editing
        console.log('in createNewLineItem');
        
        //save form so changes not lost
        try {
            component.set("v.trySubmit", false);
            component.get('v.theModal').get("e.recordSave").fire();
            console.log('no error');
        }
        catch (e) {
            console.log(e);
        }   
        
        //hide attachment component in case it is open
            component.set("v.hasAttachments", false);
            component.set("v.addAttachments", false);
            component.set("v.fileName", "No File Selected..");
            component.set("v.largeFile", false);
        
        //close line item list
	        component.set("v.viewLineItemList", false);
        
        var formID = component.get("v.viewFormID"); 
        console.log('formID: ' + formID);
        var formName = component.get("v.viewFormName");
        console.log('formName: '+formName);
        
        var action = component.get("c.insertLineItem");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "formID" : formID,
            "formName" : formName,
            "siteUserID" : component.get("v.siteUserID"),
            "apiUserID" : component.get("v.apiUserID")
        });
        action.setCallback(this,function(resp){
			console.log('in createNewLineItem action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.theLineItem", resp.getReturnValue());  // returned new line item
                component.set("v.viewLineItemID", component.get("v.theLineItem.Id"));      
                component.set("v.savedLineItem", false);
                component.set("v.newLineItem", true);
                component.set("v.message", null);
                component.set("v.showLineItem", true);
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
    createTheModal: function(component, event, helper) {   // creates theModal component
        console.log('in createTheModal');
        component.set("v.onSubmit", false);
        
        var showLineItem = component.get("v.showLineItem");
        console.log('showLineItem: '+showLineItem);
        console.log('viewlineitemlist: '+component.get("v.viewLineItemList"));
        
        if (showLineItem!=true) {
        var isNew = component.get("v.isNew");
        console.log('isNew: ' + isNew);
        var formID = component.get("v.viewFormID");
        console.log('formID: ' + formID);
		var formName = component.get("v.viewFormName");        
        console.log('formName: ' + formName);   
        
        //check if Form Record Type is enabled to add Line Items
 		helper.checkLineItemEnabled(component, formName, formID);           
            
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
                
                //Get Support link info
		        helper.getSupportInfo(component, formID, formName);
                
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
        
        else {         // open saved form
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
                    	var approvalStatus = component.get("v.newForm.Approval_Step__c");
                    	console.log('approvalStatus: '+approvalStatus);
                    	if(approvalStatus===undefined) 
                        	{
                             component.set("v.submittedForm", false);
                             console.log('submittedForm is False');
                           }
                         else if(approvalStatus==='Recalled' || approvalStatus==='Rejected' || approvalStatus.indexOf('Form Prepared')>-1)
                         	{
			                    console.log('jtest = '+approvalStatus.indexOf('Form Prepared')); 
                             component.set("v.submittedForm", false);
                             console.log('submittedForm is False');
                         	}
                    	 else{
                              component.set("v.submittedForm", true);
                              console.log('submittedForm is True');
                         	}
                    
                    //Get Support link info
			        helper.getSupportInfo(component, formID, formName);
                    
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
      }
    else {  // showLineItem is true
         console.log('in createTheModal for Line Item');
        
        //checks if line item list should be hidden
        if(component.get("v.lineItemNav")){
            	component.set("v.viewLineItemList", false);
            	component.set("v.lineItemNav", false);
        	}
        var liID = component.get("v.viewLineItemID")
        console.log('liID: '+liID);
    		 $A.createComponent('force:recordEdit',
                      {
                        'aura:id' : 'theModal',
                        'recordId': liID
                       },
                      function(theModal){
                        component.set('v.theModal', theModal); 
                        component.set("v.viewTheModal", true);
                          console.log('viewTheModal: '+component.get("v.viewTheModal"));                        
                       }                                                  
                        );
		}
    },
    deleteAttachment : function(component, event, helper){
        console.log('in deleteAttachment');
        
        var formID;
         if(component.get("v.addAttachments")==true){ 
              formID = component.get("v.viewFormID");
             }
           else if(component.get("v.addLineItemAttachments")==true){  
               formID = component.get("v.viewLineItemID");
             }
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
        component.set("v.showLineItem", false);
        component.set("v.viewLineItemList", false);
        component.set("v.showLineItem", false);
        component.set("v.trySubmit", false);
 
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
    deleteLineItemJS : function(component, event, helper){
    	console.log('in deleteLineItemJS');
        
        component.set("v.viewLineItemList", false);
        component.set("v.addLineItem", false);
        
        var liID = component.get("v.viewLineItemID");
        console.log(liID);
		var action = component.get("c.deleteLineItem");
        action.setParams({
            "liID" : liID,
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in deleteLineItem action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.message", resp.getReturnValue());
                component.set("v.showLineItem", false);
                component.set("v.lineItemList", null);          		
                
                var action2 = component.get("c.viewLineItemList");
        action2.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {var a = component.get("c.createTheModal");
                                     $A.enqueueAction(a);}
            else {
                component.set("v.message", null);
            }
        });
     	$A.enqueueAction(action2); 
                
                
       //   		var a = component.get("c.createTheModal");
       // 		$A.enqueueAction(a); 
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
        component.set("v.trySubmit", false);
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
        
        component.set("v.trySubmit", false);
        try {
            component.set("v.enableAttachments", true);
            component.set("v.trySubmit", false);
           	component.get('v.theModal').get("e.recordSave").fire();
            console.log('no error');
          	}
        catch (e) {
            console.log(e);
          }

    },
    enableLineItems: function(component, event, helper) {    // saves Form before allowing Line Items
    	console.log('in enableLineItems');
                
        try {
           	component.set("v.enablingLineItems", true);
            component.set("v.trySubmit", false);
            component.get('v.theModal').get("e.recordSave").fire();
            console.log('no error');
          	}
        catch (e) {
            console.log(e);
          }
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
        
        if(component.get("v.trySubmit")==true){
         	component.set("v.trySubmit", false);
            component.set("v.onSubmit", true);
          }
        
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
                component.set("v.isNew", false);
                component.set("v.isCopy", false);
                 if(component.get("v.showLineItem")==false){component.set("v.message", "Form Saved | ");}
                 else {component.set("v.message", "Line Item Saved");}
                var a = component.get('c.createTheModal');  
                $A.enqueueAction(a);
              }
                else if(component.get("V.onSubmit") == true){
                    var a = component.get('c.approvalSubmit');  
                	$A.enqueueAction(a);
                }
            }
        
        component.set("v.saveAndClose", false);
        
        //if enabling attachments
        if(component.get("v.enableAttachments")){
            component.set("v.enableAttachments", false);            
            var a = component.get("c.showAttachments");
            $A.enqueueAction(a);
         }
        
        //if enabling line items
        if(component.get("v.enablingLineItems")){
            component.set("v.enablingLineItems", false);
            var a = component.get("c.viewLineItemList");
        	$A.enqueueAction(a);
        }
        
        //if save/closing line items
        if(component.get("v.saveClosingLineItem")){
            console.log('save success for save/closing line item');
            component.set("v.saveClosingLineItem", false);
            component.set("v.showLineItem",false);
            component.set("v.newLineItem",false);
            component.set("v.saveClosingLineItem", false);
            component.set("v.viewLineItemList", true);
            var action = component.get("c.viewLineItemList");
            action.setCallback(this, function(response){
                if (name === "SUCCESS") {
                    var a = component.get("c.createTheModal");
                    $A.enqueueAction(a);}
                else {
                    component.set("v.message", null);
                }
            });
            $A.enqueueAction(action); 
        }
        
        //if save/nexting line item
        if(component.get("v.saveNextingLineItem")){
            console.log('save success for save/nexting line item');
            component.set("v.saveNextingLineItem", false);
            component.set("v.nextCheck",true);
        	component.set("v.saveNextingLineItem", false);
            var a = component.get("c.createNewLineItem");
       	   $A.enqueueAction(a);
        }
        
	},
    hideAttachments : function(component, event, helper) { // hides list of attachments when user hits "hide attachments" button
        console.log('in hideAttachments');
        
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
        component.set("v.addLineItemAttachments", false);
        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);
        
    },
    hideLineItem : function(component, event, helper) {
        console.log('in hideLineItem');
        
        component.set("v.showLineItem", false);
        component.set("v.viewLineItemList", false);
   //     component.set("v.sortField","Display1__c");
        
    },
    saveAndSubmit : function(component, event, helper){   // saves Form and submits for approval
        console.log('in saveAndSubmit');
        component.set("v.trySubmit", true);
        component.set("v.isCopy", false);
               
        //Save the form
        try {
            component.get("v.theModal").get("e.recordSave").fire();
            console.log('no error');
             component.set("v.rtLineItemEnabled",false);
             component.set("v.viewLineItemList", false);
             component.set("v.displayFieldsCount", 0);
             component.set("v.showLineItem", false);
     	  	}
          catch (e) {
            console.log(e);
          }   
	},
    saveLineItem : function(component, event, helper){        // saves Form, closes modal, goes back to Form
        console.log('in c.saveLineItem');
        console.log('viewTheModal: ' + component.get("v.viewTheModal"));
        
        try {
            	component.set("v.saveClosingLineItem", true);
            	component.set("v.trySubmit", false);
            	component.get('v.theModal').get("e.recordSave").fire();
                console.log('no error');
          	}
          catch (e) {
            console.log(e);
          }
               
    },
    saveNext : function(component, event, helper){        // saves current Line Item, creates next Line Item record
        console.log('in c.saveNext');
        console.log('viewTheModal: ' + component.get("v.viewTheModal"));
        
        try {
            	component.set("v.saveNextingLineItem", true);
            	component.get('v.theModal').get("e.recordSave").fire();
                console.log('no error');
          	}
          catch (e) {
            console.log(e);
          }
        
    },
    saveStay : function(component, event, helper){        // saves Form, does not close modal
        console.log('in c.saveStay');
        console.log('viewTheModal: ' + component.get("v.viewTheModal"));
        
        component.set("v.trySubmit", false);
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
    showLineItemAttachments: function(component, event, helper) {  // shows list of attachments when user hits "show/add attachments" button
        console.log('in showLineItemAttachments');
        
        var formID = component.get("v.viewLineItemID"); 
          console.log('formID: ' + formID);
        
        helper.getAttachList(component, formID);
        	component.set("v.addLineItemAttachments", true); 
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
        component.set("v.rtLineItemEnabled", false);
        
        var a = component.get("c.createTheModal");
        $A.enqueueAction(a);
    },
    viewFormTypes : function(component, event, helper){ // shows user list of available Workflow Forms
        console.log('in viewFormTypes');
        
        component.set("v.message", null);
		component.set("v.pageStatus", "viewFormTypes");  // shows user list of Available Workflow and Fill&Print Forms
	},
    nextLineItem : function(component, event, helper) {
        console.log('in nextLineItem');
        component.set("v.lineItemNav", true);
        
        //save line item
          component.get('v.theModal').get("e.recordSave").fire();
        //rebuild list after save
          var a = component.get("c.viewLineItemList");
          $A.enqueueAction(a);
        
        component.set("v.viewTheModal", false);
        component.set("v.lineItemIndex", component.get("v.lineItemIndex")+1);
        var liIndex = component.get("v.lineItemIndex");
        
        var liID = component.get("v.displayData["+liIndex+"]").Id; 
        component.set("v.viewLineItemID", liID);
        console.log('liID: '+liID);
        
        var action = component.get("c.getLineItem");
        action.setParams({
			"liID" : liID
        });
        action.setCallback(this,function(resp){
			console.log('in viewLineItem action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.theLineItem", resp.getReturnValue());  // returned line item
                component.set("v.message", null);
                component.set("v.showLineItem", true);
                component.set("v.savedLineItem", true);
                component.set("v.newLineItem", false);
                component.set("v.viewLineItemList", false);
                
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
    prevLineItem : function(component, event, helper) {
        console.log('in prevLineItem');
        component.set("v.lineItemNav", true);
        
        //save line item
          component.get('v.theModal').get("e.recordSave").fire();
        //rebuild list after save
          var a = component.get("c.viewLineItemList");
       	  $A.enqueueAction(a);
        
        component.set("v.viewTheModal", false);
        component.set("v.lineItemIndex", component.get("v.lineItemIndex")-1);
        var liIndex = component.get("v.lineItemIndex");

        var liID = component.get("v.displayData["+liIndex+"]").Id; 
        component.set("v.viewLineItemID", liID);
        console.log('liID: '+liID);
        
        var action = component.get("c.getLineItem");
        action.setParams({
			"liID" : liID
        });
        action.setCallback(this,function(resp){
			console.log('in viewLineItem action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.theLineItem", resp.getReturnValue());  // returned line item
                component.set("v.message", null);
                component.set("v.showLineItem", true);
                component.set("v.savedLineItem", true);
                component.set("v.newLineItem", false);
                component.set("v.viewLineItemList", false);
                
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
    lineItemSortOne : function(component, event, helper){
        console.log('in lineItemSortOne');
        var field = "Display1__c";
        helper.lineItemSortBy(component, field);
        
    },
    lineItemSortTwo : function(component, event, helper){
        console.log('in lineItemSortTwo');
        var field = "Display2__c";
        helper.lineItemSortBy(component, field);

    },
    lineItemSortThree : function(component, event, helper){
        console.log('in lineItemSortThree');
        var field = "Display3__c";
        helper.lineItemSortBy(component, field);
    },
    lineItemSortFour : function(component, event, helper){
        console.log('in lineItemSortThree');
        var field = "Display4__c";
        helper.lineItemSortBy(component, field);
    },
    lineItemSortFive : function(component, event, helper){
        console.log('in lineItemSortThree');
        var field = "Display5__c";
        helper.lineItemSortBy(component, field);
    },
    viewLineItemJS : function(component, event, helper){
    	console.log('in viewLineItem');
        
        component.set("v.viewTheModal", false);
        var liID = event.currentTarget.id; 
        component.set("v.viewLineItemID", liID);
        console.log('liID: '+liID);
        var liCount = event.currentTarget.dataset.count;
        component.set("v.lineItemIndex", parseInt(liCount));
        
        var action = component.get("c.getLineItem");
        action.setParams({
			"liID" : liID
        });
        action.setCallback(this,function(resp){
			console.log('in viewLineItem action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.theLineItem", resp.getReturnValue());  // returned line item
                component.set("v.message", null);
                component.set("v.showLineItem", true);
                component.set("v.savedLineItem", true);
                component.set("v.newLineItem", false);
                component.set("v.viewLineItemList", false);
                
                if(component.get("v.hasAttachments")==true){
                    component.set("v.hasAttachments", false);
                    component.set("v.addAttachments", false);
                    component.set("v.fileName", "No File Selected..");
                    component.set("v.largeFile", false);
                  }
                
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
    viewLineItemList : function(component, event, helper) {   // enables line items to be entered
    	console.log('in viewLineItemList');
        component.set("v.displayFieldsCount", undefined);       
        component.set("v.viewLineItemList", true);
        var formID = component.get("v.viewFormID"); 
          console.log('formID: ' + formID);

        helper.getLineItemList(component, formID);
        
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