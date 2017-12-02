@isTest
public class logoutPageController_Test {

    @isTest
    static void testController(){
        insert new WAM_URL__c(name='WAM URL', Url__c = 'http://www.google.com');
        
       //Insert Test Data        
            Profile p = [select id, name from profile where name = 'Forms Profile'];  
       User u = new User(FirstName='Bob', LastName='Smith', lan_ID__c='smith123', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
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