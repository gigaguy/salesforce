@isTest
public class TQBHomeProgressBarTest {
    
    @isTest static void testGetLetters() {
        User candidateUser = TQBCPWizardControllerTest.createLOINCP();
        System.runAs(candidateUser) { 
            Test.startTest();
                List<TQB_Letter_of_Intent__c> TQBLOIList = TQBHomeProgressBarController.getLetters();
            Test.stopTest();
         System.assertEquals(1, TQBLOIList.size(), 'Incorrect No of LOIs retrieved');  
        }
    }
    
    @isTest static void testGetPackagess() {
        
        User candidateUser = TQBCPWizardControllerTest.createLOINCP();
        System.runAs(candidateUser) { 
        Test.startTest();
             TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
             TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
            List<TQB_Candidate_Package__c> TQBCPList = TQBHomeProgressBarController.getPackages();
        Test.stopTest();
        System.assertEquals(1, TQBCPList.size(), 'Incorrect No of CPs retrieved');         
     }
    }
}