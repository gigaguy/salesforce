({
    getFandP_Forms : function(component){
    	var action = component.get("c.getFandP_FormRTs");
       
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.FandP_forms", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
	},
    openFormModal: function(component, event, formID, formName,formOption) {
        
        //var formID = event.currentTarget.id;
        //var formName = event.currentTarget.name;
        //console.log(component.get("v.sessionID") + '='+formID + '='+formOption);
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
        component.set("v.selectedFormId", formID);
        component.set("v.selectedFormName", formName);
        component.set("v.hrefInfo", hrefInfo);
        component.set("v.hrefEmail", hrefEmail);
        
		var action = component.get("c.insertNewForms");
        action.setParams({
			"sID" : component.get("v.sessionID"),
            "rtID" : formID,
            "formOption" : formOption
        });
        
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(state === 'SUCCESS'){
                var formObj = resp.getReturnValue();
                component.set("v.newForm", formObj);
                component.set("v.newFormId", formObj.Id);
               // console.log(JSON.stringify(formObj));
               //Download Form introduction text if applicabl
               var formName = component.get("v.backupFormId");
               console.log('formName '+formName);
               /*
               if(formName!=undefined && formName =='Purchase Card'){
                    var introAction = component.get("c.getFormIntroduction");
                    introAction.setParams({
                        "getFormIntroduction" : formName
                    });
                   introAction.setCallback(this,function(resp1){
                       var state = resp1.getState();
                       if(state === 'SUCCESS'){
                           var introText = resp1.getReturnValue();
                           console.log(introText);
                           var introDiv = document.getElementById('formIntro');
                           introDiv.innerHTML = introText;
                       }
          	         });
                }*/
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
    saveAndSubmit: function(component, event){

        console.log('saveAndSubmit');
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
        var action = component.get("c.findExistingForms");
        action.setParams({
			"sID" : component.get("v.sessionID")
        });
        action.setCallback(this,function(resp){
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                component.set("v.oldForms", resp.getReturnValue());
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
	}
})