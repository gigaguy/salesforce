@isTest
public class FormPrintableTypeOne_Test {

    @isTest
    static void testController(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            u.Session_Token__c = '12345';
            u.Session_IP__c = '111-111-1111';
            u.Session_Environment__c = 'chrome';
            u.Session_Timestamp__c = datetime.now().addMinutes(-1);
            u.Lan_ID__c = 'thetest';
            update u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        
        System.runAs(u){
        Test.setCurrentPageReference(new PageReference('Page.FormPrintableTypeOne'));
         
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getParameters().put('formID', form.id);
        
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '12345');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        
        ApexPages.StandardController stdCont= new ApexPages.StandardController(form);
        FormPrintableTypeOne controller = new FormPrintableTypeOne(stdCont);
        controller.validateOrRedirect();
              
         }
    }
    
    @isTest
    static void testController2(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            u.Session_Token__c = '12345';
            u.Session_IP__c = '111-111-1111';
            u.Session_Environment__c = 'chrome';
            u.Session_Timestamp__c = datetime.now().addMinutes(-1);
            u.Lan_ID__c = 'thetest';
            update u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        
        System.runAs(u){
        Test.setCurrentPageReference(new PageReference('Page.FormPrintableTypeOne'));
         
        System.currentPageReference().getParameters().put('sID', 'internalSysUser');
        System.currentPageReference().getParameters().put('formID', form.id);
        
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', 'internalSysUser');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-555-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        
        ApexPages.StandardController stdCont= new ApexPages.StandardController(form);
        FormPrintableTypeOne controller = new FormPrintableTypeOne(stdCont);
        controller.validateOrRedirect();
              
         }
    }    
    
    @isTest
    static void testController3(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            u.Session_Token__c = '12345';
            u.Session_IP__c = '111-111-1111';
            u.Session_Environment__c = 'chrome';
            u.Session_Timestamp__c = datetime.now().addMinutes(-1);
            u.Lan_ID__c = 'thetest';
            update u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        
        System.runAs(u){
        Test.setCurrentPageReference(new PageReference('Page.FormPrintableTypeOne'));
         
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getParameters().put('formID', form.id);
        
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '12345');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-555-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        
        ApexPages.StandardController stdCont= new ApexPages.StandardController(form);
        FormPrintableTypeOne controller = new FormPrintableTypeOne(stdCont);
        controller.validateOrRedirect();
              
         }
    }  

}