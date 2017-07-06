({
	getCPList : function(component) {
        var action = component.get("c.getCPs");
        action.setCallback(this, function(a) {
             console.log(a.getReturnValue());
             component.set("v.TQBCandidatePackageList", a.getReturnValue());
        });
        $A.enqueueAction(action);		
	}
})