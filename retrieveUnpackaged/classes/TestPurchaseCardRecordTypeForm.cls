@isTest
public class TestPurchaseCardRecordTypeForm {
    @isTest static void TestCreationOfPurchaseCardRecordTypeForm(){
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
        
        Forms__c myPurchaseCard = new Forms__c();
        myPurchaseCard.Service_Comp_Date_MM_YYYY__c = '12/2003';
        myPurchaseCard.Approver_1__c = user.id;
        myPurchaseCard.Approver_2__c = user.id;
        myPurchaseCard.Account_Type__c = 'COOP';
        myPurchaseCard.Cardholder_AO_Name__c = testContact.Id;
        //String purchaseCardRecordTypeName = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
        //Trellis 3.6.18
        RecordType RT = [select id, name from Recordtype WHERE Name = 'Purchase Card: New Purchase Card' Limit 1];
        myPurchaseCard.RecordTypeId = RT.Id;
        
        insert myPurchaseCard;
    }
    
    @isTest static void TestCreationOfPurchaseCardRecordTypeFormNoCardHolderChosen(){
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = UserInfo.getUserId();
        testcontact.Email = 'testEmail@mycompany.com';
        insert testContact;
        
        String tokenId = '123ABC';
        ID currentUserId = UserInfo.getUserId();
        User user = [select id from User where id=: currentUserId limit 1];
        user.Session_Token__c = tokenId;        
        user.Session_Token__c = '123ABC';
        user.Lan_ID__c = 'thetest';
        user.Email = 'testEmail@mycompany.com';
        update user;
        
        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        Forms__c myPurchaseCard = new Forms__c();
        myPurchaseCard.Service_Comp_Date_MM_YYYY__c = '12/2003';
        myPurchaseCard.Approver_1__c = user.id;
        myPurchaseCard.Approver_2__c = user.id;
        myPurchaseCard.Account_Type__c = 'COOP';
        myPurchaseCard.Cardholder_AO_Name__c = null;
        
        //String purchaseCardRecordTypeName = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
        //3.6.18 Trellis Sherman
        RecordType RT = [select id, name from recordtype where name = 'Purchase Card: New Purchase Card' limit 1];
        myPurchaseCard.RecordTypeId = RT.Id;
        
        insert myPurchaseCard;
    }


}