@isTest
public class WebFormsMenuVFController_Test {

    @isTest
    static void testController(){
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = '123ABC';
        update u;
        
        Test.setCurrentPageReference(new PageReference('Page.AuthLanding'));
		System.currentPageReference().getParameters().put('sID', '123ABC');
        
        WebFormsMenuVFController controller = new WebFormsMenuVFController();
        controller.onLoad();
        controller.navtoFormsPage();
        controller.navToProfilePage();
    }
}