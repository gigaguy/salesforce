//Developer :Naveen Sadhu
//Test cases for TQBCPWizardController apex server controller

@isTest
public class TQBCPWizardControllerTest {
    
    @isTest static void testGetCandidatePackage() {
        
        TestDataFactory.createCPRecords(1);
        Test.startTest();               
          TQB_Candidate_Package__c cp = TQBCPWizardController.getCandidatePackage();
        Test.stopTest();
        System.assert(cp.Id!=null);
    }        
    
     @isTest static void testSaveCandidatePackage() {
        
        List<TQB_Candidate_Package__c> candidatePackage = TestDataFactory.createCPRecords(1);
        Test.startTest();               
          TQB_Candidate_Package__c cp = TQBCPWizardController.saveCandidatePackage(candidatePackage.get(0));
        Test.stopTest();
        System.assert(cp.Id!=null);
    }
    
    @isTest static void testCreateCandidatePackage() {
        
        TestDataFactory.createLOIRecords(1);
        Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
        Test.stopTest();
        System.assert(newCP.Id!=null);  
        System.assert(cp.Id!=null);
    }
    
    @isTest static void testvalidateCandidateQuestionnaireTrue() {
        TestDataFactory.createLOIRecords(1);
        Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          TestDataFactoryCPWizard.createCPQuestions(1,cp.Id);
          TQBCPWizardController.validateCandidateQuestionnaire(cp.Id);
        Test.stopTest();        
    }
    
    @isTest static void testvalidateCandidateQuestionnaireFalse() {
        String errorMessage;
        try{
             TestDataFactory.createLOIRecords(1);
            Test.startTest();  
              TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
              TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
              TestDataFactoryCPWizard.createCPQuestions(1,cp.Id);
              TQBCPWizardController.validateCandidateQuestionnaire(cp.Id);
              TQBCPWizardController.submitCandidatePackage(cp.Id);
            Test.stopTest();   
        }
        catch(DMLException e) {
            System.debug(e.getDmlMessage(0));
           errorMessage = e.getDmlMessage(0);
        }
        System.assertEquals(errorMessage,'null');
    }
    
     @isTest static void testGetCandidateLOI() {
         TestDataFactory.createLOIRecords(1);
        Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          TQB_Letter_of_Intent__c LOI = TQBCPWizardController.getCandidateLOI(cp.Id);
        Test.stopTest();
         System.assert(LOI.Id!=null);      
     }
    
     @isTest static void testGetUserRole() {
         Test.startTest();  
             User loggedInUserRole = TQBCPWizardController.getUserRole();
         Test.stopTest();
         System.assert(loggedInUserRole.UserRole.Name!=null);
     }
    
    @isTest static void testsaveQuest() {
        TestDataFactory.createLOIRecords(1);
        Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Candidate_Questionnaire__c> questionlist = TestDataFactoryCPWizard.createCPQuestions(1,cp.Id);
          questionlist[0].Answer__c = 'update salesforce';
           TQB_Candidate_Questionnaire__c savedQuestion = TQBCPWizardController.saveQuest(cp.Id, questionlist[0]);
        Test.stopTest();   
         System.assertEquals(savedQuestion.Answer__c,'update salesforce');
    }
    
     @isTest static void testGetCandidateQuestions() {
          TestDataFactory.createLOIRecords(1);
          Integer questionCount = TestDataFactoryCPWizard.getQuestionsByTrack();
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Candidate_Questionnaire__c> questionlist = TQBCPWizardController.getCandidateQuestions(cp.Id);
         Test.stopTest();   
         System.assertEquals(questionlist.size(),questionCount);
     }
     
    @isTest static void testSaveQuestionCommentServer() {
        TestDataFactory.createLOIRecords(1);
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
           List<TQB_Candidate_Questionnaire__c> questionlist = TestDataFactoryCPWizard.createCPQuestions(1,cp.Id);
           String comment = TQBCPWizardController.saveQuestionCommentServer('hello', 'firstLineSupComment', cp.Id, questionlist[0].Id);
           String updatedComment = TQBCPWizardController.saveQuestionCommentServer('hello Updated', 'firstLineSupComment', cp.Id, questionlist[0].Id);
         Test.stopTest(); 
         System.assertEquals(comment,'hello');
         System.assertEquals(updatedComment,'hello Updated');
    }
    
    
    @isTest static void testPopulateQuestionCommentsServer() {
        TestDataFactory.createLOIRecords(1);
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
           List<TQB_Candidate_Questionnaire__c> questionlist = TestDataFactoryCPWizard.createCPQuestions(1,cp.Id);
           String comment = TQBCPWizardController.saveQuestionCommentServer('hello', 'firstLineSupComment', cp.Id, questionlist[0].Id);
           String populatedComment = TQBCPWizardController.populateQuestionCommentsServer(cp.Id , 'firstLineSupComment', questionlist[0].Id);
         Test.stopTest();
        System.assertEquals(comment, populatedComment);
    }
    
