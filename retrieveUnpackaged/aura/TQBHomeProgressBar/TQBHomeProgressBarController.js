({
	doInit  : function(component, event, helper) {
		helper.getProgressBarItems(component);
	},
	redirectToSobject: function(component, event) {
		var selectedItem = event.currentTarget;
		var IdP = selectedItem.dataset.record;

		if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
			//sforce.one.navigateToSObject(IdP);
			var evt = $A.get("e.force:navigateToComponent");
			evt.setParams({
					componentDef : "c:TQBCPWizard",
					componentAttributes: {
							packageId : IdP
					}
			});
			evt.fire();
		}
		else{
			location.href = '/' + IdP;
		}
	}
})