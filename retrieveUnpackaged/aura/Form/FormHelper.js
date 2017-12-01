({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    getFandP_Forms : function(component){     // gets list of available Fill&Print Forms
        console.log('in helper.getFandP_Forms');
    	var action = component.get("c.getFandP_FormRTs");
       
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.FandP_forms", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
	},
    show: function (cmp, event) {     // shows Lightning spinner
        console.log('in helper.show');
        
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hide:function (cmp, event) {       // hides Lightning spinner
        console.log('in helper.hide');
        
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    getAttachList : function(component, formID){   // gets list of attachments on Form record
		console.log('in helper.getAttachList');
        
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
	},
    uploadHelper: function(component, event) {  // part of attachment upload process
        console.log('in helper.uploadHelper');
        
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
        console.log('in helper.uploadProcess');
        
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
        console.log('in helper.uploadInChunk');
        
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
    setSiteUserID : function(component) {	// set siteUserID for temp record sharing         
        console.log('in helper.setSiteUserID');
        
        var action = component.get("c.getSiteUserID");
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.siteUserID", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
    },
    setAPIUserID : function(component) {	// set apiUserID for temp record sharing
		console.log('in helper.setAPIUserID');
        
        var action = component.get("c.getAPIUserID");
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.apiUserID", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
    }
    
})