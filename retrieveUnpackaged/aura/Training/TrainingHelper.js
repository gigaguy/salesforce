({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
	createNewTraining : function(component) {
        var sessionId = component.get("v.sessionID");
        var pcRecordId = component.get("v.pcRecordId");
        //console.log('createNewTraining '+sessionId + ' pcRecordId= '+pcRecordId);
        if(sessionId!=undefined){
            // Insert a new Training record                        
            var action = component.get("c.insertTrainingForm");            
            action.setParams({
                "sID" : sessionId,
                "pcRecordId" : pcRecordId
            });
            action.setCallback(this,function(resp){
                var state = resp.getState();
                
                if(state === 'SUCCESS'){
                    var result = resp.getReturnValue();
                    var recordId = result.Id;
                    component.set("v.recordId",recordId);
                    console.log('\nNew Form\n'+JSON.stringify(result));
                    component.set("v.pageMode",'editRecord');
                    component.set("v.isNewRecord",true);                    
                }});
            $A.enqueueAction(action);
        }		                        
	},
    startSaving: function(component,event,saveActionType) {
        component.set("v.nextAction",saveActionType);
        component.set("v.savingTraining",true);
        if (component.find("fileId").get("v.files").length > 0){
             this.uploadHelper(component, event);            
          }else{
             component.find("editTrainingRec").get("e.recordSave").fire();
        }
    },
    loadUserTrainings : function(component,event) {
        //Get all user Training records
        var sessionId = component.get("v.sessionID");			
        var action = component.get("c.getUserTrainingForms");            
        action.setParams({
            "sID" : sessionId
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                var result = resp.getReturnValue();
                component.set("v.trainingForms",result);                
            }});
        $A.enqueueAction(action);
    },
    deleteTrainingRecord : function(component,event) {
        var action = component.get("c.deleteForm");
        var recordId = component.get("v.recordId");
        action.setParams({
            "formID":recordId
        });
        action.setCallback(this,function(resp){
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS >'){
                component.set("v.message", '');
            }
            else if(state === 'ERROR'){
                var errors = resp.getError();
				console.log(JSON.stringify(errors));                
            }
            // Redirect user back to PC form if it is a new pruchase card flow.
            var isNewPCRequest = component.get("v.isNewPCRequest");
    		if(isNewPCRequest){            
            	var cmpEvent = component.getEvent("trainingBackEvent");
				cmpEvent.setParams({
    	        	"sourceCmpUniqueId" : "newPCCancelTraining",            
        		});
	        	cmpEvent.fire();
    	    }
        });
        $A.enqueueAction(action);
    },
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
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
    didCompleteSaveRecord:function(component,event){
        component.set("v.recordId",undefined);
        component.set("v.savingTraining",false);
        
        var sessionId = component.get("v.sessionID");
        var isNewPCRequest = component.get("v.isNewPCRequest");
        console.log('isNewPCRequest '+isNewPCRequest);
    	if(isNewPCRequest){            
            var cmpEvent = component.getEvent("trainingBackEvent");
			cmpEvent.setParams({
            	"sourceCmpUniqueId" : "newPCTraingRecSuccess",            
        	});
        	cmpEvent.fire();
        }
        else if(sessionId!=undefined){  
            component.set("v.pageMode",'showRecords');
			this.loadUserTrainings(component, event);         
        }
	},
    uploadProcess: function(component, file, fileContents) {
        
        
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, component.get("v.tempAttachId"));
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        var recordId = component.get("v.recordId"); 
        
        action.setParams({
            parentId: recordId,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            
            var state = response.getState();
                      
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                
                if (startPosition < endPosition && false) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, response.getReturnValue());
                } else {                    
                    component.set("v.showLoadingSpinner", false);
                    try {
                        component.find("editTrainingRec").get("e.recordSave").fire();              
                      }
                      catch (e) {
                        console.log(e);
                      }
                    //this.didCompleteSaveRecord(component);
                }
                // handel the response errors        
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
    }
})