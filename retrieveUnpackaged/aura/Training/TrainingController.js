({
    doInit: function(component, event, helper) {
        console.log('doInit: '+component.get("v.pcRecordId"));
        console.log('doInit: '+component.get("v.recordId"));
        
        //T.S. 1/17/18 show navDiv and hide editdiv
        var navCmp = component.find("NavDiv");
        $A.util.addClass(navCmp, 'slds-show');
        $A.util.removeClass(navCmp, 'slds-hide');
        helper.initHide(component) 
        
        
        var pcRecordId = component.get("v.pcRecordId");        
        var pageMode = component.get("v.pageMode");
        var sessionId = component.get("v.sessionID");
        console.log('This will show in the console');
        console.log('TrainingController doInit function: pcRecordId = ' + pcRecordId + ' pageMode = ' + pageMode + ' sessionId = ' + sessionId);
        //console.log('pageMode = '+pageMode +' and pcRecordId='+pcRecordId);               
        if(sessionId!=undefined && pageMode=="showRecords"){                        
             component.set("v.isNewPCRequest",false);
             helper.loadUserTrainings(component, event);         
        }else if(pageMode=="newPurchaseCard"){            
            component.set("v.isNewPCRequest",true);
            helper.createNewTraining(component);
        }     
        //ts 1.17.18 // call helper to remove hide class
        helper.initShow(component);
    },
    saveTraining: function(component, event, helper) {
        console.log('saveTraining function in TriningController was called');
        console.log("This is were the problem is. length is = " + component.find("fileId").get("v.files").length);
        if (component.find("fileId").get("v.files").length > 0){
            
            var myError = event.getParam('errors');
            console.log('the event.getParam errors = ' + myError);

            var savingTraining = component.get('v.savingTraining');
            var triedToSaveTraining = component.get('v.triedToSaveTraining');

            console.log("savingTraining = " + savingTraining);
            if(!savingTraining || triedToSaveTraining){
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
    //this is where the trouble ends. - James Lambert 1/16/2018
    //Commenting saveNextTraining out for test. - James Lambert 1/15/2018
    saveNextTraining: function(component, event, helper) {
        console.log('saveNextTraining function called.');
      //  console.log('~Line 46: saveNexTraining function in TrainingController was called.');
       // console.log("This is were the problem is. length is = " + component.find("fileId").get("v.files").length);
        if (component.find("fileId").get("v.files").length > 0){
          
            //Setting this to false to start keep it from freezing up if there is a validation rule. - James Lambert 1-22-18
          //var savingTraining = component.get('v.savingTraining');
          var savingTraining = false;
          console.log("v.savingTraining " + component.get('v.savingTraining') );
            if(!savingTraining){            
                helper.startSaving(component, event,"savenext");
            }
        }else{            
            // Alert attachment is mandatory
      //      alert('Line 57 ERROR');
        }                       
    },
    handleTrngSaveSuccess : function(component, event, helper){
        console.log('handleTrngSaveSuccess function called');
        var nextAction = component.get("v.nextAction");
        var curTrainingRecordNum = component.get("v.curTrainingRecordNum");
        curTrainingRecordNum = curTrainingRecordNum + 1;
        component.set("v.curTrainingRecordNum",curTrainingRecordNum);
        component.set("v.fileName",'No File Selected..');

        if(nextAction=='savenext'){
            component.set("v.pageMode",'waiting');
            component.set("v.savingTraining",false);
            component.set("v.triedToSaveTraining", false);
            helper.createNewTraining(component);
        }else{
            helper.didCompleteSaveRecord(component,event);            
        }                                       
    },
    editTraining: function(component, event, helper) {  
        console.log('editTraining function called');
        var recordId = event.currentTarget.id;
        component.set("v.isNewRecord",false);
        component.set("v.recordId",recordId);
        component.set("v.pageMode",'editRecord');        
    },
    cancelEditTraining: function(component, event, helper) {
        console.log('canceleditTraining function called');
        // Delete reocrd in DB if it is a NEW one
        var isNewRecord = component.get("v.isNewRecord");
        var recordId = component.get("v.recordId");        
        if(isNewRecord && recordId!=undefined){            
            helper.deleteTrainingRecord(component,event);
        }        
        component.set("v.pageMode",'showRecords');
    },
    viewFormTypes : function(component, event, helper) {
        console.log('viewFormTypes function called');
        var cmpEvent = component.getEvent("trainingBackEvent");
        cmpEvent.setParams({
            "sourceCmpUniqueId" : "trainingBackEvent",            
        });
        cmpEvent.fire();
    },
    newTraining : function(component, event, helper) {
        console.log('newTraining function called');
        helper.createNewTraining(component);
    },
    handleFilesChange: function(component, event, helper) {
        console.log('handleFilesChange function called.');
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    }
})