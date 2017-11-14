@isTest
public class FormPageVFController_Test {

    @isTest
    static void testOnLoad(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = '123ABC';
        update u;
        
        Test.setCurrentPageReference(new PageReference('Page.FormPage'));
        System.currentPageReference().getParameters().put('sID', '123ABC');
        
        FormPageVFController controller = new FormPAgeVFController();
        //controller.onLoad();
        controller.validateOrRedirect();
        system.assertEquals(u.ID, controller.UID); 
        controller.logout();
    }
 
    @isTest
    static void testMissingContact(){    
     insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'Forms Profile'];        
            
    User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
              email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        u.Lan_ID__c = 'testLan';
        update u;
        
        Test.setCurrentPageReference(new PageReference('Page.FormPage'));
        System.currentPageReference().getParameters().put('sID', '12345');
        
        FormPageVFController controller = new FormPAgeVFController();
    }
 
    @isTest
    static void testWithContact(){    
     insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'Forms Profile'];        
            
    User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
              email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        u.Lan_ID__c = 'testLan';
        update u;
        
        Account a = new Account(name = 'acme');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'jones', Lan_ID__c = u.Lan_ID__c);
        insert c;
        
        Test.setCurrentPageReference(new PageReference('Page.FormPage'));
        System.currentPageReference().getParameters().put('sID', '12345');
        
        FormPageVFController controller = new FormPAgeVFController();
    }
  
    @isTest
    static void testNoApprovers(){    
     insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'Forms Profile'];        
            
    User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
              email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        u.Lan_ID__c = 'testLan';
        update u;
        
        Test.setCurrentPageReference(new PageReference('Page.FormPage'));
        System.currentPageReference().getParameters().put('sID', '12345');
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        ApexPages.currentPage().getHeaders().put('User-Agent', 'chrome'); 
        
        FormPageVFController controller = new FormPAgeVFController();
        controller.validateOrRedirect();
    }  

}