//Developer :Naveen Sadhu
//Test cases for TQBCPWizardController apex server controller

@isTest
public class TQB2ndLineSupervisorLPControllerTest {
    
    @isTest static void testGetCPs2ndLine() { 
        User secondLineUser = TestDataFactory.create2ndLineUserTest();
        TestDataFactory.createLOIRecords(1);
        TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        System.runAs(secondLineUser) {        
           Test.startTest();
             List<TQB_Candidate_Package__c> candPkg = TQB2ndLineSupervisorLPController.getCPs();
           Test.stopTest();
           System.debug('value of candpkg obtained'+ candPkg.size());
           System.assert(candPkg.size() != 0);
        }
    }
    
       
     @isTest static void testGetCPsChairPerson() { 
        User chairUser = TestDataFactory.createChairUserTest();
        TestDataFactory.createLOIRecords(1);
        TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        System.runAs(chairUser) {        
           Test.startTest();
             List<TQB_Candidate_Package__c> candPkg = TQBChairPersonController.getCPs();
           Test.stopTest();
           System.debug('value of candpkg obtained'+ candPkg.size());
           System.assert(candPkg.size() == 0);
        }
    }
    
    
    @isTest static void testGetCPsCoordinatorPerson() { 
         User coordinatorUser = TestDataFactory.createCoordinatorUserTest();
        TestDataFactory.createLOIRecords(1);
        TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        System.runAs(coordinatorUser) {        
           Test.startTest();
             List<TQB_Candidate_Package__c> candPkg = TQBCoordinatorController.getCPs();
           Test.stopTest();
           System.debug('value of candpkg obtained for coordinator'+ candPkg.size());
           System.assert(candPkg.size() == 0);
        }
    }
    

}