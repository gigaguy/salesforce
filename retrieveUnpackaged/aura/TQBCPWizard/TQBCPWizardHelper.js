({
	populatePackage : function(component, event) {
		 //var action = component.get("c.getCandidatePackage");
		 var packageId = component.get("v.packageId");
		 console.log('TQBCPWizardHelper : populatePackage : cand packageId = '+ packageId);
		var action = component.get("c.getOrCreateCandidatePackage");
		action.setParams({
			"candPkgId": packageId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				component.set("v.newPackage", response.getReturnValue());
				console.log('TQBCPWizardHelper : populatePackage : inside setcallback'+ response.getReturnValue());
				var evt = $A.get("e.c:TQBCPQuestionNavigator");
				evt.setParams({ "candpkg": response.getReturnValue() });
				evt.fire();
			}
		});
		$A.enqueueAction(action);
	},

	populatePackageStatus : function(component, event) {
		var action = component.get("c.getCPStatusPickListValues");
		var inputsel = component.find("InputSelectDynamic");
		var opts=[];
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var returnVal = response.getReturnValue();
				console.log('returnVal = ' + returnVal);
				for(var i = 0; i< returnVal.length; i++){
					opts.push({"class": "optionClass", label: returnVal[i], value: returnVal[i]});
				}
			}
			inputsel.set("v.options", opts);
		});
		$A.enqueueAction(action);
	},
	goToQuestionnaire : function(component, event) {
		var pkg = component.get("v.newPackage");
		var evt = $A.get("e.c:TQBCPQuestionNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();
	},
	getloggedInUserRole : function(component, event) {
       var action = component.get("c.getUserRole"); // method in the apex class
	    action.setCallback(this, function(a) {
	      component.set("v.loggedInUserRole", a.getReturnValue()); // variable in the component
	      console.log ("TQBFileControllerHelper : getloggedInUserRole : loggedInUserRole = " + component.get("v.loggedInUserRole.UserRole.Name"));
	    });
     $A.enqueueAction(action);
  }
	/*populate1stLineSup: function(component, event) {
		var action = component.get("c.get1stLineSupCurrentValue");
		action.setParams({
			"candPkgId": component.get("v.newPackage.Id")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				console.log('response.getReturnValue() = ' + response.getReturnValue());
				component.set("v.newPackage.Candidates_1st_Line_Supervisor_Name__c", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}*/

})