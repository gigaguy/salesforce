@istest
public class FormsTriggerHandler_Test {

    @isTest
    static void testTrigger(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
        //Insert Test Data        
            Profile p = [select id, name from profile where name = 'AuthTest Profile'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
    
            User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
                  email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u2;
            
            User u3 = new User(FirstName='Sally', LastName='Lee', profileID=p.id, Username='test3@fake.ccc', 
                  email='test@fake.ccc', Alias='testU3', CommunityNickname='testU3', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u3;
            
        
        u.Supervisor__c = u2.ID;
        update u;
        u2.Supervisor__c = u3.ID;
        update u2;
        
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        system.assertEquals(u2.ID, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        form.Unauthenticated_Owner__c = u2.Id;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id); 
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        
        update form;
        system.assertEquals(u3.ID, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        
    }

@isTest(seeAllData=true)
    static void testTriggerB(){
        
        //Insert Test Data        
            Profile p = [select id, name from profile where name = 'AuthTest Profile'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
    
            User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
                  email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u2;
            
            User u3 = new User(FirstName='Sally', LastName='Lee', profileID=p.id, Username='test3@fake.ccc', 
                  email='test@fake.ccc', Alias='testU3', CommunityNickname='testU3', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u3;
            
        // inserting records for using Contact fields for Approval process (Lan_ID__c fields having matching values on User & Contact records)
        Account a = new account (name='acme');
        insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123');
        insert c;
        insert c2;
        
        u.Supervisor__c = u2.ID;
        u.lan_id__c = c.lan_id__c;
        update u;
        c.Supervisor__c = u2.ID;
        update c;        
        
        u2.Supervisor__c = u3.ID;
        u2.lan_id__c = c2.lan_id__c;
        update u2;
        c2.Supervisor__c = u3.id;
        update c2;
        
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        system.assertEquals(u2.ID, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        form.Unauthenticated_Owner__c = u2.id;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id); 
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        
        update form;
        system.assertEquals(u3.ID, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        
    }

    @isTest
    static void testTriggerC(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'AuthTest Profile'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'SF_182'].ID);
        insert form;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();

        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        form.Unauthenticated_Owner__c = null;
        update form;
        system.assertEquals(null, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        
    }
    
    @isTest
    static void testTriggerD(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'AuthTest Profile'];        
            
            User uMgr = new User(FirstName='Rob', LastName='Jones', Lan_ID__c = 'thetest1', profileID=p.id, Username='test1@fake.ccc', 
                  email='test@fake.ccc', Alias='testU1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert uMgr;
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', Time_Keeper__c = null);
            insert u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'SF_182'].ID);
        insert form;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();

        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        form.Unauthenticated_Owner__c = null;
        update form;
        system.assertEquals(null, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        
        form.approval_step__c = 'Approved';
        update form;
        
    }

}