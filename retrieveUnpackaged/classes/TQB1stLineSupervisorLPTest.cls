@isTest
public class TQB1stLineSupervisorLPTest {
    
    @isTest static void testGetLOIs() {
        
        TestDataFactory.createLOIRecords(1);
        Test.startTest();
         List<TQB_Letter_of_Intent__c> LOIList1stLineSupervisor = TQB1stLineSupervisorLPController.getLOIs();
         system.debug(LOIList1stLineSupervisor);
        Test.stopTest();
        System.assertEquals(1, LOIList1stLineSupervisor.size(), 'Incorrect No of LOIs retrieved');
    }
    
    @isTest static void testGetCPs() {
        
        TestDataFactory.createLOIRecords(1);
        Test.startTest();
         TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
         TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
         List<TQB_Candidate_Package__c> CPList1stLineSupervisor = TQB1stLineSupervisorLPController.getCPs();
         Test.stopTest();
         System.assertEquals(1, CPList1stLineSupervisor.size(), 'Incorrect No of CPs retrieved');
    }
}