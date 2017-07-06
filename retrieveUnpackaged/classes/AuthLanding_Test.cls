@isTest
public class AuthLanding_Test {

    @isTest
    static void testController(){
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.FederationIdentifier = 'unAuth1';
        update u;
        
        AuthLanding controller = new AuthLanding();
        controller.onLoad();
        
        Test.setCurrentPageReference(new PageReference('Page.AuthLanding'));
		System.currentPageReference().getParameters().put('uID', 'unAuth1');
        
        controller = new AuthLanding();
        controller.onLoad();
    }
}