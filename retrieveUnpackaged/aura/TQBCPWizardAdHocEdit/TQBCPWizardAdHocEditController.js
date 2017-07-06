({
	gotoAdHocEditable: function(component, event, helper) {
		var selected = event.getParam("candpkg");
		console.log(selected);
		component.set("v.candPackage",selected);
		selected = event.getParam("adhocEdit");
		console.log(selected);
		component.set("v.adHocEntry",selected);
		helper.populateStateValues(component);
	},

	gotoAdHocNew: function(component, event, helper) {
    console.log("==============================================");
    console.log("INFO - TQBCPWizardAdHocEditController : gotoAdHocNew : START");
    console.log("==============================================");		

		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
		selected = event.getParam("adhocNew");
		component.set("v.adHocEntry",selected);
		helper.populateStateValues(component);
	},
	backToAdHocList : function(component, event, helper) {
		var evt = $A.get("e.c:TQBCPBackToAdHocList");
		evt.fire();
	},
	cancelAdHocSave : function(component, event, helper) {
	    console.log("==============================================");
	    console.log("INFO - TQBCPWizardAdHocEditController : cancelAdHocSave : START");
	    console.log("==============================================");		
		var onRecoReviewScreen = component.get("v.onRecoReviewScreen");
  		console.log("INFO - TQBCPWizardAdHocEditController :  onRecoReviewScreen after component.get = " + onRecoReviewScreen);
		component.set("v.onRecoReviewScreen",onRecoReviewScreen);
   		console.log("INFO - TQBCPWizardAdHocEditController :  onRecoReviewScreen after component.set = " + onRecoReviewScreen);

		if (onRecoReviewScreen == 'true'){
    		console.log("INFO - TQBCPWizardAdHocEditController : fire event: TQBCPRecoNavigator onRecoReviewScreen = " + onRecoReviewScreen);
			var pkg = component.get("v.candPackage");   
			var adHocEntries = component.get("v.listOfAdHocEntries");

			var evt = $A.get("e.c:TQBCPRecoNavigator");
			evt.setParams({ "candpkg": pkg, "recoType": "approve", "listOfAdHocEntries" : adHocEntries });
			evt.fire();

		} else {
    		console.log("INFO - TQBCPWizardAdHocEditController : fire event: TQBCPBackToAdHocDetail onRecoReviewScreen = " + onRecoReviewScreen);

			var evt = $A.get("e.c:TQBCPBackToAdHocDetail");
			evt.fire();
		}

	},
	validateAndSaveAdHoc : function(component, event, helper) {
    console.log("==============================================");
    console.log("INFO - TQBCPWizardAdHocEditController : validateAndSaveAdHoc : START");
    console.log("==============================================");	
    		var onRecoReviewScreen = component.get("v.onRecoReviewScreen");
  		console.log("INFO - TQBCPWizardAdHocEditController :  onRecoReviewScreen after component.get = " + onRecoReviewScreen);
		component.set("v.onRecoReviewScreen",onRecoReviewScreen);
   		console.log("INFO - TQBCPWizardAdHocEditController :  onRecoReviewScreen after component.set = " + onRecoReviewScreen);		
		var errorsExist = helper.validateAdHocFields(component, event);

    if (errorsExist == false) {
			helper.saveAdHoc(component, event);
    	    console.log("SUCCESS - TQBCPWizardAdHocEditController : validateAndSaveAdHoc : saving ad hoc entry");		
	  }

/*
	 if (onRecoReviewScreen == 'true'){
		var evt = $A.get("e.c:TQBCPRecoNavigator");
		evt.setParams({ "candpkg": pkg, "recoType": "approve", "listOfAdHocEntries" : adHocEntries });
		evt.fire();
	}
*/
	}
})