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
		console.log('in helper.getFileList');
        
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
    getLineItemList : function(component, formID){   // gets list of Line Items related Form record
		console.log('in helper.getLineItemList');
        console.log('FormName: '+component.get("v.viewFormName"));
        	var formName = component.get("v.viewFormName");
        
        console.log('formID: ' + formID);     
       	//clear any previous data
       	component.set("v.displayData", null);
        component.set("v.lineItemList", null);
        
          //get list line item records
        	var action = component.get("c.getListOfLineItems");
        	action.setParams({
			"formID" : formID,
            "formName" : formName
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            console.log('getting line items list');
            console.log('name ' + name);
            console.log('return value: ' + response.getReturnValue().length);
            if (name === "SUCCESS" && response.getReturnValue().length > 0) {
                component.set("v.lineItemList", response.getReturnValue());
                component.set("v.viewLineItemList", true);
              
            var respList = response.getReturnValue();
            var rtID = respList[0].RecordTypeId;
                console.log('rtID: '+rtID);    
           
                this.getDisplayFields(component, rtID);
             }
            else {
                component.set("v.message", null);                
            }
        });
     $A.enqueueAction(action);
        
    },
    getDisplayFields : function(component, rtID){   // gets list of Line Item display fields
		console.log('in helper.getDisplayFields');
            //get list of fields to display
          	
       		var action = component.get("c.getLineItemDisplayFields");
        	action.setParams({
			"rtID" : rtID,    
        });
        
     action.setCallback(this, function(response){
            var name = response.getState();
            console.log('getting line item display field list');
            console.log('name ' + name);
            
            if (name === "SUCCESS" && response.getReturnValue().length > 0) {
			  console.log('return value: ' + response.getReturnValue().length);
                
                var fields = response.getReturnValue();
                var fieldsSize = fields.length;
                console.log("fieldsSize: "+fieldsSize);
                
                component.set("v.displayOne", fields[0].trim());
                if(fieldsSize>1){component.set("v.displayTwo", fields[1].trim());}
                if(fieldsSize>2){component.set("v.displayThree", fields[2].trim());}
                if(fieldsSize>3){component.set("v.displayFour", fields[3].trim());}
                if(fieldsSize>4){component.set("v.displayFive", fields[4].trim());}
                
                var displayFields = [];
                for(var i=0;i<fieldsSize;i++){
                    displayFields[i] = fields[i].trim();
                }
                this.getDisplayData(component, displayFields);
             }
            else {
                component.set("v.message", null);
            }
        });
     $A.enqueueAction(action);               	
        
    },
    getDisplayData: function(component, displayFields) {
        console.log('in helper.getDisplayData');
        
        var d1;
        var d2;
        var d3;
        var d4;
        var d5;
         d1 = displayFields[0];
         if(displayFields.length>=2){d2=displayFields[1];}
         if(displayFields.length>=3){d3=displayFields[2];}
         if(displayFields.length>=4){d4=displayFields[3];}
		 if(displayFields.length>=5){d5=displayFields[4];}        
        var formID = component.get("v.viewFormID");
        var action = component.get("c.getLineItemDataFields");
        	action.setParams({
				"d1" : d1,
                "d2" : d2,
                "d3" : d3,
                "d4" : d4,
                "d5" : d5,
            	"formID" : formID
        });
        
     action.setCallback(this, function(response){
            var name = response.getState();
            console.log('getting line item display data list');
            console.log('name ' + name);  
         
            if (name === "SUCCESS" && response.getReturnValue().length > 0) {
            console.log('return value: ' + response.getReturnValue().length);
                component.set("v.displayData", response.getReturnValue());
                component.set("v.displayFieldsCount", displayFields.length);
                component.set("v.displayCols", displayFields.length+1);               
             }
            else {
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