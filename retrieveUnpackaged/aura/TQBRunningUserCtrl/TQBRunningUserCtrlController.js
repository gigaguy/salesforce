//----------------------------------------------
//
//
// Author: Chris Alley
// Purpose: TQBRunningUserCtrl controller that displays
// the current running user name on TQB app web pages.
//
//----------------------------------------------
({
    doInit: function(component, event, helper) {
        var action = component.get("c.getCurrentUser"); // method in the apex class
        action.setCallback(this, function(a) {
            component.set("v.runningUser", a.getReturnValue()); // variable in the component
        });
        $A.enqueueAction(action);
    }
})