@istest
public class FormsTriggerHandler_Test {

    @isTest
    static void testTrigger(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Id != :u.ID limit 1];
        User u3 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Id != :u.ID and ID != :u2.Id limit 1];
		
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
    
    @isTest
    static void testTriggerB(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Id != :u.ID limit 1];
        User u3 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Id != :u.ID and ID != :u2.Id limit 1];
		
        u.Supervisor__c = u2.ID;
        update u;
        u2.Supervisor__c = u3.ID;
        update u2;
        
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        //system.assertEquals(u2.ID, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        form.Unauthenticated_Owner__c = u2.Id;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id); 
        
        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        
        update form;
        //system.assertEquals(u3.ID, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        
    }
    @isTest
    static void testTrigger2(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Id != :u.ID limit 1];
        User u3 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Id != :u.ID and ID != :u2.Id limit 1];
        
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
}