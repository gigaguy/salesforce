@istest
public class UtilityMethods_Test {

    @isTest
    static void sessionMethods(){
        Test.setCurrentPageReference(new PageReference('Page.FormPage')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        system.assertEquals('12345', UtilityMethods.getSessionID());
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        ApexPages.currentPage().getHeaders().put('User-Agent', 'chrome'); 
        
        User u = [select id, FirstName, LastName from User where isActive = true limit 1];
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        update u;
        
        User u2 = [select id, FirstName, LastName from User where isActive = true AND id != :u.id limit 1];
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