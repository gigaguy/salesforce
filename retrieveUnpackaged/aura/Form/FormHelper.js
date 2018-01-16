({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb
	//Checked and Good
	getFandP_Forms : function(component){
        console.log("helper.getFandP_Forms function called");
    	var action = component.get("c.getFandP_FormRTs");
       
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.FandP_forms", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
	},
	//Checked and Good
	setSiteUserID : function(component) {	// set siteUserID for temp record sharing 
        console.log("helper.setSiteUserID function called");
        
        var action = component.get("c.getSiteUserID");
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.siteUserID", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
    },
    //Checked and Good
    setAPIUserID : function(component) {	// set apiUserID for temp record sharing
        console.log("helper.setAPIUserID function called");
        
        var action = component.get("c.getAPIUserID");
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.apiUserID", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
    },

    //Checked and Good
    show: function (cmp, event) {     // shows Lightning spinner
        console.log("helper.show function called");
        
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hide:function (cmp, event) {       // hides Lightning spinner
        console.log("helper.hide function called");
        
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },


    //This is from oarm. Should be fine from all other calls.
    openFormModal: function(component, event, formID, formName,formOption) {
        console.log("helper.openFormModal function called");
        
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

        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);



        component.set("v.selectedFormId", formID);
        component.set("v.selectedFormName", formName);
        
        
        var action = component.get("c.insertNewForms");
        action.setParams({
            "sID" : component.get("v.sessionID"),
            "rtID" : formID,
            "siteUserID" : component.get("v.siteUserID"),//Will need to check these two.
            "apiUserID" : component.get("v.apiUserID"),
            "formOption" : formOption
        });
        
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(state === 'SUCCESS'){
                
                if(formOption!=undefined){
                   component.set("v.formOption", formOption); 
                    //Download Form introduction text if applicabl
                   this.getFormIntroduction(component, event,formOption);
                }
                var formObj = resp.getReturnValue();
                component.set("v.newForm", formObj);
                component.set("v.newFormId", formObj.Id);

                
               // console.log(JSON.stringify(formObj));                              
            }
            else if(state === 'ERROR'){
                component.set("v.newFormId", null);
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    //Below is unique to t2 and not part of the merge
    getAttachList : function(component, formID){   // gets list of attachments on Form record
        console.log("helper.getAttachList function called");
        component.set("v.attachList", null);
        component.set("v.fileList", null);
        console.log('formID: ' + formID);     
            var action = component.get("c.getListOfAttachments");
            action.setParams({
            "formID" : formID
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            console.log('getting attachment list');
            console.log('name ' + name);
            console.log('return value: ' + response.getReturnValue().length);
            if (name === "SUCCESS" && response.getReturnValue().length > 0) {
            
                component.set("v.attachList", response.getReturnValue());
                component.set("v.hasAttachments", true);
             }
            else {
                component.set("v.hasAttachments", false);
                component.set("v.message", null);
            }
        });
     $A.enqueueAction(action);
        this.getFileList(component, formID);
    },
    getFileList : function(component, formID){   // gets list of files on Form record
        console.log("helper.getFileList function called");
        
        console.log('formID: ' + formID);     
            var action = component.get("c.getListOfFiles");
            action.setParams({
            "formID" : formID
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            console.log('getting files list');
            console.log('name ' + name);
            console.log('return value: ' + response.getReturnValue().length);
            if (name === "SUCCESS" && response.getReturnValue().length > 0) {
            
                component.set("v.fileList", response.getReturnValue());
                component.set("v.hasAttachments", true);
             }
            else {
            //    component.set("v.hasAttachments", false);
                component.set("v.message", null);
            }
        });
     $A.enqueueAction(action);
    },
    uploadHelper: function(component, event) {  // part of attachment upload process
        console.log("helper.uploadHelper function called");
        
        // get the selected files using aura:id [return array of files]
        var fileInput = component.get("v.uploadFiles");
       
        // get the first file using array index[0]  
        var file = fileInput[0][0];
        var self = this;
        
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            console.log('in file too big');
            component.set("v.showLoadingSpinner", false);
            component.set("v.largeFile", true);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes. ' + 
                          ' Selected file size: ' + file.size + '<br/>' +
                          ' Please click here to upload a large file: '); 
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },
    uploadProcess: function(component, file, fileContents) {   // part of attachment upload process
        console.log("helper.uploadProcess function called");
        
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {  // part of attachment upload process
        console.log("helper.uploadInChunk function called");
        
        // call the apex method 'saveChunk'
    //    var formID = component.get("v.parentId");
        var formID = component.get("v.viewFormID");
        console.log('formID: ' + formID);
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: formID,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    alert('Your file has uploaded successfully.');
                    component.set("v.largeFile", false);
                    component.set("v.showLoadingSpinner", false);
                    this.getAttachList(component, formID);
                    component.set("v.hasAttachments", true);
                    component.set("v.fileName", null);
                    
                }
                // handle the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    setSiteUserID : function(component) {   // set siteUserID for temp record sharing         
        console.log("helper.setSiteUserID function called");
        
        var action = component.get("c.getSiteUserID");
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.siteUserID", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
    },
    setAPIUserID : function(component) {    // set apiUserID for temp record sharing
        console.log("helper.setAPIUserID function called");
        
        var action = component.get("c.getAPIUserID");
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.apiUserID", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
    },

    //Below is unique to oarm and not part of the merge
    getFormIntroduction:function(component, event, formName){
        console.log("helper.getFormIntroduction function called");
        var introAction = component.get("c.getFormIntroduction");
        introAction.setParams({
            "formName" : formName
        });
        introAction.setCallback(this,function(resp1){
            var state = resp1.getState();
            if(state === 'SUCCESS'){
                var introText = resp1.getReturnValue();                
                var introDiv = document.getElementById('formIntro');                
                introDiv.innerHTML = introText;
            }
        });
        $A.enqueueAction(introAction);
    },
    saveAndSubmit: function(component, event){
        console.log("helper.saveAndSubmit function called");

        component.set("v.isSaveFired", true);
        component.find("edit").get("e.recordSave").fire();        
        // Temporary checking for modals to allow submitting from new form or view form
        var formID;
        if (component.get("v.modalName") == 'viewForm') {
            formID = component.get("v.viewFormID");
        }
        else {
            formID = component.get("v.newForm.Id");
        }
        var recordTypeId;
        var formObj = component.get("v.newForm");
        if(formObj!=undefined){
            recordTypeId=formObj.RecordTypeId;
        }
        console.log('recordTypeId '+recordTypeId);
        
        var action = component.get("c.submitForApproval");
        action.setParams({
            "formID": formID,
            "sID" : component.get("v.sessionID"),
            "recordTypeId" : recordTypeId
        });
        action.setCallback(this,function(resp){
            console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            component.set("v.backupFormId",null);
            component.set("v.newFormId", null);
            
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
        var action2 = component.get("c.findExistingForms");
        action2.setParams({
            "sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
            console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.mySavedForms", resp.getReturnValue());
                component.set("v.pageStatus", "viewMyForms");
                // Can call Training form here
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action2); 
        
        /*t.s. 1.15.18
         var action = component.get("c.findExistingForms");
        action.setParams({
            "sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
            console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.mySavedForms", resp.getReturnValue());
                component.set("v.pageStatus", "viewMyForms");
                // Can call Training form here
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
                for(var i = 0 ;i < errors.length;i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);  
         */
    },

    //Renambed because of conflicts.
    
})