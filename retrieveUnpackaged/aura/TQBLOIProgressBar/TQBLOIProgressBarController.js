({
	doInit  : function(component, event, helper) {
		    var action = component.get("c.getLetters");
            action.setCallback(this, function(a) {
            component.set("v.LettersOfIntent", a.getReturnValue());			
        });
        $A.enqueueAction(action);

	},
    redirectToSobject: function(component, event) {
      var selectedItem = event.currentTarget;
      var IdP = selectedItem.dataset.record;

      if ((typeof sforce != 'undefined') && sforce && (!!sforce.one))
       sforce.one.navigateToSObject(IdP);
      else{
           location.href = '/' + IdP;
      }
   }
})