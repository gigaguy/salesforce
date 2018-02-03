@isTest
public class FormPrintable_Test {

    @isTest
    static void testController(){
   
      //add test form
       insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true limit 1];
       User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and id != :u.id limit 1];
        u.Session_Token__c = '123ABC';
        u.Supervisor__c = u2.id;
        u.Supervisor_2__c = u2.id;
        u.Lan_ID__c = 'thetest';
        update u;

        //siteUser
        User uSU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id limit 1];
        
        //apiUser
        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];

        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
     
        Forms__c testForm = new Forms__c();
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.RecordTypeID = [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].id;
        insert testForm;
 
 
 Test.setCurrentPageReference(new PageReference('Page.FormPrintablePDF'));
        ApexPages.StandardController stdCont= new ApexPages.StandardController(testForm);

        FormPrintable controller = new FormPrintable(stdCont);
    }

}