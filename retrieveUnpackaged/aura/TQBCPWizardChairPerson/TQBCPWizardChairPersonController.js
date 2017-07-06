({
	handlePanelMember : function(component, event, helper) {
    
       var selectedPanelMemberFromEvent = event.getParam("userByEvent");
	   component.set("v.selectedRecord" , selectedPanelMemberFromEvent); 
       
       var panelMembers = component.get("v.listOfTQBPanelMembers");
       
       if(panelMembers.length <= 5) {
       	 helper.updatePanelMemberTable(component, event);
       }
       else{
         helper.alertMessage(component, event);
       }
	},

	deletePanelMemberController : function(component, event, helper) {
	  var selectedItem = event.currentTarget;
      var panelMemberSelectedId = selectedItem.dataset.record;
      console.log('Panel Member selected Id in deletePanelMemberController = '+ panelMemberSelectedId);
      helper.deletePanelMemberHelper(component, event, panelMemberSelectedId);
	},

	notifyCoordinator : function(component, event, helper) {

	var panelMembers = component.get("v.listOfTQBPanelMembers");
	console.log('count of panel Members'+ panelMembers.length);
       if(panelMembers.length < 3 || panelMembers.length > 5 )  
       	  helper.alertMessage(component, event);
       else      
		  helper.sendNotifyEmail(component, event); 
	}
})