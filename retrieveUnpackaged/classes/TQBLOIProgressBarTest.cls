@isTest
public class TQBLOIProgressBarTest {
    
   @isTest static void testGetLetters() {
        
        TestDataFactory.createLOIRecords(1);
        Test.startTest();
            List<TQB_Letter_of_Intent__c> TQBLOIList = TQBLOIProgressBarController.getLetters();
        Test.stopTest();
        System.assertEquals(1, TQBLOIList.size(), 'Incorrect No of LOIs retrieved');         
    }    

}