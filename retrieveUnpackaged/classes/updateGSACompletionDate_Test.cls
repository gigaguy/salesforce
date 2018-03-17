@isTest
public class updateGSACompletionDate_Test {
    
    public static testMethod void pcGSAUpdateContactTest1()
    {
        //create the account 
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        //create the contact record
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = UserInfo.getUserId();
        insert testContact;
        
        //update the user record
        String tokenId = '123ABC';
        ID currentUserId = UserInfo.getUserId();
        User user = [select id from User where id=: currentUserId limit 1];
        user.Session_Token__c = tokenId;        
        user.Session_Token__c = '123ABC';
        user.Lan_ID__c = 'thetest';
        update user;
        
        //contact record
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        //???
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        //creation of the purchase card form
        Forms__c testForm = new Forms__c();
        testForm.RecordTypeId = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
        testForm.Cardholder_AO_Name__c = testContact.Id;
        testForm.Service_Comp_Date_MM_YYYY__c = '11/2005';
        testForm.Approver_1__c = UserInfo.getUserId();
        testForm.Approver_2__c = UserInfo.getUserId();
        testForm.Monthly_Purchase_Limit__c = 7000.00;
        testForm.Single_Purchase_Limit__c = 3500.00;
        testForm.Account_Type__c ='CO';
        upsert testForm;
        

        Test.startTest();
        
        //find contact record and check if the completion date is null. After the comparsion, update the completion date in the line item record and compare the new completion date
        contact testCon = [select id, GSA_SmartPay_Training_Date__c from Contact where id =: testContact.Id];
        System.assertEquals(null, testCon.GSA_SmartPay_Training_Date__c);
        
        Line_Item__c testItem = [select id, course_title__c from Line_Item__c where Related_Form__c =: testForm.id and 
                                 course_title__c = 'GSA SmartPay Purchase Card Training' limit 1];
        testItem.Completion_Date__c = Date.today();
        update testItem;
        
        testCon = [select id, GSA_SmartPay_Training_Date__c from Contact where id =: testContact.Id];
        System.assertNotEquals(null, testCon.GSA_SmartPay_Training_Date__c);
        
 
        Test.stopTest();
    }
    
    public static testMethod void pcGSAUpdateContactTest2()
    {
        //create the account 
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        //create the contact record
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = UserInfo.getUserId();
        insert testContact;
        
        //update the user record
        String tokenId = '123ABC';
        ID currentUserId = UserInfo.getUserId();
        User user = [select id from User where id=: currentUserId limit 1];
        user.Session_Token__c = tokenId;        
        user.Session_Token__c = '123ABC';
        user.Lan_ID__c = 'thetest';
        update user;
        
        //???
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        //inserting a new purchase card form
        Forms__c testForm = new Forms__c();
        testForm.RecordTypeId = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
        testForm.Cardholder_AO_Name__c = testContact.Id;
        testForm.Service_Comp_Date_MM_YYYY__c = '11/2005';
        testForm.Approver_1__c = UserInfo.getUserId();
        testForm.Approver_2__c = UserInfo.getUserId();
        testForm.Monthly_Purchase_Limit__c = 7000.00;
        testForm.Single_Purchase_Limit__c = 3500.00;
        testForm.Account_Type__c ='CO';
        upsert testForm;
        

        Test.startTest();
        
        //find contact record and check if the completion date is null. After the comparsion, update the completion date in the line item record and compare the new completion date
        contact testCon = [select id, GSA_SmartPay_Training_Date__c from Contact where id =: testContact.Id];
        System.assertEquals(null, testCon.GSA_SmartPay_Training_Date__c);
        
        List<Line_Item__c> testItems = new List<Line_Item__c>();
        Integer index = 0;
        
        for(Line_Item__c item: [select id, course_title__c from Line_Item__c where Related_Form__c =: testForm.id])
        {
            item.Course_Title__c = 'GSA SmartPay Purchase Card Training';
            item.Completion_Date__c = Date.today() + index;
            testItems.add(item);
            index = index + 1;
        }
        update testItems;
        
        testCon = [select id, GSA_SmartPay_Training_Date__c from Contact where id =: testContact.Id];
        System.assertEquals(Date.today()+2, testCon.GSA_SmartPay_Training_Date__c);
        
 
        Test.stopTest();
    }

}