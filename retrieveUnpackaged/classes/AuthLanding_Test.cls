@isTest
public class AuthLanding_Test {

    @isTest
    static void testController(){
        insert new Init_Session_URL__c(name='Init Session URL', URL__c = 'https://oeiodsta-oeiodstadev.cs33.force.com/initSession'); // checkbox from "Contact Approvers" Custom Setting
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.FederationIdentifier = 'unAuth1';
        update u;
        
        AuthLanding controller = new AuthLanding();
        controller.onLoad();
        
        Test.setCurrentPageReference(new PageReference('Page.AuthLanding'));
        System.currentPageReference().getParameters().put('uID', 'unAuth1');
        system.currentPageReference().getHeaders().put('uid', 'unAuth1');
        
        system.currentPageReference().getHeaders().put('Shib-Identity-Provider', 'https://idp.epa.gov/');
        system.currentPageReference().getHeaders().put('X-Forwarded-Host', 'oeiodstadev.epa.gov');
        controller = new AuthLanding();
        system.currentPageReference().getHeaders().remove('uid');
        system.currentPageReference().getHeaders().put('AUTH_USER', 'unAuth1');
        controller = new AuthLanding();
        system.currentPageReference().getHeaders().remove('AUTH_USER');
        system.currentPageReference().getHeaders().put('REMOTE_USER', 'unAuth1');
        controller = new AuthLanding();
        controller.onLoad();
    }
}