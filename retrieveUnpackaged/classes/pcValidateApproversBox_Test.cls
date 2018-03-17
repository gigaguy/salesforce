@isTest
public class pcValidateApproversBox_Test {
    
    public static testMethod void pcApproveTest1()
    {
        //account creation
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        //contact creation
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = UserInfo.getUserId();
        insert testContact;
        
        //updating user information
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
        
        //creation of the form
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
        
        //list of line items
        List<Line_Item__c> testItems = [select id from Line_Item__c where Related_Form__c =: testForm.id];
        
        //creation of a file
        ContentVersion file = new ContentVersion();
        file.PathOnClient = 'null';
        file.VersionData = Blob.valueOf('Cheese');
        file.Title = 'EPA';
        insert file;
        
        ContentDocument doc = [select id from ContentDocument limit 1]; 
        system.debug('doc: '+doc);
        
        //for each line item create a link to the record and file
        for(Line_Item__c item: testItems)
        {
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = doc.id;
            cdl.LinkedEntityId = item.Id;
            cdl.ShareType = 'V';
            upsert cdl;
            
            item.Completion_Date__c = Date.today();
            update item;
        }
        
        Test.startTest();
        
        //submit the form for approval
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Automatically Submitted');
        req1.setObjectId(testForm.id);
        req1.setProcessDefinitionNameOrId('Purchase_Card_Approval3');
        req1.setSubmitterID(UserInfo.getUserId());
        Approval.ProcessResult result = Approval.process(req1);
        
        //submit the form as approver 1, without filling in approver fields
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setWorkitemId(newWorkItemIds.get(0));
        try{
        Approval.ProcessResult result2 =  Approval.process(req2);
        }catch(Exception e){}
        
        
        
        
        //submit the form as approver 1, with the approver 1 fields filled in
        testform = [select id, approval_step__c from Forms__c limit 1];
        testform.I_Agree_with_Terms_Approver_1__c = true;
        testform.Business_Justification__c = 'This is a Test';
        update testform;
        newWorkItemIds = result.getNewWorkitemIds();
        req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setWorkitemId(newWorkItemIds.get(0));
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        //submit the form as approver 2, with the approver 2 checkbox not checked
        req2 = new Approval.ProcessWorkitemRequest();
        newWorkItemIds = result2.getNewWorkitemIds();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setWorkitemId(newWorkItemIds.get(0));
        try{
            Approval.ProcessResult result3 =  Approval.process(req2);
        }catch(Exception e){SYSTEM.debug('EX: '+E.getLineNumber() + ' __ '+E.getMessage());}
        
        
        
        
        //approve the form as approver 1, with the approver 2 checkbox checked and the approver 1 checkbox unchecked
        testform = [select id, approval_step__c from Forms__c limit 1];
        testform.I_Agree_with_Terms_Approver_1__c = false;
        testform.I_Agree_with_Terms_Approver_2__c = true;
        update testform;
        req2 = new Approval.ProcessWorkitemRequest();
        newWorkItemIds = result2.getNewWorkitemIds();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setWorkitemId(newWorkItemIds.get(0));
        try{
            Approval.ProcessResult result3 =  Approval.process(req2);
        }catch(Exception e){}

      
        
        Test.stopTest();
    }
    
}