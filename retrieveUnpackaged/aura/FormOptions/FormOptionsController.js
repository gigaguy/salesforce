({    
    doInit : function(component, event, helper) {
        
        var formTypeId = component.get("v.formTypeId");		        
        if(formTypeId!=undefined && formTypeId!=null){
            
            var action = component.get("c.getAllFormOptions");
            action.setParams({                
                    "formTypeId" : formTypeId
                });
            
            action.setCallback(this,function(resp){                	
                    var state = resp.getState();	                
                    if(state === 'SUCCESS'){                    
                        var result = resp.getReturnValue();
						component.set("v.formTypeOptions", result);
                    }
                });
            $A.enqueueAction(action);
        }        
    },
	cancelCreationModal : function(component, event, helper){
        var cmpEvent = component.getEvent("formOptionSelEvent");
		cmpEvent.setParams({
            "formOption" : "",
            "isCancelled" : true
        });
        cmpEvent.fire();
    },
    
    nextAction:function(component, event, helper) {
        var selectedOption;
        var options = component.get("v.formTypeOptions");
        for(var co = 0; co<options.length;co++){
            var item = document.getElementById('option'+co);
            if(item.checked){
                selectedOption = options[co];
                break;
            }
        }
        if(selectedOption==undefined){
            alert('Please select an option.');
        }
        else{
			var cmpEvent = component.getEvent("formOptionSelEvent");
			cmpEvent.setParams({
    	        "formOption" : selectedOption,
        	    "isCancelled" : false
	        });
    	    cmpEvent.fire();            
        }                
    }
})