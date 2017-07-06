({
	doInit : function(component, event, helper) {
        helper.getCPList(component);
	},

   redirectToComponent : function(component, event) {
     var selectedItem = event.currentTarget;
      var IdP = selectedItem.dataset.record;
      console.log('Idp value when clicked: = ');
      console.log('Idp value when clicked: = '+IdP);
     var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:TQBCPWizard",
            componentAttributes: {
                "packageId" : IdP
            }
        });
        evt.fire();
   }
})