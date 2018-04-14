@isTest
public class FormsApprovalReassignment_Schedule_Test {

    @isTest
    static void testApprovalReassignment_Schedule(){
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
        Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
        
        string datestring = '2016-11-22 16:47:07';
        User u = new User(Session_Timestamp__c = datetime.valueof(dateString), FirstName='Bob', LastName='Smith', lan_ID__c='smith123', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
        
        Account a = new account (name='acme');
            insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
            insert c;    
        
        //Approvers
         User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
                  email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u2;
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123');
        insert c2;    
        user u3 = [select id from user limit 1];
          
        u.Supervisor__c = u2.ID;
        u.delegatedapproverid = u2.id;
        update u;
        c.Supervisor__c = u2.ID;
        update c;        
        
        u2.Supervisor__c = u3.ID;
        u2.lan_id__c = c2.lan_id__c;
        update u2;
        c2.Supervisor__c = u3.id;
        update c2;
        
        //test Form     
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'Sample_Record_Type'].ID);
        insert form;
        
        //Approval Process
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id); 
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        //reassign approver
         id aGroup = [select id from group limit 1].id;
        id bGroup = [select id from group where id != :aGroup limit 1].id;
    
        ProcessInstanceWorkItem Pitem = [SELECT ActorID, OriginalActorId 
            FROM ProcessInstanceWorkItem
            WHERE ProcessInstance.TargetObjectId = :form.ID limit 1];
        
        Pitem.ActorID = aGroup;
        Pitem.OriginalActorId = bGroup;
        update Pitem;
        
        //run scheduled code
        Test.StartTest();
            FormsApprovalReassignment_Schedule sh1 = new FormsApprovalReassignment_Schedule();
            String sch = '0 0 23 * * ?'; system.schedule('Test ApprovalReassignment', sch, sh1);
        Test.stopTest(); 
        
    }
    @isTest
    static void testApprovalReassignment_Schedule2(){
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
        Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
        
        string datestring = '2016-11-22 16:47:07';
        User u = new User(Session_Timestamp__c = datetime.valueof(dateString), FirstName='Bob', LastName='Smith', lan_ID__c='smith123', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
        
        Account a = new account (name='acme');
            insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
            insert c;    
        
        //Approvers
         User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
                  email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u2;
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123');
        insert c2;    
        user u3 = [select id from user limit 1];
        
        u.Supervisor__c = u2.ID;
        u.delegatedapproverid = u2.id;
        update u;
        c.Supervisor__c = u2.ID;
        update c;        
        
        u2.Supervisor__c = u3.ID;
        u2.lan_id__c = c2.lan_id__c;
        update u2;
        c2.Supervisor__c = u3.id;
        update c2;
        
        
        //test Form     
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'Sample_Record_Type'].ID);
        insert form;
        
        //Approval Process
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id); 
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        //reassign approver
         id aGroup = [select id from group limit 1].id;
        id bGroup = [select id from group where id != :aGroup limit 1].id;
    
        ProcessInstanceWorkItem Pitem = [SELECT ActorID, OriginalActorId 
            FROM ProcessInstanceWorkItem
            WHERE ProcessInstance.TargetObjectId = :form.ID limit 1];
        
        Pitem.ActorID = u3.id;
        Pitem.OriginalActorId = u2.id;
        update Pitem;
        
        //run scheduled code
        Test.StartTest();
            FormsApprovalReassignment_Schedule sh1 = new FormsApprovalReassignment_Schedule();
            String sch = '0 0 23 * * ?'; system.schedule('Test ApprovalReassignment', sch, sh1);
        Test.stopTest(); 
        
    }

    
}