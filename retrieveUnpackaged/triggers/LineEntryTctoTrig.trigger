/* Author: 			Trellis Sherman
* Email:  			trellis.sherman@csra.com
* 
* Test Class:		lineEntryTctoTrig_Test
* 
* Description: 	An Apex Trigger that will perform the following:
* 					1. Change the Time Entry RecordType, if needed.
* 					2. Store the numeric representation of time in the needed fields
* 
*/
trigger LineEntryTctoTrig on Line_Item__c (before insert, before update, after update) {
    
    //The four Time Entry Record Type stored in variables
    ID proposedRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Proposed Hours').getRecordTypeId();
    ID earnedRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Earned Hours').getRecordTypeId();
    ID noTravelCompRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Travel Comp Time Not Applicable').getRecordTypeId();
    ID newRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO New Time Item').getRecordTypeId();
    List<Double> timeNumResult = new List<Double>();
    Map<ID,ID> formsToUpdate = new Map<ID,ID>();
    
    //used to calculate roll-up summary for TCTO Line items
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        for(Line_Item__c lineEntry: Trigger.New)
        {
            if(lineEntry.Related_Form__c != null && formsToUpdate.containsKey(lineEntry.Related_Form__c) == false &&
               (lineEntry.RecordTypeId == proposedRT || lineEntry.RecordTypeId == earnedRT))
            {
                formsToUpdate.put(lineEntry.Related_Form__c,lineEntry.Related_Form__c);
            }
            
            if(formsToUpdate.isEmpty() == false)
            {
                lineEntryTctoTriggerHelper.calculateTravelComp(formsToUpdate.values());
            }
        }
    }
    else
    {
        //For each Line Item record, determine if the recordtype should change only if the line item is related to TCTO
        for(Line_Item__c lineEntry: Trigger.New)
        {
            if(lineEntry.RecordTypeId == newRT|| lineEntry.RecordTypeId == noTravelCompRT || 
               lineEntry.RecordTypeId == proposedRT || lineEntry.RecordTypeId == earnedRT)
            {
                timeNumResult = lineEntryTctoTriggerHelper.timeToNumber(lineEntry);  
                
                if(lineEntry.Travel_Comp_Time_Applicable__c == 'Yes' && lineEntry.RecordTypeId != earnedRT &&
                   lineEntry.Hidden_TCTO_Request_Type__c == 'Earned Hours Request')
                {
                    System.debug('Change Time Entry recordtype to: "Earned Hours"');
                    lineEntry.RecordTypeId = earnedRT;
                    lineEntry.Hidden_Normal_Workday_Start_Time_Number__c = timeNumResult.get(0);
                    lineEntry.Hidden_Normal_Workday_End_Time_Number__c = timeNumResult.get(1);
                    lineEntry.Hidden_Earned_Start_Time_Number__c = timeNumResult.get(2);
                    lineEntry.Hidden_Earned_End_Time_Number__c = timeNumResult.get(3);
                    
                }
                else if(lineEntry.Travel_Comp_Time_Applicable__c == 'Yes' && lineEntry.RecordTypeId != proposedRT && lineEntry.RecordTypeId != earnedRT && 
                        (lineEntry.Hidden_TCTO_Request_Type__c !='Earned Hours Request' || lineEntry.Hidden_TCTO_Request_Type__c !='Earned Hours Approved'))
                {
                    System.debug('Change Time Entry recordtype to: "Proposed Hours"');
                    lineEntry.RecordTypeId = proposedRT;
                    lineEntry.Hidden_Normal_Workday_Start_Time_Number__c = timeNumResult.get(0);
                    lineEntry.Hidden_Normal_Workday_End_Time_Number__c = timeNumResult.get(1);
                    lineEntry.Hidden_Proposed_Start_Time_Number__c = timeNumResult.get(2);
                    lineEntry.Hidden_Proposed_End_Time_Number__c = timeNumResult.get(3);
                }
                else if(lineEntry.Travel_Comp_Time_Applicable__c == 'No' && lineEntry.RecordTypeId != noTravelCompRT)
                {
                    System.debug('Change Time Entry recordtype to: "Travel Comp Time Not Applicable"');
                    lineEntry.RecordTypeId = noTravelCompRT;
                    lineEntry.Hidden_Normal_Workday_Start_Time_Number__c = 0;
                    lineEntry.Hidden_Normal_Workday_End_Time_Number__c = 0;
                    lineEntry.Hidden_Proposed_Start_Time_Number__c = 0;
                    lineEntry.Hidden_Proposed_End_Time_Number__c = 0;
                    lineEntry.Hidden_Earned_Start_Time_Number__c = 0;
                    lineEntry.Hidden_Earned_End_Time_Number__c = 0;
                }
                
                //if the recordtype is not being updated, update the hidden time field, if needed
                if(lineEntry.Travel_Comp_Time_Applicable__c == 'Yes' && lineEntry.RecordTypeId == proposedRT && 
                   lineEntry.Hidden_TCTO_Request_Type__c =='Proposed Hours Request')
                {
                    lineEntry.Hidden_Normal_Workday_Start_Time_Number__c = timeNumResult.get(0);
                    lineEntry.Hidden_Normal_Workday_End_Time_Number__c = timeNumResult.get(1);
                    lineEntry.Hidden_Proposed_Start_Time_Number__c = timeNumResult.get(2);
                    lineEntry.Hidden_Proposed_End_Time_Number__c = timeNumResult.get(3);
                }
                //if the recordtype is not being updated, update the hidden time field, if needed
                else if(lineEntry.Travel_Comp_Time_Applicable__c == 'Yes' && lineEntry.RecordTypeId == earnedRT && 
                        lineEntry.Hidden_TCTO_Request_Type__c =='Earned Hours Request')
                {
                    lineEntry.Hidden_Normal_Workday_Start_Time_Number__c = timeNumResult.get(0);
                    lineEntry.Hidden_Normal_Workday_End_Time_Number__c = timeNumResult.get(1);
                    lineEntry.Hidden_Earned_Start_Time_Number__c = timeNumResult.get(2);
                    lineEntry.Hidden_Earned_End_Time_Number__c = timeNumResult.get(3);
                }
            }
        }
    }
}