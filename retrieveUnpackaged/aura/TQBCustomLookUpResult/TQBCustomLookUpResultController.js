({
	 selectUser : function(component, event, helper){      
    // get the selected User from list  
      var getSelectAccount = component.get("v.panelMember");
    // call the event   
      var compEvent = component.getEvent("oSelectedUserEvent");
    // set the Selected User to the event attribute.  
         compEvent.setParams({"userByEvent" : getSelectAccount });  
    // fire the event  
         compEvent.fire();
    },
})