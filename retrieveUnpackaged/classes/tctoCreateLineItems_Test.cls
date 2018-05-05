@isTest
public class tctoCreateLineItems_Test {
    
    public static testMethod void createTimeEntriesTest()
    {
        //Vars
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        List<Line_Item__c> timeEntryResults;
        
        //update the user detail
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        User u = [select id from User where ID =: currentUserID limit 1];
        u.Session_Token__c = '123ABC';
        u.Lan_ID__c = 'thetest';
        update u;
        
        //create a contact record
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        Test.startTest();
        
        //Filling Out TCTO Form to create Time Entries
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours Request';
        testform.Hidden_Able_to_Create_Time_Entries__c = true;
        
        upsert testForm;
        
        //There should only be one form with 5 days
        updatedForm = [select id, recordtypeID,Number_of_Days_TCTO__c,Start_Date_TCTO__c,End_Date_TCTO__c from FORMS__C where ID =: testForm.Id limit 1];
        System.assertEquals(5, updatedForm.Number_of_Days_TCTO__c);
        
        //There shoudld be five Time Entries forms related to the form
        //
        //03-23-18, This is commented out since the process builder will be inactive when migrated, uncomment the below code once the process builder is active
        //
       // timeEntryResults = [select id, Related_Form__c from Line_Item__c where Related_Form__c =: updatedForm.Id];
       // System.assertEquals(5, timeEntryResults.size());
        
        Test.stopTest();
        
    }
}