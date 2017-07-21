@istest
public class UtilityMethods_Test {

    @isTest
    static void sessionMethods(){
        Test.setCurrentPageReference(new PageReference('Page.FormPage')); 
		System.currentPageReference().getParameters().put('sID', '12345');
        system.assertEquals('12345', UtilityMethods.getSessionID());
        
        User u = [select id, FirstName, LastName from User where isActive = true limit 1];
        u.Session_Token__c = '12345';
        update u;
        
        system.assertEquals(u.ID, utilityMethods.getUserID('12345'));
        system.assertEquals(u.FirstName + ' ' + u.LastName, UtilityMethods.getUserName(u.id));
       	UtilityMethods.generateSessionID(15);
        UtilityMethods.logHeaders();
        utilityMethods.validateSession('12345', u.id);
    }
}