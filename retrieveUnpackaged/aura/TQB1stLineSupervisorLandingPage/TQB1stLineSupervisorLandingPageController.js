({
	doInit : function(component, event, helper) {
		helper.getLOIList(component);
        helper.getCPList(component);
	},

   redirectToComponent : function(component, event) {
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


    redirectToSobject: function(component, event) {
      var selectedItem = event.currentTarget;
      var IdP = selectedItem.dataset.record;

      if ((typeof sforce != 'undefined') && sforce && (!!sforce.one))
       sforce.one.navigateToSObject(IdP);
      else{
           location.href = '/' + IdP;
      }
   },

    redirectToSobjectRelatedLOI : function(component, event) {
        var selectedItem = event.currentTarget;
        var IdP = selectedItem.dataset.record;
        if ((typeof sforce != 'undefined') && sforce && (!!sforce.one))
            sforce.one.navigateToRelatedList('TQB_Letter_of_Intent__r','{!TQB_Letter_of_Intent__c.Id}');
        else{
           location.href = '/' + IdP;
        }
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