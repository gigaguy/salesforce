({
	doInit : function(component, event, helper) {
		helper.getCPList(component);
	},
	/*redirectToSobject: function(component, event) {
      var selectedItem = event.currentTarget;
      var IdP = selectedItem.dataset.record;

      if ((typeof sforce != 'undefined') && sforce && (!!sforce.one))
       sforce.one.navigateToSObject(IdP);
      else{
           location.href = '/' + IdP;
      }
   },*/

   redirectToComponent: function(component, event) {
      var selectedItem = event.currentTarget;
      var IdP = selectedItem.dataset.record;
     var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:TQBCPWizard",
            componentAttributes: {
                "packageId" : IdP
            }
        });
        evt.fire();
   },


	redirectToSobjectRelatedCP : function(component, event) {
        var selectedItem = event.currentTarget;
        var IdP = selectedItem.dataset.record;
        if ((typeof sforce != 'undefined') && sforce && (!!sforce.one))
            sforce.one.navigateToRelatedList('TQB_Candidate_Package__r', '{!TQB_Candidate_Package__c.Id}');
        else{
           location.href = '/' + IdP;
        }
    }
})