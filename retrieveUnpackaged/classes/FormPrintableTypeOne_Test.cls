@isTest
public class FormPrintableTypeOne_Test {

    @isTest
    static void testController(){
   
      //add test user   
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
        
        FormPrintableTypeOne controller = new FormPrintableTypeOne();
        controller.valid = true;
        controller.validateOrRedirect();
        controller.valid = false;
        controller.validateOrRedirect();  
    }
}