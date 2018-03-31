({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    getFandP_Forms : function(component){   // gets list of available Fill&Pring Forms
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
    checkLineItemEnabled : function(component, formName){    //checks if Form RT is Line Item Enabled
    	console.log('in helper.checkLineItemEnabled');
        
        var action = component.get("c.isLineItemEnabled");
        	action.setParams({
			"formName" : formName
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            console.log('checking if line item enabled');
            console.log('name ' + name);
            console.log('response ' + response.getReturnValue());
            if (name === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp==='notEnabled'){
                component.set("v.rtLineItemEnabled", false);
                }
                else if (resp==='grid'){
                    component.set("v.gridEnabled",true);
                    component.set("v.rtLineItemEnabled", false);
                }
                else {
                    component.set("v.rtLineItemEnabled", true);
                    var rtID = resp;
                    this.getDisplayFields(component, rtID);
                }
             }
            else {
                component.set("v.rtLineItemEnabled", false);
            }
        });
     $A.enqueueAction(action);
        
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
    //   	component.set("v.displayData", null);
     //   component.set("v.lineItemList", null);
        
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
                component.set("v.lineItemCount", response.getReturnValue().length);
            var respList = response.getReturnValue();
            var rtID = respList[0].RecordTypeId;
                console.log('rtID: '+rtID);    
           
                this.getDisplayData(component, rtID);
             }
            else {
                component.set("v.message", null);      
                component.set("v.displayFieldsCount", 0);
                component.set("v.viewLineItemList", true);
            }
        });
     $A.enqueueAction(action);
        
    },
    getDisplayFields : function(component, rtID){   // gets list of Line Item display fields
		console.log('in helper.getDisplayFields');
            //get list of fields to display
          	
        console.log('rtID: '+rtID);
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
              
                if(fields[fieldsSize-1].trim()=='No Create'){
                    component.set("v.lineItemNoCreate", true);
                	fieldsSize=fieldsSize-1;
                }
                  else {component.set("v.lineItemNoCreate", false);}
                
                
                component.set("v.displayOne", fields[0].trim()); console.log('display1: '+component.get("v.displayOne"));
                if(fieldsSize>1){component.set("v.displayTwo", fields[1].trim());}
                if(fieldsSize>2){component.set("v.displayThree", fields[2].trim());}
                if(fieldsSize>3){component.set("v.displayFour", fields[3].trim());}
                if(fieldsSize>4){component.set("v.displayFive", fields[4].trim());}
                
                var displayFields = [];
                for(var i=0;i<fieldsSize;i++){
                    displayFields[i] = fields[i].trim();
                }
       //         this.getDisplayData(component, rtID);
             }
            else {
                component.set("v.message", null);
            }
        });
     $A.enqueueAction(action);               	
        
    },
    getDisplayData: function(component, rtID) {
        console.log('in helper.getDisplayData');
        console.log('rtID: '+rtID);
        
        var descList = component.get("c.getLineItemDataFields");
        descList.setParams({"rtID" : rtID});
        descList.setCallback(this, function(resp){var state = resp.getState();
                 if (state === "SUCCESS"){
        var displayFields = resp.getReturnValue();     
        var fieldsSize = displayFields.length;
                     if(displayFields[fieldsSize-1].trim()=='No Create'){
                         fieldsSize=fieldsSize-1;
                     }
                     component.set("v.displayFieldsCount", fieldsSize);   console.log('displayfieldscount: '+fieldsSize);                                 
        component.set("v.displayCols", fieldsSize+1); 
        var d1;
        var d2;
        var d3;
        var d4;
        var d5;
                     d1 = displayFields[0].trim();  console.log('d1: '+d1);
         if(fieldsSize>=2){d2=displayFields[1].trim();console.log('d2: '+d2);}
         if(fieldsSize>=3){d3=displayFields[2].trim();console.log('d3: '+d3);}
         if(fieldsSize>=4){d4=displayFields[3].trim();console.log('d4: '+d4);}
		 if(fieldsSize>=5){d5=displayFields[4].trim();console.log('d5: '+d5);}                                                
		var formID = component.get("v.viewFormID");
                     console.log('formID: '+formID);
        var action = component.get("c.getLineItemData");
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
                      //      component.set("v.displayData", response.getReturnValue());
                            var field = "Display1__c";
            				var sortAsc = true;
                            var records = response.getReturnValue();
                            var sortField = component.get("v.sortField");
                      //      sortAsc = field == sortField? !sortAsc: true;
                             records.sort(function(a,b){
                                var t1 = a[field] == b[field],
                                    t2 = a[field] > b[field];
                                return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
                            });
                            component.set("v.sortAsc", sortAsc);
                            component.set("v.sortField", field);
                            component.set("v.displayData", records);
                         }
                        else {
                            console.log('error: '+response.getError());
                            component.set("v.message", null);
                        }
                    });
                 $A.enqueueAction(action);                                              
  			}
              else {console.log('error: '+resp.getError());}
               });
        $A.enqueueAction(descList);
        
    },
    getSupportInfo : function(component, formID, formName){
        console.log('in helper.getSupportInfo');
        console.log('formID: '+formID);
        console.log('formName: '+formName);
        
        	var action = component.get("c.formSupportInfo");
        action.setParams({
            formID : formID,
            formName : formName
        });
        
        action.setCallback(this, function(response){
                        var name = response.getState();
                        console.log('getting support info');
                        console.log('name ' + name);  
                     
            if (name === "SUCCESS") {
                console.log('no error');
                component.set("v.viewFormSupport", response.getReturnValue());
            	}
            else {console.log('error: '+response.getError());
                 let errors = response.getError();
					let message = 'Unknown error'; // Default error message
					// Retrieve the error message sent by the server
					if (errors && Array.isArray(errors) && errors.length > 0) {
				      message = errors[0].message;
                        }
                        // Display the message
                        console.error(message);}
            });
        $A.enqueueAction(action);
    },
    lineItemSortBy : function(component, field){
        console.log('in helper.lineItemSortBy');
        
        var sortAsc = component.get("v.sortAsc");
        var records = component.get("v.displayData");
		var sortField = component.get("v.sortField");
        sortAsc = field == sortField? !sortAsc: true;
         records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.displayData", records);
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
        var formID;
        if(component.get("v.addAttachments")==true){ 
            formID = component.get("v.viewFormID");
           }
         else if(component.get("v.addLineItemAttachments")==true){  
             formID = component.get("v.viewLineItemID");
           }
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
    },
    setFormName : function(component) {
        console.log('in helper.setFormName');
        
        var formID = component.get("v.viewFormID");
        console.log('formID: ', formID);
        var action = component.get("c.getFormName");
        action.setParams({
            "formID": formID,
            "sID" : component.get("v.sessionID")
        });
         //set call back
         action.setCallback(this, function(response) {
            var state = response.getState();
             console.log('response state: '+state);
            if (state === "SUCCESS") {
                var formName = response.getReturnValue();
                console.log('helper received formName: '+formName);
                
                if(formName!='unauthorized'){
                component.set("v.viewFormName", formName);                
                var a = component.get("c.createTheModal");
       			$A.enqueueAction(a); 
                  }
                else {alert('You do not have access to this Form.');
                     var a = component.get("c.viewMyForms");
                      $A.enqueueAction(a);
                     }
            }
             else {var errors = response.getError();
                console.log('error');
             }
         });
        // enqueue the action
        $A.enqueueAction(action);
    }
    
})