    @isTest static void testSaveAdHocEntry() {
        TestDataFactory.createLOIRecords(1);
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Ad_Hoc_Entry__c> adhocList = TestDataFactoryCPWizard.createCPAdhocs(1,cp.Id);
          TQB_Ad_Hoc_Entry__c adhocEntry = TQBCPWizardController.saveAdHocEntry(cp.Id, adhocList[0]);
         Test.stopTest();
         System.assert(adhocEntry.Id!=null);
    }
    
    @isTest static void testdeleteAdHoc() { 
        TestDataFactory.createLOIRecords(1);
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Ad_Hoc_Entry__c> adhocList = TestDataFactoryCPWizard.createCPAdhocs(1,cp.Id);
          TQB_Ad_Hoc_Entry__c adhocEntrySaved = TQBCPWizardController.saveAdHocEntry(cp.Id, adhocList[0]);
          TQB_Ad_Hoc_Entry__c adhocEntryDeleted = TQBCPWizardController.deleteAdHoc(adhocList[0]);
         Test.stopTest();
         System.debug('saved Entry = ' + adhocEntrySaved.Id);
         System.debug('deleted Entry = ' + adhocEntryDeleted.Id);
         System.assertEquals(adhocEntrySaved.Id, adhocEntryDeleted.Id);
    }
    
    @isTest static void testGetCandidateAdHocEntries() { 
       TestDataFactory.createLOIRecords(1);
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Ad_Hoc_Entry__c> adhocList = TestDataFactoryCPWizard.createCPAdhocs(1,cp.Id);
          TQB_Ad_Hoc_Entry__c adhocEntrySaved = TQBCPWizardController.saveAdHocEntry(cp.Id, adhocList[0]);
          List<TQB_Ad_Hoc_Entry__c> getAdhocList = TQBCPWizardController.getCandidateAdHocEntries(cp.Id);
         Test.stopTest();
        System.assertEquals(adhocList.size(), getAdhocList.size());
    }  
    
     @isTest static void testSaveAdHocCommentServer() { 
          TestDataFactory.createLOIRecords(1);
         String testValue = 'hello';
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          TQBCPWizardController.saveAdHocCommentServer(testValue,'firstLineSupComment',cp.Id);
          String commentValue = TQBCPWizardController.populateAdHocCommentsServer(cp.Id,'firstLineSupComment');
         Test.stopTest();
         System.debug('commentvalue = '+ commentValue);
         System.assertEquals(testValue, commentValue);
     }
   
    @isTest static void testSaveReviewCommentAndReturn() { 
        TestDataFactory.createLOIRecords(1);
         String testValue = 'hello';
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Comment__c> commentList = TestDataFactoryCPWizard.createCPComments(1, cp.Id);
          TQBCPWizardController.saveReviewCommentAndReturn(cp.Id, commentList[0]);
          List<TQB_Comment__c> commentListretrieved = TQBCPWizardController.getReviewComments(cp.Id);
         Test.stopTest();
        System.debug('commentList size is ='+commentList);
        System.debug('commentListretrieved size is ='+commentListretrieved.size());
        System.assertEquals(commentList.size(), commentListretrieved.size());
   }
    
    @isTest static void testSaveReviewCommentAndReject() { 
        TestDataFactory.createLOIRecords(1);
         String testValue = 'hello';
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Comment__c> commentList = TestDataFactoryCPWizard.createCPComments(1, cp.Id);
          TQBCPWizardController.saveReviewCommentAndReject(cp.Id, commentList[0],'rejected');
          List<TQB_Comment__c> commentListretrieved = TQBCPWizardController.getReviewComments(cp.Id);
         Test.stopTest();
        System.debug('commentList size is ='+commentList.size());
        System.debug('commentListretrieved size is ='+ commentListretrieved.size());
        System.assertEquals(commentList.size(), commentListretrieved.size());
   }
    
}