@isTest
public class TQBPoliciesProceduresNBulletinBoardTest {
    
    @isTest static void testGetPoliciesAndProcedures() {
        
        TestDataFactory.createPoliciesNProceduresRecords(2);
        Test.startTest();
            List<TQB_Policies_and_Procedures__c> TQBPoliciesNProceduresList = TQBpoliciesAndProceduresController.getPoliciesAndProcedures();
        Test.stopTest();
        System.assertEquals(2, TQBPoliciesNProceduresList.size(), 'Incorrect No of policies and procedures retrieved');         
    }
    
     @isTest static void testGetBulletinPosts() {
        
        TestDataFactory.createBulletinBoardRecords(2);
        Test.startTest();
            List<TQB_Bulletin_Board__c> TQBBulletinBoardList = TQBbulletinBoardController.getBulletinPosts();
        Test.stopTest();
        System.assertEquals(2, TQBBulletinBoardList.size(), 'Incorrect No of bulletin board retrieved');         
    }
    
    @isTest static void testGetCurrentUser() {
        
        TestDataFactory.createUser();
        Test.startTest();
            User user = TQBRunningUserCtrl.getCurrentUser();
        Test.stopTest();         
    }
}