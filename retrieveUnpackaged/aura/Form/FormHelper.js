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

        console.log('openFormModal.');
        //var formID = event.currentTarget.id;
        //var formName = event.currentTarget.name;
        
        if (formName === "BAP Provisioning") {
            var hrefInfo = "mailto:BAP_Admins@epa.gov?subject=Help%20request%3A%20%20"+formName+"%20Form";
        	var hrefEmail = "BAP_Admins@epa.gov";
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
			console.log('in action');
            var state = resp.getState();
            console.log('state: ' +state);
            if(state === 'SUCCESS'){
                
                component.set("v.newForm", resp.getReturnValue());
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