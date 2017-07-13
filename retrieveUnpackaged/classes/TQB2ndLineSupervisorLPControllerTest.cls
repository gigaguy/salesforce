//Developer :Naveen Sadhu
//Test cases for TQBCPWizardController apex server controller

@isTest
public class TQB2ndLineSupervisorLPControllerTest {
    
   /* @isTest static void testGetCPs2ndLine() { 
        TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        Test.startTest();
          List<TQB_Candidate_Package__c> candPkg = TQB2ndLineSupervisorLPController.getCPs();
        Test.stopTest();
        System.debug('value of candpkgs'+ candPkg);
    }*/
    
    @isTest static void testGetCPs2ndLine() { 
            // Setup test data
          // This code runs as the system user
          Profile p = [SELECT Id FROM Profile WHERE Name='TQB 2nd Line Supervisor Platform']; 
          User u = new User(Alias = 'standt2', Email='standarduser2ndLine@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing2ndLine', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id,  
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2ndLine@testorg.com');
           
          insert u;
          System.runAs(u) {
             // The following code runs as user 'u' 
            TQB_Letter_of_Intent__c LOI = new TQB_Letter_of_Intent__c(Current_Lab_Work_Location_Assignment__c='Office of Science Policy',
                                                                               Current_GS_Level__c='GS 13',
                                                                               CurrentRegion__c='Region 1',
                                                                               IntendedTrack__c='Research',
                                                                               Status__c='Submitted',
                                                                               Candidates_1st_Line_Supervisor_Name__c= u.Id,
                                                                               Candidates_2nd_Line_Supervisor_Name__c= u.Id);
             insert LOI;
             TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
              Test.startTest();
               List<TQB_Candidate_Package__c> candPkg = TQB2ndLineSupervisorLPController.getCPs();
              Test.stopTest();
             System.debug('value of candpkgs'+ candPkg); 
          }
    }
    
     /*@isTest static void testGetCPsChairPerson() { 
        TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        Test.startTest();
          List<TQB_Candidate_Package__c> candPkg = TQBChairPersonController.getCPs();
          System.runAs(user, block)
        Test.stopTest();
        System.debug('value of candpkgs'+ candPkg);
        System.assertEquals(candPkg.size(), 0);
    }
    
    @isTest static void testGetCPsCoordinatorPerson() { 
        TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        Test.startTest();
          List<TQB_Candidate_Package__c> candPkg = TQBCoordinatorController.getCPs();
        Test.stopTest();
        System.debug('value of candpkgs'+ candPkg);
        System.assertEquals(candPkg.size(), 0);
    }*/
    

}