/* Author: 			Trellis Sherman
 * Email:  			trellis.sherman@csra.com
 * 
 * Test Class:		tctotsChangeTimeEntryRT_Test
 * 
 * Description: 	A trigger that perform two actions:
 * 					1. Update the hidden number fields that stores the numerical representation of time
 * 					2. Update the Time Entry recordtype, if applicable
 * 
 */

trigger tctoUpdateLineItemRT on Forms__c (after update)  {
    List<Line_Item__c> updateEntries = new List<Line_Item__c>();
    List<Line_Item__c> timeEntries = new List<Line_Item__c>();
    Forms__c oldForm;
    ID proposedRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Proposed Hours').getRecordTypeId();
    ID earnedRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Earned Hours').getRecordTypeId();
    ID formTctoID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeId();
    
    //loop through all forms that are being updated
    for(Forms__c form: Trigger.new)
    {
        
        //store the previous record values in a variable
        oldForm = Trigger.oldMap.get(form.id);
        
        //filter the forms for only forms that have been approved, i.e. from the field history
        if(oldForm.TCTO_Request_Type__c != form.TCTO_Request_Type__c  && oldForm.TCTO_Request_Type__c != 'Earned Hours Approved' &&
           form.TCTO_Request_Type__c == 'Earned Hours Request' && form.RecordTypeId == formTctoID)
        {
            //fetch all timeEntries for a specific TCTO form
            timeEntries = [SELECT ID, RecordTypeID,Travel_Time_End_Picklist__c,Travel_Time_Start_Picklist__c,
                           Offset_Hours_Entered__c,Related_Form__c FROM Line_Item__c where Related_Form__c =: form.Id];
            
            //if the time entry record is "Proposed Hours", then update the record type to "Earned Hours" and update the actual/earned values
            //from the proposed values
            for(Line_Item__c tmpTime: timeEntries)
            {
                if(tmpTime.recordTypeID == proposedRT){
                    tmpTime.RecordTypeId = earnedRT;
                }
                tmpTime.Travel_Time_Start_Actual__c = tmpTime.Travel_Time_Start_Picklist__c;
                tmpTime.Travel_Time_End_Actual__c = tmpTime.Travel_Time_End_Picklist__c;
                tmpTime.Hidden_Earned_Start_Time_Number__c = tmpTime.Hidden_Proposed_Start_Time_Number__c;
                tmpTime.Hidden_Earned_End_Time_Number__c = tmpTime.Hidden_Proposed_End_Time_Number__c;
                tmpTime.Offset_Hours_Actual__c = tmpTime.Offset_Hours_Entered__c;
                updateEntries.add(tmpTime);
            }     
        }
    }
    if(updateEntries.size() > 0)
        update updateEntries;
}