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
        // 9/21/2017 - Larry Spackman - Disabled for deployment to Production because HeaderLogs custom object not being deployed
        /*
        //UtilityMethods.logHeaders();
        */
        utilityMethods.validateSession('12345', u.id);
    }
    @isTest
    static void testGetPCRecordTypes(){
        Map<String,String> result = UtilityMethods.getPCRequestRecordTypes();
        System.assert(result.values().size() ==9);
    }
    @isTest
    static void testIsPurchaseCardFormId(){
		Boolean res = UtilityMethods.isPurchaseCardFormId('abc');
        System.assert(res!=null);
    }
    @isTest
    static void testPCRequestRecordTypeMappings(){
		Map<String,String> res = UtilityMethods.getPCRequestRecordTypeMappings();
        System.assert(res!=null);
    }
}