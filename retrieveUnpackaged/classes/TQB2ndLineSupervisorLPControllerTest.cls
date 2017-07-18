//Developer :Naveen Sadhu
//Test cases for TQBCPWizardController apex server controller

@isTest
public class TQB2ndLineSupervisorLPControllerTest {
    
    @isTest static void testGetCPs2ndLine() { 
        List<User> firstLineUser = TestDataFactory.create1stLineUser(1);
        List<User> secondLineUser = TestDataFactory.create2ndLineUser(1);
        User candidateUser = TestDataFactory.createUser();
        System.runAs(candidateUser) {  
         TestDataFactory.createLOIRecords(1, candidateUser, firstLineUser[0], secondLineUser[0]);
         TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        }
        System.runAs(secondLineUser[0]) {        
           Test.startTest();
             List<TQB_Candidate_Package__c> candPkg = TQB2ndLineSupervisorLPController.getCPs();
           Test.stopTest();
           System.debug('value of candpkg obtained'+ candPkg.size());
           System.assert(candPkg.size() != 0);
        }
    }
    
     @isTest static void testGetCPsChairPerson() { 
        List<User> chairUser = TestDataFactory.createTQBChairUser(1);
        TQB2ndLineSupervisorLPControllerTest.createLOINCP();
        System.runAs(chairUser[0]) {        
           Test.startTest();
             List<TQB_Candidate_Package__c> candPkg = TQBChairPersonController.getCPs();
           Test.stopTest();
           System.debug('value of candpkg obtained'+ candPkg.size());
           System.assert(candPkg.size() == 0);
        }
    }
    
    
    
    @isTest static void testGetCPsCoordinatorPerson() { 
         List<User> coordinatorUser = TestDataFactory.createCoordinatorUser(1);
         TQB2ndLineSupervisorLPControllerTest.createLOINCP();
        System.runAs(coordinatorUser[0]) {        
           Test.startTest();
             List<TQB_Candidate_Package__c> candPkg = TQBCoordinatorController.getCPs();
           Test.stopTest();
           System.debug('value of candpkg obtained for coordinator'+ candPkg.size());
           System.assert(candPkg.size() == 0);
        }
    }
    
    public static void createLOINCP() {
        List<User> firstLineUser = TestDataFactory.create1stLineUser(1);
        List<User> secondLineUser = TestDataFactory.create2ndLineUser(1);
        User candidateUser = TestDataFactory.createUser();
        System.runAs(candidateUser) {  
         TestDataFactory.createLOIRecords(1, candidateUser, firstLineUser[0], secondLineUser[0]);
         TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        }
    }
    

}