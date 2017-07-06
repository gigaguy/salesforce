({
	populateCandidateLOI : function(component, event) {
	    var action = component.get("c.getCandidateLOI");
	    action.setParams({
	      "candPkgId": component.get("v.candPackage.Id")
	    });
	    action.setCallback(this, function(response) {
	      var state = response.getState();
	      if (component.isValid() && state === "SUCCESS") {
	        component.set("v.candLOI", response.getReturnValue());
	        console.log ("TQBCPWizardRecoHelper : populateCandidateLOI response.getReturnValue() after server getCandidateLOI call = " + response.getReturnValue());

	         } else if (state === "ERROR") {
	       alert('TQBCPWizardRecoHelper : populateCandidateLOI : ERROR returnd from Apex server getCandidateLOI');
	      console.log ("TQBCPWizardRecoHelper : populateCandidateLOI response.getReturnValue() after server getCandidateLOI call = " + response.getReturnValue());
	      }
	    });
	    $A.enqueueAction(action);
   },

    getloggedInUserRole : function(component, event) {
	    var action = component.get("c.getUserRole"); // method in the apex class
	    action.setCallback(this, function(a) {
	      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
	      console.log ("TQBCPWizardRecoHelper :In helper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
	    });
	    $A.enqueueAction(action);
  },

  getTQBChairPersonList : function(component, event) {
	    var action = component.get("c.getTQBChairPersonList"); // method in the apex class
	    action.setCallback(this, function(a) {
	      console.log('TQBWizardMeetPrepHelper:getTQBChairPersonList'+a.getReturnValue());
	      component.set("v.listOfTQBChairPersons", a.getReturnValue()); // variable in the component
	    });
	    $A.enqueueAction(action);
  },

  getTQBPanelMembersList : function(component, event) {
       var action = component.get("c.getTQBPanelMembersList"); // method in the apex class
       action.setParams({
	      "candPkgId": component.get("v.candPackage.Id")
	    });
	    action.setCallback(this, function(a) {
	      console.log('TQBWizardMeetPrepHelper:getPanelMembersList'+a.getReturnValue());
	      component.set("v.listOfTQBPanelMembers", a.getReturnValue()); // variable in the component
	    });
	    $A.enqueueAction(action);
  },

  getTQBCoordinatorEmailNotification : function(component, event) {
       var action = component.get("c.getTQBCoordinatorEmailNotification"); // method in the apex class
       action.setParams({
	      "candPkgId": component.get("v.candPackage.Id")
	    });
	    action.setCallback(this, function(a) {
	      console.log('TQBWizardMeetPrepHelper:getTQBCoordinatorEmailNotification'+a.getReturnValue());
	      component.set("v.IsChairPersonEmailreceived", a.getReturnValue()); // variable in the component
	    });
	    $A.enqueueAction(action);
  },

  getTQBChairPerson : function(component, event) {
      var action = component.get("c.getTQBChairPersonName"); // method in the apex class
       action.setParams({
	      "candPkgId": component.get("v.candPackage.Id")
	    });
	    action.setCallback(this, function(a) {
	      console.log('TQBWizardMeetPrepHelper:getTQBChairPerson'+a.getReturnValue());
	      component.set("v.tqbChairPersonName", a.getReturnValue()); // variable in the component
	    });
	 
	 $A.enqueueAction(action);
  },

  getTQBAdhocMembersList : function(component, event){
     
     var action = component.get("c.getCandidateAdHocEntries"); // method in the apex class
       action.setParams({
	      "candPkgId": component.get("v.candPackage.Id")
	    });
	    action.setCallback(this, function(a) {
	      console.log('TQBWizardMeetPrepHelper:getTQBAdhocMembersList'+a.getReturnValue());
	      component.set("v.listOfAdhocSelectedMembers", a.getReturnValue()); // variable in the component
	    });
	 
	 $A.enqueueAction(action);
  }
})