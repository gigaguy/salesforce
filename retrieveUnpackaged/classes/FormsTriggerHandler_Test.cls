@istest
public class FormsTriggerHandler_Test {

    @isTest
    static void testTrigger(){
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
}