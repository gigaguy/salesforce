@isTest
public class TQB1stLineSupervisorLPTest {
    
    @isTest static void testGetLOIs() {
        List<User> firstLineUser = TestDataFactory.create1stLineUser(1);
        List<User> secondLineUser = TestDataFactory.create2ndLineUser(1);
        User candidateUser = TestDataFactory.createUser();
        System.runAs(candidateUser) {
          TQB_Letter_of_Intent__c LOI = new TQB_Letter_of_Intent__c(Current_Lab_Work_Location_Assignment__c='Office of Science Policy',
                                                                               Current_GS_Level__c='GS 13',
                                                                               CurrentRegion__c='Region 1',
                                                                               IntendedTrack__c='Research',
                                                                               Status__c='Submitted',
                                                                               Candidates_1st_Line_Supervisor_Name__c= firstLineUser[0].Id,
                                                                               Candidates_2nd_Line_Supervisor_Name__c= secondLineUser[0].Id);
         insert LOI;
        }
        System.debug('value of 1st line user id'+ firstLineUser[0].Id);
        System.debug('value of Candidate user id'+ candidateUser.Id);
        System.runAs(firstLineUser[0]) {
            Test.startTest();
             List<TQB_Letter_of_Intent__c> LOIList1stLineSupervisor = TQB1stLineSupervisorLPController.getLOIs();
             system.debug(LOIList1stLineSupervisor);
            Test.stopTest();
            System.assertEquals(1, LOIList1stLineSupervisor.size(), 'Incorrect No of LOIs retrieved');
            
        }
    }
        
    @isTest static void testGetCPs() {
        List<User> firstLineUser = TestDataFactory.create1stLineUser(1);
        List<User> secondLineUser = TestDataFactory.create2ndLineUser(1);
        User candidateUser = TestDataFactory.createUser();
        System.runAs(candidateUser) {
          TQB_Letter_of_Intent__c LOI = new TQB_Letter_of_Intent__c(Current_Lab_Work_Location_Assignment__c='Office of Science Policy',
                                                                               Current_GS_Level__c='GS 13',
                                                                               CurrentRegion__c='Region 1',
                                                                               IntendedTrack__c='Research',
                                                                               Status__c='Submitted',
                                                                               Candidates_1st_Line_Supervisor_Name__c= firstLineUser[0].Id,
                                                                               Candidates_2nd_Line_Supervisor_Name__c= secondLineUser[0].Id);
         insert LOI;
         TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        }
        
        System.runAs(firstLineUser[0]) {
            Test.startTest();
             List<TQB_Candidate_Package__c> CPList1stLineSupervisor = TQB1stLineSupervisorLPController.getCPs();
             Test.stopTest();
             System.assertEquals(1, CPList1stLineSupervisor.size(), 'Incorrect No of CPs retrieved');
        }
    }
}