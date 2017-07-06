({
    doInit : function(component, event, helper) {
    	helper.buildPicklistValues(component, event, helper);
    },
    shiftRight : function(component, event, helper) {
    if(component.get("v.addSelectedValues").length > 0)
        {
            helper.shiftRight(component, event, helper);
        } 
        else 
        {
            alert("Please select atleast one value");
        }
 	},
    shiftLeft : function(component, event, helper) {
    if(component.get("v.removeSelectedValues").length > 0)
    	{
    		helper.shiftLeft(component, event, helper);
    	} 
        else 
        {
    		alert("Please select atleast one value to Move to Left");
    	}
    }
})