@isTest
public class TQBLOITriggerTest {
   
    @isTest static void testCountTQBLetterOfIntentTrigger() {
         String errorMessage;
        try {
           TestDataFactory.createLOIRecords(2);
        }
        catch(DMLException e) {
            System.debug(e.getDmlMessage(0));
           errorMessage = e.getDmlMessage(0);
        }        
        System.assertEquals(errorMessage,'You cannot add more than one LOI');
    }
    
    @isTest static void testPositiveTQBLetterOfIntentTrigger() {    
        
        List<TQB_Letter_of_Intent__c> LOIList =  TestDataFactory.createLOIRecords(1);
        Test.startTest();               
          Database.SaveResult[] lsr = Database.insert(LOIList,false);
        Test.stopTest();
        System.assertEquals(1, lsr.size());
    }   
}