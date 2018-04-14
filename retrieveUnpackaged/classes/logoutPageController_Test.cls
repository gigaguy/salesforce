@isTest
public class logoutPageController_Test {

    @isTest
    static void testController(){
        insert new WAM_URL__c(name='WAM URL', Url__c = 'http://www.google.com');
        
        User u = [select id, FirstName, LastName from User where isActive = true limit 1];
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        update u;
        
        Test.setCurrentPageReference(new PageReference('Page.LogoutPage')); 
        System.currentPageReference().getParameters().put('sID', '12345');

        logoutPageController controller = new logoutPageController();
        controller.cancel();
        controller.logout();
    }
}