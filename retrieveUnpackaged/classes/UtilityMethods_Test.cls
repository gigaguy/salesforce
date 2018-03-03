@istest
public class UtilityMethods_Test {

    @isTest
    static void sessionMethods(){
        Test.setCurrentPageReference(new PageReference('Page.FormPage')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        system.assertEquals('12345', UtilityMethods.getSessionID());
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        ApexPages.currentPage().getHeaders().put('User-Agent', 'chrome'); 
        
         //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile']; 
         User u = new User(FirstName='Bob', LastName='Smith', lan_ID__c='smith123', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u; 
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        update u;
        
        User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
                  email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u2;
        u2.Session_Token__c = '12346';
        u.Session_IP__c = '111-111-1112';
        update u2;
        
        system.assertEquals(u.ID, utilityMethods.getUserID('12345'));
        system.assertEquals(u.FirstName + ' ' + u.LastName, UtilityMethods.getUserName(u.id));
        UtilityMethods.generateSessionID(15);
        // 9/21/2017 - Larry Spackman - Disabled for deployment to Production because HeaderLogs custom object not being deployed
        /*
        //UtilityMethods.logHeaders();
        */
        
        utilityMethods.validateSession('12345', u.id); // returns TRUE
        utilityMethods.validateSession('12346', u2.id); // returns FALSE
        
        utilityMethods.getLicName(u.id);
    }
}