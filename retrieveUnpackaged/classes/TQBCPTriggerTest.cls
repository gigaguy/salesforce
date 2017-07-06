@isTest
public class TQBCPTriggerTest {
    
    @isTest static void testErrorConditionTQBCandidatePackageTrigger() {
        String errorMessage;
        try{
             TestDataFactory.createLOIRecords(1);
             TestDataFactory.createCPRecords(1);
        }
        catch(DMLException e) {
            System.debug(e.getDmlMessage(0));
           errorMessage = e.getDmlMessage(0);
        }
        System.assertEquals(errorMessage,'You cannot save Candidate Package before LOI status changed to Completed');
    }
    
    @isTest static void testCountTQBCandidatePackageTrigger() {
        String errorMessage;
        try {
          TestDataFactory.createCPRecords(2);
        }
        catch(DMLException e) {
            System.debug(e.getDmlMessage(0));
           errorMessage = e.getDmlMessage(0);
        }        
        System.assertEquals(errorMessage,'You cannot add more than one Candidate package');
    }

}