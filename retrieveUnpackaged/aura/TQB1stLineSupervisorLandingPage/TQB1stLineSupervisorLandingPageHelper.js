({
	getLOIList : function(component) {
        var action = component.get("c.getLOIs");
        action.setCallback(this, function(a) {
             console.log(a.getReturnValue());
             component.set("v.TQBLetterOfIntentList", a.getReturnValue());
        });
        $A.enqueueAction(action);		
	},
    getCPList : function(component) {
        var action = component.get("c.getCPs");
        action.setCallback(this, function(a) {
             console.log(a.getReturnValue());
             component.set("v.TQBCandidatePackageList", a.getReturnValue());
        });
        $A.enqueueAction(action);		
	},
})