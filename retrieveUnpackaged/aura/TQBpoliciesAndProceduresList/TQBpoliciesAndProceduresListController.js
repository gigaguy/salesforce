({
	doInit  : function(component, event) {
		var action = component.get("c.getPoliciesAndProcedures");
        action.setCallback(this, function(a) {
             component.set("v.TQBpoliciesAndProceduresList", a.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})