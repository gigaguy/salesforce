({
    doInit: function(component, event, helper) {
        console.log('doInit: '+component.get("v.pcRecordId"));
        console.log('doInit: '+component.get("v.recordId"));
		var pcRecordId = component.get("v.pcRecordId");        
        var pageMode = component.get("v.pageMode");
        var sessionId = component.get("v.sessionID");
		//console.log('pageMode = '+pageMode +' and pcRecordId='+pcRecordId);		        
        if(sessionId!=undefined && pageMode=="showRecords"){                        
             component.set("v.isNewPCRequest",false);
			 helper.loadUserTrainings(component, event);         
        }else if(pageMode=="newPurchaseCard"){            
			component.set("v.isNewPCRequest",true);
            helper.createNewTraining(component);
        }  
        console.log('doInit: '+component.get("v.recordId"));
    },
    saveTraining: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0){
            var savingTraining = component.get('v.savingTraining');
            if(!savingTraining){
                helper.startSaving(component, event,"save");
                /*
                component.set("v.nextAction","save");
                component.set("v.savingTraining",true);
                if (component.find("fileId").get("v.files").length > 0){
                    helper.uploadHelper(component, event);            
                }else{
                    component.find("editTrainingRec").get("e.recordSave").fire();
                }
                */
            }
        }else{
            // Alert attachment is mandatory
            
            //component.set("v.recordError","Please select an attachemnt.");            
            //component.set("v.recordError","Please select an attachemnt.");            
        }                		
    },
    saveNextTraining: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0){
            var savingTraining = component.get('v.savingTraining');
            if(!savingTraining){            
                helper.startSaving(component, event,"savenext");
            }
        }else{            
            // Alert attachment is mandatory
        }                		
    },
    handleTrngSaveSuccess : function(component, event, helper){
		
		var nextAction = component.get("v.nextAction");
        var curTrainingRecordNum = component.get("v.curTrainingRecordNum");
        curTrainingRecordNum = curTrainingRecordNum + 1;
        component.set("v.curTrainingRecordNum",curTrainingRecordNum);
        component.set("v.fileName",'No File Selected..');

        if(nextAction=='savenext'){
            component.set("v.pageMode",'waiting');
            component.set("v.savingTraining",false);
            helper.createNewTraining(component);
        }else{
			helper.didCompleteSaveRecord(component,event);            
        }                                       
	},
    editTraining: function(component, event, helper) {       
        var recordId = event.currentTarget.id;
        component.set("v.isNewRecord",false);
        component.set("v.recordId",recordId);
        component.set("v.pageMode",'editRecord');        
    },
    cancelEditTraining: function(component, event, helper) {
        // Delete reocrd in DB if it is a NEW one
        var isNewRecord = component.get("v.isNewRecord");
        var recordId = component.get("v.recordId");        
        if(isNewRecord && recordId!=undefined){            
            helper.deleteTrainingRecord(component,event);
        }        
        component.set("v.pageMode",'showRecords');
    },
	viewFormTypes : function(component, event, helper) {

		var cmpEvent = component.getEvent("trainingBackEvent");
		cmpEvent.setParams({
            "sourceCmpUniqueId" : "trainingBackEvent",            
        });
        cmpEvent.fire();
	},
    newTraining : function(component, event, helper) {
        helper.createNewTraining(component);
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    }
})