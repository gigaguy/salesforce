@isTest
public class TQBLOITriggerTest {
   
    @isTest static void testCountTQBLetterOfIntentTrigger() {
         String errorMessage;
        try {
          TQBLOITriggerTest.createLOINCP(2);
          
        }
        catch(DMLException e) {
            System.debug(e.getDmlMessage(0));
           errorMessage = e.getDmlMessage(0);
        }        
        System.assertEquals(errorMessage,'You cannot add more than one LOI');
    }
    
    @isTest static void testPositiveTQBLetterOfIntentTrigger() {    
        
        List<TQB_Letter_of_Intent__c> LOIList = TQBLOITriggerTest.createLOINCP(1);
        
        Test.startTest();               
          Database.SaveResult[] lsr = Database.insert(LOIList,false);
        Test.stopTest();
        System.assertEquals(1, lsr.size());
    }   
    
    public static List<TQB_Letter_of_Intent__c> createLOINCP(Integer count) {
        List<User> firstLineUser = TestDataFactory.create1stLineUser(1);
        List<User> secondLineUser = TestDataFactory.create2ndLineUser(1);
        List<TQB_Letter_of_Intent__c> LOI;
        User candidateUser = TestDataFactory.createUser();
        TQB_Candidate_Package__c newCP;
        System.runAs(candidateUser) {  
         LOI = TestDataFactory.createLOIRecords(count, candidateUser, firstLineUser[0], secondLineUser[0]);
        }   
        return LOI;
    }
    
}