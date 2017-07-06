({
	// Gets the logged in users' role so that the comment boxes can be enabled or disabled based on role name.
  getloggedInUserRole : function(component, event) {
    var action = component.get("c.getUserRole"); // method in the apex class
    action.setCallback(this, function(a) {
      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component// component.set("v.loggedInUserRole.UserRole.Name", "TQB 1st Line Supervisor Role"); // variable in the component
      console.log ("TQBCPWizardAdHocHelper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
    });
    $A.enqueueAction(action);
  }
})