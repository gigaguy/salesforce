@isTest
public class TQBCPTriggerTest {
    
    @isTest static void testErrorConditionTQBCandidatePackageTrigger() {
        String errorMessage;
        try{
             Test.startTest();
              User candidateUser = TQBCPTriggerTest.createLOINCP(1);
              System.runAs(candidateUser) {
                  TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
              }
              Test.stopTest();
            }
        catch(DMLException e) {
            System.debug(e.getDmlMessage(0));
           errorMessage = e.getDmlMessage(0);
        }
        System.assert(errorMessage == null );
    }
    
    @isTest static void testCPMoreThanOneTQBCandidatePackageTrigger() {
        String errorMessage;
        try{
             Test.startTest();
             User candidateUser = TQBCPTriggerTest.createLOINCP(1);
              System.runAs(candidateUser) {
                  TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
                  TQB_Candidate_Package__c newCP1 = TQBCPWizardController.createCandidatePackage();
              }
              Test.stopTest();
            }
        catch(DMLException e) {
           errorMessage = e.getDmlMessage(0);
        }
        System.assertEquals(errorMessage,'You cannot add more than one Candidate package');
    }
    
    @isTest static void testCPSubmissionTQBCandidatePackageTrigger() {
        String errorMessage;
        try{              
             Test.startTest();
           User candidateUser = TQBCPTriggerTest.createLOINCP(1);
              System.runAs(candidateUser) {
                  TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
                  newCP.Status__c ='Submitted';
                  upsert newCP;
              }
              Test.stopTest();
            }
        catch(DMLException e) {
           errorMessage = e.getDmlMessage(0);
        }
        System.assertEquals(errorMessage,'You cannot submit new Candidate Package before LOI is Approved');
    }
    
    @isTest static void testCountTQBCandidatePackageTrigger() {
        String errorMessage;
        try {
          User candidateUser = TQBCPTriggerTest.createLOINCP(1);
          System.runAs(candidateUser) {
              Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
              Id candpkgId1 =  TQBCPWizardControllerTest.createCandidatePackage();
          }
        }
        catch(DMLException e) {
            System.debug(e.getDmlMessage(0));
           errorMessage = e.getDmlMessage(0);
        }        
        System.assertEquals(errorMessage,'You cannot add more than one Candidate package');
    }
    
    public static User createLOINCP(Integer count) {
        List<User> firstLineUser = TestDataFactory.create1stLineUser(1);
        List<User> secondLineUser = TestDataFactory.create2ndLineUser(1);
        List<TQB_Letter_of_Intent__c> LOI;
        User candidateUser = TestDataFactory.createUser();
        TQB_Candidate_Package__c newCP;
        System.runAs(candidateUser) {  
         LOI = TestDataFactory.createLOIRecords(count, candidateUser, firstLineUser[0], secondLineUser[0]);
        }   
        return candidateUser;
    }

}