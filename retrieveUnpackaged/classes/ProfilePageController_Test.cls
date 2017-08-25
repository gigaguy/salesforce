@isTest
public class ProfilePageController_Test {

    @isTest
    static void testController_t1User(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'AuthTest Profile'];        
        
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
        
        system.runas(u) {
        Test.setCurrentPageReference(new PageReference('Page.ProfilePage')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '12345');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        ProfilePageController controller = new ProfilePageController();
        controller.validateOrRedirect();
        controller.save();       
        system.debug('controller.profSaved: '+controller.profSaved);
        controller.cancel();
         }
    }
    
    @isTest
    static void testController_NOTt1User(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        User u = [select id, Lan_ID__c, FirstName, LastName from User where isActive = true limit 1];
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        update u;
        
        Account a = new Account(name = 'acme');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'jones', Lan_ID__c = u.Lan_ID__c);
        insert c;
        
     System.runAs(u){
        Test.setCurrentPageReference(new PageReference('Page.ProfilePage')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getHeaders().put('Host', 'epaoei');
        System.currentPageReference().getHeaders().put('sID', '12345');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        ProfilePageController controller = new ProfilePageController();
 //     controller.validateOrRedirect();
        controller.save();
        controller.cancel();
        } // end runAs(u)
    }  
    
    @isTest
    static void testController_InvalidUser(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'AuthTest Profile'];        
        
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
        
        system.runas(u) {
        Test.setCurrentPageReference(new PageReference('Page.ProfilePage')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        ProfilePageController controller = new ProfilePageController();
        controller.validateOrRedirect();
        }
    }    
        
}