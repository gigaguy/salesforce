@isTest
public class lineEntryTctoTriggerHelper_Test {
    
    
    public static testMethod void timeEntryTriggerHelperTest()
    {
        //vars
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        ID Time_Entry_RT1;
        ID Time_Entry_RT2;
        ID Time_Entry_RT3;
        ID Time_Entry_RT4;
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        List<Line_Item__c> timeEntryForms;
        List<Line_Item__c> timeEntryResults;
        List<Line_Item__c> updatedTimeEntryResults;
        
        //update test user information
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        User u = [select id from User where ID =: currentUserID limit 1];
        u.Session_Token__c = '123ABC';
        u.Lan_ID__c = 'thetest';
        update u;
        
        //create contact record
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        //create form 
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 3;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours Request';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;
        
        upsert testForm;
        
        //confirm the number of travel days is four
        updatedForm = [select id, recordtypeID,Number_of_Days_TCTO__c from FORMS__C where ID =: testForm.Id limit 1];
        System.assertEquals(4, updatedForm.Number_of_Days_TCTO__c);
        
        
        Test.startTest();
        
        //set the id of each Time Entry RecordTypeID in vars
        Time_Entry_RT1 = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO New Time Item').getRecordTypeId();
        Time_Entry_RT2 = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Travel Comp Time Not Applicable').getRecordTypeId();
        Time_Entry_RT3 = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Proposed Hours').getRecordTypeId();
        Time_Entry_RT4 = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO Earned Hours').getRecordTypeId();
        
        //retrieve all time entry record that was created for the testform
        timeEntryForms = [select id,Name,Date__c,Related_Form__c,Hidden_RecordType_Name__c,Hidden_TCTO_Request_Type__c,Travel_Comp_Time_Applicable__c,
                          Travel_Time_Start_Picklist__c, Travel_Time_End_Picklist__c,Offset_Hours_Entered__c, Travel_Comp_Hours__c,
                          Travel_Time_Start_Actual__c, Travel_Time_End_Actual__c,Offset_Hours_Actual__c,Travel_Comp_Hours_Earned__c,
                          Normal_Workday_End_Time__c,Normal_Workday_Start_Time__c from Line_Item__c 
                          where Related_Form__c =: updatedForm.id order by Name];
        
        //confirm four Time Entry record exist
        System.assertEquals(4,timeEntryForms.size());
        
        //assign values to cover all scenarios
        timeEntryForms[0].Travel_Comp_Time_Applicable__c = 'Yes';
        timeEntryForms[0].Travel_Time_Start_Picklist__c = '12:00 AM';
        timeEntryForms[0].Travel_Time_End_Picklist__c = '12:30 AM';
        timeEntryForms[0].Normal_Workday_Start_Time__c = '12:00 AM';
        timeEntryForms[0].Normal_Workday_End_Time__c = '12:30 AM';
        timeEntryForms[1].Travel_Comp_Time_Applicable__c = 'Yes';
        timeEntryForms[1].Travel_Time_Start_Picklist__c = '01:00 AM';
        timeEntryForms[1].Travel_Time_End_Picklist__c = '01:30 AM';
        timeEntryForms[1].Normal_Workday_Start_Time__c = '01:00 AM';
        timeEntryForms[1].Normal_Workday_End_Time__c = '01:30 AM';
        timeEntryForms[2].Travel_Comp_Time_Applicable__c = 'Yes';
        timeEntryForms[2].Travel_Time_Start_Picklist__c = '12:00 PM';
        timeEntryForms[2].Travel_Time_End_Picklist__c = '12:30 PM';
        timeEntryForms[2].Normal_Workday_Start_Time__c = '12:00 PM';
        timeEntryForms[2].Normal_Workday_End_Time__c = '12:30 PM';
        timeEntryForms[3].Travel_Comp_Time_Applicable__c = 'Yes';
        timeEntryForms[3].Normal_Workday_Start_Time__c = '01:00 PM';
        timeEntryForms[3].Normal_Workday_End_Time__c = '01:30 PM';
        timeEntryForms[3].Travel_Time_Start_Picklist__c = '01:00 PM';
        timeEntryForms[3].Travel_Time_End_Picklist__c = '01:30 PM';
        
        update timeEntryForms;
        
        //change the form to update the time entry records recordtypeid
        updatedForm.TCTO_Request_Type__c = 'Earned Hours Request';
        update updatedForm;
        
        timeEntryForms = [select id,Name,Date__c,Related_Form__c,Hidden_RecordType_Name__c,Hidden_TCTO_Request_Type__c,Travel_Comp_Time_Applicable__c,
                          Travel_Time_Start_Picklist__c, Travel_Time_End_Picklist__c,Offset_Hours_Entered__c, Travel_Comp_Hours__c,
                          Travel_Time_Start_Actual__c, Travel_Time_End_Actual__c,Offset_Hours_Actual__c,Travel_Comp_Hours_Earned__c,
                          Normal_Workday_End_Time__c,Normal_Workday_Start_Time__c from Line_Item__C 
                          where Related_Form__c =: updatedForm.id order by Name];
        //confirm still only four Time Entry record exist
        System.assertEquals(4,timeEntryForms.size());
        
        //Assign values for each Time Entry record
        timeEntryForms[0].Travel_Comp_Time_Applicable__c = 'Yes';
        timeEntryForms[0].Travel_Time_Start_Actual__c = '12:00 AM';
        timeEntryForms[0].Travel_Time_End_Actual__c = '12:30 AM';
        timeEntryForms[0].Normal_Workday_Start_Time__c = '12:00 AM';
        timeEntryForms[0].Normal_Workday_End_Time__c = '12:30 AM';
        timeEntryForms[1].Travel_Comp_Time_Applicable__c = 'Yes';
        timeEntryForms[1].Travel_Time_Start_Actual__c = '01:00 AM';
        timeEntryForms[1].Travel_Time_End_Actual__c = '01:30 AM';
        timeEntryForms[1].Normal_Workday_Start_Time__c = '01:00 AM';
        timeEntryForms[1].Normal_Workday_End_Time__c = '01:30 AM';
        timeEntryForms[2].Travel_Comp_Time_Applicable__c = 'Yes';
        timeEntryForms[2].Travel_Time_Start_Actual__c = '12:00 PM';
        timeEntryForms[2].Travel_Time_End_Actual__c = '12:30 PM';
        timeEntryForms[2].Normal_Workday_Start_Time__c = '12:00 PM';
        timeEntryForms[2].Normal_Workday_End_Time__c = '12:30 PM';
        timeEntryForms[3].Travel_Comp_Time_Applicable__c = 'Yes';
        timeEntryForms[3].Normal_Workday_Start_Time__c = '01:00 PM';
        timeEntryForms[3].Normal_Workday_End_Time__c = '01:30 PM';
        timeEntryForms[3].Travel_Time_Start_Actual__c = '01:00 PM';
        timeEntryForms[3].Travel_Time_End_Actual__c = '01:30 PM';
        
        update timeEntryForms;  
    }

}