({
     loadFormDropdownData : function(component, event, helper){
        var result = event.getParam(LOIName);
        console.log('result value in the LOIWizard');
        console.log(result);
        helper.getLOIStatusList(component);
        helper.getLOI1stLineSupervisorList(component);
        helper.getLOI2ndLineSupervisorList(component);
        helper.getLOICurrentLabWorkList(component);
        helper.getLOICurrentGSList(component);
        helper.getLOICurrentRegionList(component);
        helper.getLOIIntendedTrackList(component);
     },

     saveLOI : function(component, event, helper) {

       //var LOI1stline = component.find("LOI1stline").get("v.value");
       //var LOI2ndline = component.find("LOI2ndline").get("v.value");
       var LOICurrentLab = component.find("LOICurrentLab").get("v.value");
       component.set("v.newLOIPackage.Current_Lab_Work_Location_Assignment__c", LOICurrentLab);
       console.log(LOICurrentLab);

       var LOICurrentGSlevel = component.find("LOICurrentGSlevel").get("v.value");
       component.set("v.newLOIPackage.Current_GS_Level__c", LOICurrentGSlevel);
       console.log(LOICurrentGSlevel);

       var LOICurrentRegion = component.find("LOICurrentRegion").get("v.value");
       component.set("v.newLOIPackage.CurrentRegion__c", LOICurrentRegion);
       console.log(LOICurrentRegion);

       var LOIIntendedTrack = component.find("LOIIntendedTrack").get("v.value");
       component.set("v.newLOIPackage.IntendedTrack__c", LOIIntendedTrack);

       var LOIStatus = component.find("LOIStatus").get("v.value");
       component.set("v.newLOIPackage.Status__c", LOIStatus);

       var LOIForm = component.get("v.newLOIPackage");
       console.log(LOIForm);

       //calling the Apex function

       var action = component.get("c.createLOIRecord");

       action.setParams({
         LOIForm : LOIForm
       })

       action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            var errorMessage = a.getReturnValue();
            //check if result is successfull
            if(errorMessage){
                alert(errorMessage);
            } else {
                //Reset Form
                var newLOIForm = { 'sobjectType': 'TQB_Letter_of_Intent__c',
                                  'Candidates_1st_Line_Supervisor_Name__c': '',
                                   'Candidates_2nd_Line_Supervisor_Name__c': '',
                                   'Current_GS_Level__c': '',
                                   'Current_Lab_Work_Location_Assignment__c': '',
                                   'CurrentRegion__c': '',
                                   'IntendedTrack__c': '',
                                   'Status__c': '',
                                   'LOI_Reject_Reason__c': ''
                                   }
                //resetting the Values in the form
                component.set("v.newLOIPackage",newLOIForm);
                alert('LOIRecord is Created Successfully');
            }
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
        
        //helper.validateLOIFormData(component);
        
    }
})