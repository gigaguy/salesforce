@isTest
public class PCformEnterApprovalProcess_Test {
    
    public static testMethod void pcSubmitTest1()
    {
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = UserInfo.getUserId();
        insert testContact;
        
        String tokenId = '123ABC';
        ID currentUserId = UserInfo.getUserId();
        User user = [select id from User where id=: currentUserId limit 1];
        user.Session_Token__c = tokenId;        
        user.Session_Token__c = '123ABC';
        user.Lan_ID__c = 'thetest';
        update user;
        
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        
        Forms__c testForm = new Forms__c();
        testForm.RecordTypeId = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card').getRecordTypeId();
        testForm.Cardholder_AO_Name__c = testContact.Id;
        testForm.Service_Comp_Date_MM_YYYY__c = '11/2005';
        testForm.Approver_1__c = UserInfo.getUserId();
        testForm.Approver_2__c = UserInfo.getUserId();
        testForm.Monthly_Purchase_Limit__c = 7000.00;
        testForm.Single_Purchase_Limit__c = 3500.00;
        testForm.Account_Type__c ='CO';
        upsert testForm;
        
        Line_Item__c testItem = [select id from Line_Item__c where Related_Form__c =: testForm.id limit 1];
        ContentVersion file = new ContentVersion();
        file.PathOnClient = 'null';
        file.VersionData = Blob.valueOf('Cheese');
        file.Title = 'EPA';
        insert file;

		ContentDocument doc = [select id from ContentDocument limit 1];        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = doc.id;
        cdl.LinkedEntityId = testItem.Id;
        cdl.ShareType = 'V';
        upsert cdl;
        
        
        
        Test.startTest();

        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Automatically Submitted');
        req1.setObjectId(testForm.id);
        req1.setProcessDefinitionNameOrId('Purchase_Card_Approval3');
        req1.setSubmitterID(UserInfo.getUserId());
        try
        {
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(false);
        }catch(Exception E)
        {
        	String Msg = E.getMessage();
            if(Msg.containsIgnoreCase('does not contain a file attachment'))
            {
                System.assert(true);
            }
            else
            {
                //System.assert(false);
            }
        }
        Test.stopTest();
    }
    
    
    public static testMethod void pcSubmitTest2()
    {
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = UserInfo.getUserId();
        insert testContact;
        
        String tokenId = '123ABC';
        ID currentUserId = UserInfo.getUserId();
        User user = [select id from User where id=: currentUserId limit 1];
        user.Session_Token__c = tokenId;        
        user.Session_Token__c = '123ABC';
        user.Lan_ID__c = 'thetest';
        update user;
        
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        
        Forms__c testForm = new Forms__c();
        testForm.RecordTypeId = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card').getRecordTypeId();
        testForm.Cardholder_AO_Name__c = testContact.Id;
        testForm.Service_Comp_Date_MM_YYYY__c = '11/2005';
        testForm.Approver_1__c = UserInfo.getUserId();
        testForm.Approver_2__c = UserInfo.getUserId();
        testForm.Monthly_Purchase_Limit__c = 7000.00;
        testForm.Single_Purchase_Limit__c = 3500.00;
        testForm.Account_Type__c ='CO';
        upsert testForm;
        
        Line_Item__c testItem = [select id from Line_Item__c where Related_Form__c =: testForm.id limit 1];
        ContentVersion file = new ContentVersion();
        file.PathOnClient = 'null';
        file.VersionData = Blob.valueOf('Cheese');
        file.Title = 'EPA';
        insert file;

		/*ContentDocument doc = [select id from ContentDocument limit 1];        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = doc.id;
        cdl.LinkedEntityId = testItem.Id;
        cdl.ShareType = 'V';
        upsert cdl;*/
        
        
        
        Test.startTest();

        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Automatically Submitted');
        req1.setObjectId(testForm.id);
        req1.setProcessDefinitionNameOrId('Purchase_Card_Approval3');
        req1.setSubmitterID(UserInfo.getUserId());
        try
        {
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(false);
        }catch(Exception E)
        {
        	String Msg = E.getMessage();
            if(Msg.containsIgnoreCase('does not contain a file attachment'))
            {
                System.assert(true);
            }
            else
            {
                //System.assert(false);
            }
        }
        Test.stopTest();
    }
}