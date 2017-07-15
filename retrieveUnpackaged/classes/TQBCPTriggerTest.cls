@isTest
public class TQBCPTriggerTest {
    
    @isTest static void testErrorConditionTQBCandidatePackageTrigger() {
        String errorMessage;
        try{
             User user = TestDataFactory.createUser();
             Test.startTest();
              System.runAs(user) {
                  TestDataFactory.createLOIRecords(1);
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
             User user = TestDataFactory.createUser();
             Test.startTest();
              System.runAs(user) {
                  TestDataFactory.createLOIRecords(1);
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
             User user = TestDataFactory.createUser();
              
             Test.startTest();
              System.runAs(user) {
                  TQB_Letter_of_Intent__c LOI = new TQB_Letter_of_Intent__c(Current_Lab_Work_Location_Assignment__c='Office of Science Policy',
                                                                               Current_GS_Level__c='GS 13',
                                                                               CurrentRegion__c='Region 1',
                                                                               IntendedTrack__c='Research',
                                                                               Status__c='In Progress',
                                                                               Candidates_1st_Line_Supervisor_Name__c= '005r0000001EozMAAS',
                                                                               Candidates_2nd_Line_Supervisor_Name__c= '005r0000001EozCAAS');
                  insert LOI;
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
          TestDataFactory.createLOIRecords(1);
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          Id candpkgId1 =  TQBCPWizardControllerTest.createCandidatePackage();
        }
        catch(DMLException e) {
            System.debug(e.getDmlMessage(0));
           errorMessage = e.getDmlMessage(0);
        }        
        System.assertEquals(errorMessage,'You cannot add more than one Candidate package');
    }

}