({

  doInit : function(component, event, helper) {
     helper.getSelectedAdhocMember(component, event);
  },

	sendNotificationToChairPerson : function(component, event, helper){
	  var selectedItem = event.currentTarget;
        var chairPersonSelectedId = selectedItem.dataset.record;
        var personType='chair';
        console.log('Chairperson selected Id in TQBCPWizardCoordinator = '+ chairPersonSelectedId);
        helper.sendNotifyEmail(component, event, chairPersonSelectedId, personType);
	},
	sendNotificationToPanelPerson : function(component, event, helper){
	  var selectedItem = event.currentTarget;
        var panelPersonSelectedId = selectedItem.dataset.record;
        var personType='panel';
        console.log('panelPerson selected Id in TQBCPWizardCoordinator = '+ panelPersonSelectedId);
        helper.sendNotifyEmail(component, event, panelPersonSelectedId, personType);
	},
	deletePanelMemberController : function(component, event, helper) {
	  var selectedItem = event.currentTarget;
        var panelMemberSelectedId = selectedItem.dataset.record;
        console.log('Panel Member selected Id in deletePanelMemberController = '+ panelMemberSelectedId);
        helper.deletePanelMemberHelper(component, event, panelMemberSelectedId);
	},

  sendNotificationToAdhocMember : function(component, event, helper) {
      
      var selectedCheckBoxCount = 0, newSelectedValue;
      var getAllCheckboxes = component.find("checkBox");
      for (var i = 0; i < getAllCheckboxes.length; i++) {
            newSelectedValue = getAllCheckboxes[i].get("v.value");
            if (newSelectedValue == true) {
              selectedCheckBoxCount++;
            }
      }

      if(selectedCheckBoxCount == 2){
         var newSelectedValue;
         var adhocPersonSelectedIds = [];
         for (var i = 0; i < getAllCheckboxes.length; i++) {
            newSelectedValue = getAllCheckboxes[i].get("v.value");
            if (newSelectedValue == true) {
              adhocPersonSelectedIds.push(getAllCheckboxes[i].get("v.text"));
            }
         }
         helper.sendNotifyEmailtoAdhocMember(component, event, adhocPersonSelectedIds);
       }
      else{
          $A.createComponents([
              ["ui:message",{
                "title" : "Error :",
                "severity" : "error",
                "class" : "slds-size--1-of-2"
              }],
              ["ui:outputText",{
                "value" : "Please select any two Adhoc Members from the approved list for this package."
              }]
            ],
            function(components) {
              var message = components[0];
              var outputText = components[1];
              // set the body of the ui:message to be the ui:outputText
              message.set("v.body", outputText);
              component.set("v.messages", message);
              document.body.scrollTop = document.documentElement.scrollTop = 0;
              window.setTimeout(
                $A.getCallback(function() {
                  component.set("v.messages", []);
                }), 5000
              );
            } );
       }
      }
})