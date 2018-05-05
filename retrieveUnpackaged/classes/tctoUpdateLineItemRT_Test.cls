@isTest
public class tctoUpdateLineItemRT_Test {
    
       
    public static testMethod void tctotsChangeTimeEntryRT_Test()
    {
        //variables
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        ID Time_Entry_RT1;
        ID Time_Entry_RT2;
        ID Time_Entry_RT3;
        ID Time_Entry_RT4;
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        List<Line_Item__c> timeEntryResults;
        List<Line_Item__c> updatedTimeEntryResults;
        
        //update test user information
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        User u = [select id from User where ID =: currentUserID limit 1];
        u.Session_Token__c = '123ABC';
        u.Lan_ID__c = 'thetest';
        update u;
        
        //create contact record for test user
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        //creation of the form
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours Request';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;

        
        upsert testForm;
        
        //confirm the travel dates are for five days
        updatedForm = [select id, recordtypeID,Number_of_Days_TCTO__c,Start_Date_TCTO__c from FORMS__C where ID =: testForm.Id limit 1];
        System.assertEquals(5, updatedForm.Number_of_Days_TCTO__c);
        
        
        Test.startTest();

        //confirm five time entry records were created
        timeEntryResults = [select id, recordtypeid, Related_Form__c from Line_Item__c where Related_Form__C =: updatedForm.Id];
        System.assertEquals(5, timeEntryResults.size());
        
        //store the recordtype ids in the variables
        Time_Entry_RT1 = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO New Time Item').getRecordTypeId();
        Time_Entry_RT2 = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Travel Comp Time Not Applicable').getRecordTypeId();
        Time_Entry_RT3 = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Proposed Hours').getRecordTypeId();
        Time_Entry_RT4 = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Earned Hours').getRecordTypeId();
 
        //simulate selecting "yes" or "no" for time comp applicable
        timeEntryResults[0].Travel_Comp_Time_Applicable__c = 'YES';
        timeEntryResults[1].Travel_Comp_Time_Applicable__c = 'NO';
        timeEntryResults[2].Travel_Comp_Time_Applicable__c = 'YES';
        timeEntryResults[3].Travel_Comp_Time_Applicable__c = 'YES';
        timeEntryResults[4].Travel_Comp_Time_Applicable__c = 'NO';
        
        update timeEntryResults;
        
        //retrieve the the time entry records that have been update
        updatedTimeEntryResults = [select id, recordtypeid, Related_Form__c from Line_Item__c where Related_Form__C =: updatedForm.Id];
        
        //confirm the record type have changed to "Proposed Hours" or "Time Comp Not Applicable"
        System.assertEquals(updatedTimeEntryResults[0].recordTypeId, Time_Entry_RT3);
        System.assertEquals(updatedTimeEntryResults[1].recordTypeId, Time_Entry_RT2);
        System.assertEquals(updatedTimeEntryResults[2].recordTypeId, Time_Entry_RT3);
        System.assertEquals(updatedTimeEntryResults[3].recordTypeId, Time_Entry_RT3);
        System.assertEquals(updatedTimeEntryResults[4].recordTypeId, Time_Entry_RT2);
        
        //update the tcto form
        updatedForm.TCTO_Request_Type__c = 'Earned Hours Request';
        update updatedForm;
        
        //confirm the record type have changed to "Proposed Hours" to "Earned Hours"
        updatedTimeEntryResults = [select id, recordtypeid, Related_Form__c from Line_Item__c where Related_Form__C =: updatedForm.Id];
        
        System.assertEquals(updatedTimeEntryResults[0].recordTypeId, Time_Entry_RT4);
        System.assertEquals(updatedTimeEntryResults[1].recordTypeId, Time_Entry_RT2);
        System.assertEquals(updatedTimeEntryResults[2].recordTypeId, Time_Entry_RT4);
        System.assertEquals(updatedTimeEntryResults[3].recordTypeId, Time_Entry_RT4);
        System.assertEquals(updatedTimeEntryResults[4].recordTypeId, Time_Entry_RT2);
		   
        Test.stopTest();
    }


}