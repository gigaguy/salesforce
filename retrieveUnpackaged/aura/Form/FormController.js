({

    //Checked and Good
    doInit : function(component, event, helper) {
        console.log("doInit function in FormController was called.");
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

        //  set siteUserID and apiUserID for temp record sharing. In t2, not oarm
        helper.setSiteUserID(component);
        helper.setAPIUserID(component);
        //Trellis
        component.set("v.isPurchase",false);
    },

    //Checked and Good
    viewMyForms : function(component, event, helper){
        console.log("viewMyForms function called.");
        var action = component.get("c.findExistingForms");
        action.setParams({
            "sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
            console.log('action.setCallback function called in veiwMyForms');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.mySavedForms", resp.getReturnValue());
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

    //Checked and Good
    viewMyTrainingForms: function(component, event, helper) {
        console.log("viewMyTrainingForms function called.");
        component.set("v.trainingPageMode", "showRecords");
        component.set("v.pageStatus", "viewMyTrainings");                
    },
    //Checked and Good
    viewFormTypes : function(component, event, helper){
        console.log("viewFormTypes function called.");
        component.set("v.message", null);
        component.set("v.pageStatus", "viewFormTypes");
    },

    //Checked and Good
    //Merging functions. oarm's openModal and openFormModal with t2's createNewForm and createTheModal
    createNewForm: function(component, event, helper) {
        console.log("createNewForm function called.");
        var formID = event.currentTarget.id;
        var formName = event.currentTarget.name;
        console.log('createNewForm function: formName = ' + formName);
        component.set("v.isNew", true);
        component.set("v.viewFormID", formID); 
        component.set("v.viewFormName", formName);
        component.set("v.formOption", null);
        
        // We are going to have to split the code here. No real way to merge them. But they can coexist from here
        // createNewForm = createNewForm in t2 and openModal in oarm. - James Lambert
        if(formName != undefined && formName =='Purchase Card'){

            formID = formName;// can not depend on 
            component.set("v.backupFormId",formID);
            component.set("v.backUpFormName",formName);            
            component.set("v.forceSelectFormOption",true);
            component.set("v.isPurchase", true);
        }else{
            //Temporaily comment out this call from oarm
            //helper.openFormModal(component, event,formID,formName,'');
            var a = component.get("c.createTheModal");
            $A.enqueueAction(a);            
        }
    },

    //Not Fully Good Yet, see notes.
    createTheModal: function(component, event, helper) {
        console.log("createTheModal function called.");

        if(!component.get("v.isPurchase")){
            component.set("v.isOpen", false);
        }else{
            console.log('isPurchase is true');
        }
            
        
        component.set("v.onSubmit", false);
        var isNew = component.get("v.isNew");
        var formID = component.get("v.viewFormID");
        var formName = component.get("v.viewFormName");
        var formOption = component.get("v.formOption"); // Double check this

        console.log('createTheModal: formName = ' + formName);

        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
            var hrefEmail = "BAP_Admins@epa.gov";
        }else if (formName === "EPA-3110-1") {
            var hrefInfo = "";
            var hrefEmail = "David Ack";
        }
        else if (formName === "EPA-3160-6v5") {
            var hrefInfo = "mailto:OHRLeaveQuestions@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
            var hrefEmail = "OHRLeaveQuestions@epa.gov";
        }else if (formName === "EPA-PCOR") {
            var hrefInfo = "";
            var hrefEmail = "To be determined";
        }else if (formName === "ORD-111") {
            var hrefInfo = "https://intranet.ord.epa.gov/sites/default/files/media/qa/ORDQARFinstructions073008.pdf";
            var hrefEmail = "ORDQARFinstructions073008.pdf";
        }else if (formName === "PRIAv5") {
            var hrefInfo = "";
            var hrefEmail = "Nicole Williams, Hamaad Syed, and Patrick Dobak";
        }else if (formName === "SF-182") {
            var hrefInfo = "https://usepa.sharepoint.com/sites/OARM_Community/EPAU/SitePages/Training%20Officers%20&%20Coordinators.aspx";
            var hrefEmail = "Here";
        }else if (formName === "Purchase Card") {
            var hrefInfo = "mailto:Creed.Suzette@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
            var hrefEmail = "Creed.Suzette@epa.gov";
        }else {
            var hrefInfo = "mailto:McNeal.Detha@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
            var hrefEmail = "McNeal.Detha@epa.gov";
        }

        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);

        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);

        helper.show(component,event);

        if (isNew==true) {
            console.log('createTheModal: isNew = ' + isNew);
            component.set("v.message", null); //Double check how this is used.
            var action = component.get("c.insertNewForms");
            action.setParams({
                "sID" : component.get("v.sessionID"),
                "rtID" : formID,
                "siteUserID" : component.get("v.siteUserID"),
                "apiUserID" : component.get("v.apiUserID"),
                "formOption" : formOption //Need to figure out how to get this value.
            });

            action.setCallback(this,function(resp){
                console.log('createTheModal: isNew = true: action.setCallback function called.');
                var state = resp.getState();
                if(state === 'SUCCESS'){

                    //Will have to doble check this 
                    if(formOption!=undefined){
                        console.log('createTheModal: action.setCallback: state === SUCCESS & formOption != undefined');
                        component.set("v.formOption", formOption); 
                        //Download Form introduction text if applicabl
                        this.getFormIntroduction(component, event, formOption);
                    }
                    component.set("v.newForm", resp.getReturnValue());
                    component.set("v.viewFormID", component.get("v.newForm.Id"));
                    formID = component.get("v.newForm.Id");

                    $A.createComponent('force:recordEdit',{
                        'aura:id': 'theModal',
                        'recordId': formID
                        },
                        function(theModal){
                           console.log(' createTheModal: isNew = true: action.setCallback: creatComponent: function(theModal) called.');
                            component.set('v.theModal', theModal); 
                            component.set("v.viewTheModal", true);
                            console.log('viewTheModal: '+ component.get("v.viewTheModal"));
                            console.log('createTheModal: isNew = true: action.Callback: state = Success:  formID: '+formID);
                        }
                                              
                    );
                    
                    if(!component.get("v.isPurchase")){
                        component.set("v.isOpen", false);
                    }
                    console.log('end of createTheModal: isOpen = ' + component.get("v.isOpen"));
                    helper.hide(component,event);
                }else if(state === 'ERROR'){
                    var errors = resp.getError();
                    helper.hide(component,event);
                    for(var i = 0 ;i < errors.length;i++){
                        console.log(errors[i].message);
                    }
                }
            });
            $A.enqueueAction(action);
        }else {         // combined
            console.log('createTheModal: isNew = false');
            component.set("v.isNew", false); //Already set as false. Double check if this is necessary
            helper.show(component,event);
            var action = component.get("c.viewForm");
            
            action.setParams({
                "sID" : component.get("v.sessionID"),
                "formID" : formID,
                "siteUserID" : component.get("v.siteUserID")
            });
            action.setCallback(this,function(resp){
                console.log('action.setCallback function is called in createTheModal where v.isNew == false');
                var state = resp.getState();
                console.log('state: ' +state);
                if(state === 'SUCCESS'){
                    console.log('formID: '+formID);
                    component.set("v.newForm", resp.getReturnValue());
                    $A.createComponent('force:recordEdit',{
                        'aura:id': 'theModal',
                        'recordId': formID
                        },
                        function(theModal){
                            console.log(' createTheModal: isNew = false: action.setCallback: creatComponent: function(theModal) called.');
                            component.set('v.theModal', theModal); 
                            component.set("v.viewTheModal", true);
                            console.log('viewTheModal: '+component.get("v.viewTheModal"));
                            console.log('in theModal function(createTheModal action) - formID: '+formID);
                        }
                                                  
                    );
                
                    helper.hide(component,event);
                }else if(state === 'ERROR'){
                    var errors = resp.getError();
                    helper.hide(component,event);
                    for(var i = 0 ;i < errors.length;i++){
                        console.log('Line 225 - Here is the problem error: ' + errors[i].message);
                    }
                }
            });
            $A.enqueueAction(action);

            console.log('These are the variables in question:');
            console.log("v.newForm.Approval_Step__c = " + component.get("v.newForm.Approval_Step__c"));
            console.log("v.isNew = " + component.get("v.isNew"));
            console.log("v.isCopy = " + component.get("v.isCopy"));
            console.log("v.hasAttachments = " + component.get("v.hasAttachments"));
            console.log("v.addAttachments = " + component.get("v.addAttachments"));
            console.log("v.isOpen = " + component.get("v.isOpen"));
            console.log("end of createTheModal function");   
        }
    },

    //Checked and Good
    viewFormJS : function(component, event, helper){      // queries for user's saved Forms
        console.log("viewFormJS function called.");
        var formID = event.currentTarget.id;   
        var formName = event.currentTarget.name;

        if(formName == "Cancellation-Check or Card" || formName == "Change-Cardholder AO" || formName == "Change-Contact Information" || formName == "Change-Monthly Limit" || formName == "Change-Name on Card/Check" || formName == "Change-Suspension of Card/Check" || formName == "New-Approving Official (AO)" || formName == "New-Convenience Check" || formName == "Training" || formName == "Purchase Card"){
            component.set("v.isPurchase", true);
        }

        console.log('viewFormJS: formName = ' + formName);
        
        component.set("v.message", "");
        component.set("v.isNew", false);
        component.set("v.viewFormID", formID); 
        component.set("v.viewFormName", formName);
        component.set("v.isCopy", false);

        if(component.get("v.isPurchase")){
            console.log("this was one of the purchase cards");
            component.set("v.modalName", "viewForm");  //This is wrong. Can't both be view.
            component.set("v.selectedFormName", formName);
        }
        
        console.log('These are the variables in question:');
        console.log("v.newForm.Approval_Step__c = " + component.get("v.newForm.Approval_Step__c"));
        console.log("v.isNew = " + component.get("v.isNew"));
        console.log("v.isCopy = " + component.get("v.isCopy"));
        console.log("v.hasAttachments = " + component.get("v.hasAttachments"));
        console.log("v.addAttachments = " + component.get("v.addAttachments"));
        console.log("v.isOpen = " + component.get("v.isOpen"));
        console.log("before createTheModal function");
        var a = component.get("c.createTheModal");
        $A.enqueueAction(a);
    },

    //Checked and Good
    copyForm: function(component, event, helper) {   // process for copying an existing Form
        console.log("copyForm function called.");
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

    //End of the merging of the code. Below is from production
    approvalSubmit : function(component, event, helper) {  // submits Form for approval
        console.log("approvalSubmit function called.");

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
                    //Trellis
                    component.set("v.isPurchase",false);
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
        console.log("cancelCreationModal function called."); 
        component.set("v.message", null);
        component.set("v.viewTheModal", false);
          console.log('viewTheModal: '+component.get("v.viewTheModal"));
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
        //Trellis
        component.set("v.isPurchase",false);
        
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
        console.log("closeModal function called.");    
           
        component.set("v.message", null);
        component.set("v.viewTheModal", false);
          console.log('viewTheModal: '+component.get("v.viewTheModal"));
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
        //Trellis
        component.set("v.isPurchase",false);

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
        console.log("confirmCancelCreationModal function called.");
        
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
        console.log("confirmCloseModal function called.");
        
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
        console.log("confirmFormDelete function called.");
        
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
        console.log("confirmSubmit function called.");
        
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
    
    createAttachComp: function(component, event, helper) {  //creates upload attachment component
        console.log("createAttachComp function called.");
        
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

    deleteAttachment : function(component, event, helper){
        console.log("deleteAttachment function called.");
        
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
        console.log("deleteFormJS function called.");
        
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
        //Trellis
        component.set("v.isPurchase",false);
 
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
        console.log("doSave function called.");
        
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
        console.log("enableAttachments function called.");
        
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
        console.log("handleFilesChange function called.");      
        
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
        console.log("handleSave function called.");
        
        //Made getelement() all lower case, then tried it with just get. - James Lambert 1/16/2018     
        cmp.find("anchor").get().scrollIntoView();  //scrolls to top of form for user to see any error messages
        //console.log('v.newFormId = ' + component.get('v.newFormId'));
    },
    handleSaveSuccess : function(component, event, helper){  //this runs after successful save, "handleSave" runs at beginning of Save process        
        console.log("handleSaveSuccess function called.");
        console.log('handleSaveSuccess: v.nerFormId = ' + component.get('v.newFormId'));
        console.log('isPurchase = ' + component.get("v.isPurchase"));
        //TSHERMAN 1.15.18
        if(component.get("v.isPurchase") == false){
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
                }else if(state === 'ERROR'){
                    var errors = resp.getError();
                    for(var i = 0 ;i < errors.length;i++){
                        console.log(errors[i].message);
                    }
                }
            });

            $A.enqueueAction(action);
            
            // checks "saveAndClose" -- some save operations close modal (i.e. on submit for approval)
            console.log('saveAndClose: '+component.get("v.saveAndClose"));
            if(component.get("v.saveAndClose")!= true){
                console.log('viewTheModal: '+ component.get("v.viewTheModal"));                
                console.log('onSubmit: '+component.get("v.onSubmit"));
                if (component.get("v.onSubmit") == false){
                    component.set("v.message", "Form Saved | ");
                    component.set("v.isNew", false);
                    component.set("v.isCopy", false);
                    component.set("v.message", "Form Saved | ");
                
                    var a = component.get('c.createTheModal');  
                    $A.enqueueAction(a);
                }else if(component.get("V.onSubmit") == true){
                    var a = component.get('c.approvalSubmit');  
                    $A.enqueueAction(a);
                }
            }
        
            component.set("v.saveAndClose", false);

        }else{
            console.log('v.newFormId = ' + component.get('v.newFormId'));
            //Need to add the handleSaveSuccess function content form phani here - James Lambert 1/16/2018
            var isSaveFired = component.get("v.isSaveFired");
            if(isSaveFired){
                //Commenting out modalName, newFormId - James Lambert 1/16/2018
                console.log('isSaveFired: v.newFormId = ' + component.get('v.newFormId'));
                console.log('Forms handleSaveSuccess Done.');
                component.set("v.isOpen", false);
                //component.set("v.modalName", "");
                component.set("v.message", "Your Form was saved");
                component.set("v.backupFormId",null); 
                //component.set("v.newFormId", null);
                //component.set("v.formOption", null); 
            }else{
                console.log('isSaveFired = ' + isSaveFired);
            }

            component.set("v.isSaveFired",false);
            //Added by Trellis, this is good. - James Lambert 1/16/2018
            var action = component.get("c.addTrainingRecords");  
            $A.enqueueAction(action);   
        }
        
    },
    hideAttachments: function(component, event, helper) { // hides list of attachments when user hits "hide attachments" button
        console.log("hideAttachments function called.");
        
        component.set("v.hasAttachments", false);
        component.set("v.addAttachments", false);
        component.set("v.fileName", "No File Selected..");
        component.set("v.largeFile", false);
        
    },
    saveAndSubmit : function(component, event, helper){   // saves Form and submits for approval
        console.log("saveAndSubmit function called.");
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
        console.log("saveStay function called.");
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
        console.log("showAttachments function called.");
        
        var formID = component.get("v.viewFormID"); 
          console.log('formID: ' + formID);
        
        helper.getAttachList(component, formID);
            component.set("v.addAttachments", true); 
        var a = component.get("c.createAttachComp");
        $A.enqueueAction(a);
    },
    
    viewFormTypes : function(component, event, helper){ // shows user list of available Workflow Forms
        console.log("viewFormTypes function called.");
        
        component.set("v.message", null);
        component.set("v.pageStatus", "viewFormTypes");  // shows user list of Available Workflow and Fill&Print Forms
    },
    viewMyForms : function(component, event, helper){  // gets list of user's existing Form records, adds to "v.mySavedForms"
        console.log("viewMyForms function called.");
        
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
                console.log('769 - ERROR!!!');
            }
        });
        $A.enqueueAction(action);
    },

    //Below here are the functions from oarm

    viewExistingForms : function(component, event, helper){ //Not called
        console.log("viewExistingForms function called.");
        var formID = event.currentTarget.id;
        component.set("v.selectedFormId", formID);
        
        var action = component.get("c.findExistingForms");
        action.setParams({
            "sID" : component.get("v.sessionID"),
            "rtID" : formID
        });
        action.setCallback(this,function(resp){
            console.log('action.setCallback function called in viewExistingForms');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.mySavedForms", resp.getReturnValue());
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

    saveOnly : function(component, event, helper){
        console.log("saveOnly function called. in Form Controller");
        //TSHERMAN 1.15.18

        console.log('v.newFormId = ' + component.get('v.newFormId'));
        if(event.getSource().get("v.label") == 'Next')
        {
            
            component.set("v.isPurchase",true);
        }
        else
        {
            
            component.set("v.isPurchase",false);
        }
        component.set("v.isSaveFired", true);
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
            console.log('action.setCallback function called in saveOnly');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                ;
                component.set("v.mySavedForms", resp.getReturnValue());
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
        //Changed the if conditional to the v.viewTheModal from v.isPurchase to fix logic problem. - James Lambert 1-22-18
        console.log("openModal2 function called.");
        console.log("v.viewTheModal = " + component.get("v.viewTheModal"));
        console.log("v.isPurchase = " + component.get("v.isPurchase"));
        if(!component.get("v.viewTheModal") && component.get("v.isPurchase")){
            component.set("v.isOpen", true);
            component.set("v.modalName", "");
            console.log("This still fired");
        }   
    },

    confirmDelete : function(component, event) {
        console.log("confirmDelete function called.");
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
        console.log("handleFormSelEvent function called.");
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
            helper.openFormModal(component, event,formId,formName,formOption);            
        }                
    },
    addTrainingRecords: function(component, event, helper) {
        console.log("addTrainingRecords function called.");
        document.getElementById('newFrmDiv').hidden = "hidden";
        component.set("v.trainingPageMode", "newPurchaseCard");
        component.set("v.pageStatus", "viewMyTrainings");
        
        
    },
    handleTrainingBackEvent: function(component, event, helper) {
        console.log("handleTrainingBackEvent function called.");
        var newFormDiv = document.getElementById('newFrmDiv');
        if(newFormDiv!=undefined){
            newFormDiv.hidden = "";            
        }        
        var sourceCmpUniqueId = event.getParam("sourceCmpUniqueId");
        
        component.set("v.trainingPageMode", null);
        component.set("v.pageStatus", null);
        
        if(sourceCmpUniqueId=='newPCTraingRecSuccess'){
            // Now save main form            
            helper.saveAndSubmitHelper(component, event);
        }
        component.set("v.pageStatus", "viewFormTypes");
    },

    onSaveSuccessTraining : function(component, event, helper){
        console.log("onSaveSuccessTraining function called .");

        var action = component.get("c.addTrainingRecords");  
        
        //if(currentForm == targetForm1 || currentForm == targetForm2)
        {
            $A.enqueueAction(action);
        }
    },

    //Renamed because of conflicts

    saveAndSubmitB : function(component, event, helper){
        console.log("saveAndSubmitB function called.");
        helper.saveAndSubmitHelper(component, event);
    },

    confirmSubmitB : function(component, event) {
        console.log("confirmSubmitB function called.");
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
            action = component.get("c.saveAndSubmitB");
            action.setParams({
            "formID": formID,
        });
            }
        else {action = component.get("c.viewFormJS");
            action.setParams({"formID": formID,});                       
        }
        $A.enqueueAction(action);
    },

    cancelCreationModalB : function(component, event, helper){
        console.log("cancelCreationModalB function called.");
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
            console.log('action.setCallback function in cancelCreationModalB called.');
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
    }


})