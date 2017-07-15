//Developer :Naveen Sadhu
//Test cases for TQBCPWizardController apex server controller

@isTest
public class TQBCPWizardControllerTest {
    
    @isTest static void testGetCandidatePackage() {
        User user = TestDataFactory.createUser();
        Test.startTest();
          System.runAs(user) {
              TestDataFactory.createLOIRecords(1);
              TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
              TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
              TQB_Candidate_Package__c cpRetrieved = TQBCPWizardController.getCandidatePackage();
                System.debug(cpRetrieved.Id);
                System.assert(cpRetrieved.Id != null);
            } 
        Test.stopTest();
    }  
    
    @isTest static void testGetCPbyCandidateName() {
        User user = TestDataFactory.createUser();
        Test.startTest();
          System.runAs(user) {
              TestDataFactory.createLOIRecords(1);
              TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
              TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
              TQB_Candidate_Package__c cpRetrieved = TQBCPWizardController.getCandidatePackage();
               TQB_Candidate_Package__c cpRetrievedWithCandidateName = TQBCPWizardController.getCPbyCandidateName(cpRetrieved.CreatedById);
                System.debug('Retrieved candidate Name = '+ cpRetrievedWithCandidateName.Id);
                System.assert(cpRetrievedWithCandidateName.Id != null);
            } 
        Test.stopTest();
    }
    
     @isTest static void testSaveCandidatePackage() {
        TestDataFactory.createLOIRecords(1);
        Test.startTest();
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          TQB_Candidate_Package__c cpSaved = TQBCPWizardController.saveCandidatePackage(cp);
        Test.stopTest();
        System.assert(cpSaved.Id!=null);
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
    /*
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
    }*/
    
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
         System.debug('LoggedIn user name is = ' + loggedInUserRole.UserRole.Name);
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
    
    @isTest static void testGetCandidateQuestionsCount() {
          TestDataFactory.createLOIRecords(1);
          Integer questionCount = TestDataFactoryCPWizard.getQuestionsByTrack();
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Candidate_Questionnaire__c> questionlist = TQBCPWizardController.getCandidateQuestions(cp.Id);
          Integer questionCountRetrieved = TQBCPWizardController.getCandidateQuestionsCount(cp.Id);
         Test.stopTest();   
         System.assertEquals(questionCountRetrieved,questionCount);
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
          TQB_Ad_Hoc_Entry__c adhocEntry = TQBCPWizardController.saveAdHocEntry(cp.Id, adhocList[0], 'insert');
         Test.stopTest();
         System.assert(adhocEntry.Id!=null);
    }
    
    @isTest static void testdeleteAdHoc() { 
        TestDataFactory.createLOIRecords(1);
         Test.startTest();  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
          List<TQB_Ad_Hoc_Entry__c> adhocList = TestDataFactoryCPWizard.createCPAdhocs(1,cp.Id);
          TQB_Ad_Hoc_Entry__c adhocEntrySaved = TQBCPWizardController.saveAdHocEntry(cp.Id, adhocList[0], 'insert');
          TQB_Ad_Hoc_Entry__c adhocEntryDeleted = TQBCPWizardController.deleteAdHoc(adhocList[0]);
         Test.stopTest();
         System.debug('saved Entry = ' + adhocEntrySaved.Id);
         System.debug('deleted Entry = ' + adhocEntryDeleted.Id);
         System.assertEquals(adhocEntrySaved.Id, adhocEntryDeleted.Id);
    }
    
    @isTest static void testGetCandidateAdHocEntries() { 
         Test.startTest();  
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<TQB_Ad_Hoc_Entry__c> adhocList = TestDataFactoryCPWizard.createCPAdhocs(1,candpkgId);
          TQB_Ad_Hoc_Entry__c adhocEntrySaved = TQBCPWizardController.saveAdHocEntry(candpkgId, adhocList[0], 'insert');
          List<TQB_Ad_Hoc_Entry__c> getAdhocList = TQBCPWizardController.getCandidateAdHocEntries(candpkgId);
         Test.stopTest();
        System.assertEquals(adhocList.size(), getAdhocList.size());
    }  
    
     @isTest static void testSaveAdHocCommentServerFirstLine() { 
          
         String testValue = 'hello';
         Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<TQB_Comment__c> comment = TestDataFactoryCPWizard.createCPAdhocComments(1, candpkgId);
          TQBCPWizardController.saveAdHocCommentServer(testValue,'firstLineSupComment', candpkgId);
          String commentValue = TQBCPWizardController.populateAdHocCommentsServer(candpkgId,'firstLineSupComment');
         Test.stopTest();
         System.debug('commentvalue = '+ commentValue);
         System.assertEquals(testValue, commentValue);
     }
    
    @isTest static void testSaveAdHocCommentServerSecondLine() { 
          
         String testValue = 'hello';
         Test.startTest();  
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<TQB_Comment__c> comment = TestDataFactoryCPWizard.createCPAdhocComments(1, candpkgId);
          TQBCPWizardController.saveAdHocCommentServer(testValue,'secondLineSupComment', candpkgId);
          String commentValue = TQBCPWizardController.populateAdHocCommentsServer(candpkgId,'secondLineSupComment');
         Test.stopTest();
         System.debug('commentvalue = '+ commentValue);
         System.assertEquals(testValue, commentValue);
     }
    
    @isTest static void testSaveAdHocCommentServerFirstLineElseCase() { 
          
         String testValue = 'hello';
         Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          TQBCPWizardController.saveAdHocCommentServer(testValue,'firstLineSupComment', candpkgId);
          String commentValue = TQBCPWizardController.populateAdHocCommentsServer(candpkgId,'firstLineSupComment');
         Test.stopTest();
         System.debug('commentvalue = '+ commentValue);
         System.assertEquals(testValue, commentValue);
     }
    
    @isTest static void testSaveAdHocCommentServerSecondLineElseCase() { 
          
         String testValue = 'hello';
         Test.startTest();  
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          TQBCPWizardController.saveAdHocCommentServer(testValue,'secondLineSupComment', candpkgId);
          String commentValue = TQBCPWizardController.populateAdHocCommentsServer(candpkgId,'secondLineSupComment');
         Test.stopTest();
         System.debug('commentvalue = '+ commentValue);
         System.assertEquals(testValue, commentValue);
     }
       
    @isTest static void testSaveReviewCommentAndReturn() { 
         String testValue = 'hello';
         Test.startTest();  
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<TQB_Comment__c> commentList = TestDataFactoryCPWizard.createCPComments(1, candpkgId);
          TQBCPWizardController.saveReviewCommentAndReturn(candpkgId, commentList[0]);
          List<TQB_Comment__c> commentListretrieved = TQBCPWizardController.getReviewComments(candpkgId);
         Test.stopTest();
        System.debug('commentList size is ='+commentList);
        System.debug('commentListretrieved size is ='+commentListretrieved.size());
        System.assertEquals(commentList.size(), commentListretrieved.size());
   }
    
   @isTest static void testSaveReviewCommentAndReturnElseCase() { 
         String errorMessage;
         Test.startTest();  
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<TQB_Comment__c> commentList = TestDataFactoryCPWizard.createCPComments(1, candpkgId);
          commentList[0].Comment__c = null;
           try{
              TQBCPWizardController.saveReviewCommentAndReturn(candpkgId, commentList[0]); 
           }
           catch(AuraHandledException e) {
               errorMessage ='Script-thrown exception';
           }
         Test.stopTest();
         System.assert(errorMessage != null);
   }
    
    @isTest static void testSaveReviewCommentAndReject() { 
         String testValue = 'hello';
         Test.startTest();  
              Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
              List<TQB_Comment__c> commentList = TestDataFactoryCPWizard.createCPComments(1, candpkgId);
              TQBCPWizardController.saveReviewCommentAndReject(candpkgId, commentList[0],'rejected');
              List<TQB_Comment__c> commentListretrieved = TQBCPWizardController.getReviewComments(candpkgId);
         Test.stopTest();
        System.debug('commentList size is ='+commentList.size());
        System.debug('commentListretrieved size is ='+ commentListretrieved.size());
        System.assertEquals(commentList.size(), commentListretrieved.size());
   }
    
   @isTest static void testSaveReviewCommentAndRejectException1() { 
       String errorMessage;
         Test.startTest();  
              Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
              List<TQB_Comment__c> commentList = TestDataFactoryCPWizard.createCPComments(1, candpkgId);
               try{
                   TQBCPWizardController.saveReviewCommentAndReject(candpkgId, commentList[0],'');
                   List<TQB_Comment__c> commentListretrieved = TQBCPWizardController.getReviewComments(candpkgId);                   
               }
              catch(AuraHandledException e){
                 System.debug(e);
                 errorMessage = 'Script-thrown exception';
               }
         Test.stopTest();
        System.debug('commentList size is ='+commentList.size());
        System.assert(errorMessage != null);
   }
    
   @isTest static void testSaveReviewCommentAndRejectElseCase() { 
       String errorMessage;
         Test.startTest();  
              Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
              List<TQB_Comment__c> commentList = TestDataFactoryCPWizard.createCPComments(1, candpkgId);
              commentList[0].Comment__c = null;
               try{
                   TQBCPWizardController.saveReviewCommentAndReject(candpkgId, commentList[0],'rejected');
                   List<TQB_Comment__c> commentListretrieved = TQBCPWizardController.getReviewComments(candpkgId);                   
               }
              catch(AuraHandledException e){
                 System.debug(e);
                 errorMessage = 'Script-thrown exception';
               }
         Test.stopTest();
        System.debug('commentList size is ='+commentList.size());
        System.assert(errorMessage != null);
   }
    
    @isTest static void testGetReviewComments() { 
        Test.startTest(); 
           Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
           List<TQB_Comment__c> commentList = TestDataFactoryCPWizard.createCPReviewComments(1, candpkgId);
            TQBCPWizardController.saveReviewCommentAndReject(candpkgId, commentList[0],'rejected');
           List<TQB_Comment__c> commentListretrieved = TQBCPWizardController.getReviewComments(candpkgId);
        Test.stopTest();
        System.assertEquals(commentList.size(), commentListretrieved.size());
    }
    
    @isTest static void testGetCPStatusPickListValues() { 
        Test.startTest(); 
           Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
           List<String> pickListValueStatuses = TQBCPWizardController.getCPStatusPickListValues();
        Test.stopTest();
        System.assertEquals(pickListValueStatuses.size(),9);
    }
    
    @isTest static void testGetStatePickListValues() { 
         TestDataFactory.createLOIRecords(1);
        Test.startTest(); 
           List<String> pickListValuesState = TQBCPWizardController.getStatePickListValues();
        Test.stopTest();
        System.assertEquals(pickListValuesState.size(),52);
    }
    
    @isTest static void testGet1stLineSupCurrentValue() {
         
        Test.startTest(); 
           Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
           Id id =  TQBCPWizardController.get1stLineSupCurrentValue(candpkgId);
        Test.stopTest();
         System.assert(id != null);
    }
    
    @isTest static void testGetCPAttachTypePickListValues() {
         Test.startTest(); 
            Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
            List<String> fileTypeCandidate = TQBCPWizardController.getCPAttachTypePickListValues('candidate');
            List<String> fileTypeReviewer = TQBCPWizardController.getCPAttachTypePickListValues('reviewer');
         Test.stopTest();
        System.assertEquals(fileTypeCandidate.size(), 10);
        System.assertEquals(fileTypeReviewer.size(), 2);
    }
    
     @isTest static void testGetRejectReasonValues() {
          Test.startTest(); 
             Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
            List<String> rejectReasonValues = TQBCPWizardController.getRejectReasonValues();
          Test.stopTest();
         System.assertEquals(rejectReasonValues.size(), 8);
     }
    
    @isTest static void testGetTQBCoordinatorEmailNotification() {
        Test.startTest(); 
           Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
            Boolean result = TQBCPWizardController.getTQBCoordinatorEmailNotification(candpkgId);
        Test.stopTest();
        System.debug('value of email result'+result);
        System.assertEquals(false, result);
    }
        
   @isTest static void testSetTQBPanelMembersList() {
       List<User> panelUsers = TestDataFactory.createPanelUser();
       Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<User> panelMembers = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[0]);
          List<User> panelMembers1 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[1]);
          List<User> panelMembers2 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[2]);
          List<User> panelMembers3 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[3]);
          List<User> panelMembers4 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[4]);
       Test.stopTest();
       System.assertEquals(1, panelMembers.size());
       System.assertEquals(2, panelMembers1.size());
       System.assertEquals(3, panelMembers2.size());
       System.assertEquals(4, panelMembers3.size());
       System.assertEquals(5, panelMembers4.size());
    }
    
   @isTest static void testGetTQBPanelMembersList() {
       List<User> panelUsers = TestDataFactory.createPanelUser();
       Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<User> setPanelMembers = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[0]);
          List<User> setPanelMembers1 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[1]);
          List<User> setPanelMembers2 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[2]);
          List<User> setPanelMembers3 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[3]);
          List<User> setPanelMembers4 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[4]);
          List<User> getPanelMembers = TQBCPWizardController.getTQBPanelMembersList(candpkgId);
       Test.stopTest();
       System.assertEquals(setPanelMembers4.size(), getPanelMembers.size());
    }
    
    
    @isTest static void testDeleteSelectedPanelMember() {
         List<User> panelUsers = TestDataFactory.createPanelUser();
        Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<User> setPanelMembers = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[0]);
          List<User> setPanelMembers1 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[1]);
          List<User> setPanelMembers2 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[2]);
          List<User> setPanelMembers3 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[3]);
          List<User> setPanelMembers4 = TQBCPWizardController.setTQBPanelMembersList(candpkgId, panelUsers[4]);
          Boolean deleteResult = TQBCPWizardController.deleteSelectedPanelMember(candpkgId, panelUsers[0].Id);
          Boolean deleteResult1 = TQBCPWizardController.deleteSelectedPanelMember(candpkgId, panelUsers[1].Id);
          Boolean deleteResult2 = TQBCPWizardController.deleteSelectedPanelMember(candpkgId, panelUsers[2].Id);
          Boolean deleteResult3 = TQBCPWizardController.deleteSelectedPanelMember(candpkgId, panelUsers[3].Id);
          Boolean deleteResult4 = TQBCPWizardController.deleteSelectedPanelMember(candpkgId, panelUsers[4].Id);
        Test.stopTest();
         System.assert(deleteResult);
         System.assert(deleteResult1);
         System.assert(deleteResult2);
         System.assert(deleteResult3);
         System.assert(deleteResult4);
    }
    
    @isTest static void testGetTQBChairPersonName() {
       Test.startTest();
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();       
          String chairPersonName = TQBCPWizardController.getTQBChairPersonName(candpkgId);
       Test.stopTest();
        System.debug('value of chair person name' + chairPersonName);
         System.assertEquals(chairPersonName, 'TQB_Chair');
    }
    
    @isTest static void testGetUserFromUserId() {
        User user = TestDataFactory.createUser();
        Test.startTest(); 
          User userRetrieved = TQBCPWizardController.getUserFromUserId(user.Id);
        Test.stopTest();
        System.assertEquals(userRetrieved.Id, user.Id);
    }
    
    @isTest static void testSendNotifyEmailCoordinator() {
        List<User> coordinatorUsers = TestDataFactory.createCoordinatorUser(3);
        String coordinatorEmail = 'EPAORDTQBTeam@cgifederal.com';
        Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          String message = TQBCPWizardController.sendNotifyEmailCoordinator(candpkgId, coordinatorUsers, coordinatorEmail);
        Test.stopTest();
        System.debug('Message for sending email is = ' + message);
        System.assertEquals(message, 'Email to Coordinator Sent Successfully');
    }
         
    @isTest static void testGetCandidateQuestionForPagination() {
       TestDataFactory.createLOIRecords(1);  
      Test.startTest();
         TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
         TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);  
         List<TQB_Candidate_Questionnaire__c> questions = TQBCPWizardController.getCandidateQuestions(cp.Id);
         List<TQB_Comment__c> questionCommentfirstLine = TestDataFactoryCPWizard.createCPQuestionfirstLineComments(1, questions[0].Id, cp.Id);
         List<TQB_Comment__c> questionCommentSecondLine = TestDataFactoryCPWizard.createCPQuestionSecondLineComments(1, questions[0].Id, cp.Id);
         QuestionWrapper questionwrapper =  TQBCPWizardController.getCandidateQuestionForPagination(cp, cp.Id, false, true, 1);     
      Test.stopTest();   
         System.assert(questionwrapper.packageId != null ); 
         System.assert(questionwrapper.questionNumber != null); 
         System.assert(questionwrapper.total != null); 
    }
    
    @isTest static void testGetQuestionnaire() {
        
        Test.startTest();
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<TQB_Candidate_Questionnaire__c> questions = TQBCPWizardController.getCandidateQuestions(candpkgId);
          List<TQB_Candidate_Questionnaire__c> questionsList = TQBCPWizardController.getQuestionnaire(candpkgId);
        Test.stopTest();
         System.assertEquals(questions.size(), questionsList.size());
    }
    
    @isTest static void testSendNotifyEmail() {
        List<User> chairUsers = TestDataFactory.createTQBChairUser();
        List<User> panelUsers = TestDataFactory.createTQBPanelUser();
        Test.startTest();
           Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
           String chairMessage = TQBCPWizardController.sendNotifyEmail(candpkgId, chairUsers[0].Id, 'chair');
           String panelMessage = TQBCPWizardController.sendNotifyEmail(candpkgId, panelUsers[0].Id, 'panel');
        Test.stopTest();
         System.debug('Message from email = ' + chairMessage );
         System.debug('Message from email = ' + panelMessage );
        System.assertEquals(chairMessage, 'Email to Chair_Testing Sent Successfully');
        System.assertEquals(panelMessage, 'Email to Panel_Testing Sent Successfully');
    }
        
    
    @isTest static void testSendNotifyEmailToAdhocMembers() {
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
        List<TQB_Ad_Hoc_Entry__c> adhocUsers = TestDataFactoryCPWizard.createCPAdhocEntries(3, candpkgId);
        List<Id> adhocUserIds = new List<Id>();
        for(TQB_Ad_Hoc_Entry__c adhoc : adhocUsers) {
            adhocUserIds.add(adhoc.Id);
        }
        Test.startTest();        
          String message = TQBCPWizardController.sendNotifyEmailToAdhocMembers(candpkgId, adhocUserIds);
        Test.stopTest();
        System.debug('message for sendnotifyemail' + message);
        System.assertEquals(message, 'Email to John,smith John,smith Sent Successfully');
    }
    
    /*
    @isTest static void testMarkAdhocReferenceSelected() {
        Boolean valueSelected = true;
         User CandidateUser = TestDataFactory.createCandidateUserTest();
        System.runAs(CandidateUser) {
                Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
                List<TQB_Ad_Hoc_Entry__c> adhocUsers = TestDataFactoryCPWizard.createCPAdhocEntries(1, candpkgId);
                System.debug('Name of the adhoc user =' + adhocUsers[0].Name);
                Test.startTest();        
                  Boolean valueRetrieved = TQBCPWizardController.markAdhocReferenceSelected(candpkgId, adhocUsers[0].Name, valueSelected);
                Test.stopTest();
                System.assertEquals(valueRetrieved, valueSelected);
        }
    }*/
    
    
    
    @isTest static void testGetSelectedAdHocEntry() {
       TestDataFactory.createLOIRecords(1);  
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);    
          cp.TQB_Adhoc_Entry_Name__c = 'Id1';
          cp.TQB_Adhoc_Entry_Name_2__c = 'Id2';
          upsert cp;
        Test.startTest();
          String adhocEntryIds = TQBCPWizardController.getSelectedAdHocEntry(cp.Id);
        Test.stopTest();
        System.debug('value of adhoc entries' + adhocEntryIds);
        System.assertEquals(adhocEntryIds, 'Id1;Id2');
    }
    
    @isTest static void testPopulateAdHocCommentsServer() {
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
        TestDataFactoryCPWizard.createCPAdhocComments(1, candpkgId);
        Test.startTest();
            String firstlineComment = TQBCPWizardController.populateAdHocCommentsServer(candpkgId, 'firstLineSupComment');
            String secondlineComment = TQBCPWizardController.populateAdHocCommentsServer(candpkgId, 'secondLineSupComment');
        Test.stopTest();
        System.assertEquals(firstlineComment, 'first line commented');
        System.assertEquals(secondlineComment, 'second line commented');
    }
    
    @isTest static void testValidateAdHocMinMax() {
      String errorMessage;
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
      List<TQB_Ad_Hoc_Entry__c> adhocEntries = TestDataFactoryCPWizard.createCPAdhocEntries(3, candpkgId);
      System.debug('size of adhocEntries =' + adhocEntries.size());
      Test.startTest();
        try{
            TQBCPWizardController.validateAdHocMinMax(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug('Exception generated');
            errorMessage ='Script-thrown exception';
        }
      Test.stopTest(); 
        System.assert(errorMessage == null);
    }
    
    @isTest static void testValidateAdHocMinMaxException() {
      String errorMessage;
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
      List<TQB_Ad_Hoc_Entry__c> adhocEntries = TestDataFactoryCPWizard.createCPAdhocEntries(10, candpkgId);
      Test.startTest();
        try{
            TQBCPWizardController.validateAdHocMinMax(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug('Exception generated');
            errorMessage ='Script-thrown exception';
        }
      Test.stopTest(); 
        System.assertEquals(errorMessage, 'Script-thrown exception');
    }
    
    @isTest static void testValidateAdHocMax() {
      String errorMessage;
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
      List<TQB_Ad_Hoc_Entry__c> adhocEntries = TestDataFactoryCPWizard.createCPAdhocEntries(4, candpkgId);
      System.debug('size of adhocEntries =' + adhocEntries.size());
      Test.startTest();
        try{
            TQBCPWizardController.validateAdHocMax(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug('Exception generated');
            errorMessage ='Script-thrown exception';
        }
      Test.stopTest(); 
        System.assert(errorMessage == null);
    }
    
    @isTest static void testValidateAdHocMaxException() {
      String errorMessage;
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
      List<TQB_Ad_Hoc_Entry__c> adhocEntries = TestDataFactoryCPWizard.createCPAdhocEntries(10, candpkgId);
      System.debug('size of adhocEntries =' + adhocEntries.size());
      Test.startTest();
        try{
            TQBCPWizardController.validateAdHocMax(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug('Exception generated');
            errorMessage ='Script-thrown exception';
        }
      Test.stopTest(); 
       System.assertEquals(errorMessage, 'Script-thrown exception');
    }
        
    @isTest static void testSaveTheFile() {
      String fileName='test.txt', base64Data= 'testing purpose', contentType='Position Description';
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
       Test.startTest();
         Id attachmentId = TQBCPWizardController.saveTheFile(candpkgId, fileName, base64Data, contentType);
       Test.stopTest(); 
         System.debug('attachmentId generated =' + attachmentId);
         System.assert(attachmentId != null);
     }
    
      
    @isTest static void testSaveTheFileFailCase() {
      
      String fileName='', base64Data= 'testing purpose', contentType='Position Description', errorMessage;
      Id attachmentId;
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
       Test.startTest();
        try{
           attachmentId  = TQBCPWizardController.saveTheFile(candpkgId, fileName, base64Data, contentType);
        }
        catch(DMLException e) {
            System.debug(e.getMessage());
            errorMessage = e.getMessage();
        } 
       Test.stopTest(); 
         System.debug('attachmentId generated =' + attachmentId);
         System.assert(attachmentId == null);
         //System.assert(attachmentId != null);
     }
    
    @isTest static void testSaveTheChunk() {
     
       Test.startTest();
         Id attachmentId =  TQBCPWizardControllerTest.createAttachmentData();
       Test.stopTest(); 
         System.debug('attachmentId generated =' + attachmentId);
         System.assert(attachmentId != null);
     }
    
    @isTest static void testSaveTheChunkAppend() {
        String fileName='test.txt', base64Data= 'testing purpose', base64DataNew= 'testing purpose already', contentType='Position Description', fileId='';
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          Test.startTest();
              Id attachmentId = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId);
              Id attachmentIdAppend = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, attachmentId);               
          Test.stopTest(); 
         System.assert(attachmentIdAppend != null);
    }
        
    @isTest static void testGetCPAttachmentById() { 
       String fileName='test.txt', base64Data= 'testing purpose', contentType='Position Description', fileId='';
       Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
       Test.startTest();
         Id attachmentId = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId);
         Attachment attachment = TQBCPWizardController.getCPAttachmentById(attachmentId);
       Test.stopTest(); 
        System.assertEquals(attachment.Name, fileName);
    }
    
    @isTest static void testDeleteCPAttachment() { 
       Test.startTest();
         Id attachmentId = TQBCPWizardControllerTest.createAttachmentData();
        Boolean result = TQBCPWizardController.deleteCPAttachment(attachmentId);
        Test.stopTest(); 
        System.assert(result);
    }
    
    @isTest static void testGetCPAttachmentsServerReviewer() { 
      String fileName='test.txt', base64Data= 'testing purpose', contentType='Position Description', fileId='';
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
      TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId);
        Test.startTest();
          List<Attachment> attachments = TQBCPWizardController.getCPAttachmentsServer(candpkgId, 'reviewer');
        Test.stopTest();
      System.assertEquals(attachments.size(), 1);
    }
    
    @isTest static void testGetCPAttachmentsServerCandidate() { 
      String fileName='test.txt', base64Data= 'testing purpose', contentType='Presentation', fileId='';
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
      TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId);
        Test.startTest();
          List<Attachment> attachments = TQBCPWizardController.getCPAttachmentsServer(candpkgId, 'candidate');
        Test.stopTest();
      System.assertEquals(attachments.size(), 1);
    }
    
    @isTest static void testGetCPAttachmentsServerSupervisor() { 
      String fileName='test.txt', base64Data= 'testing purpose', contentType='Position Description', fileId='';
      Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
      TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId);
        Test.startTest();
          List<Attachment> attachments = TQBCPWizardController.getCPAttachmentsServer(candpkgId, 'supervisor');
        Test.stopTest();
      System.assertEquals(attachments.size(), 1);
    }
    
     @isTest static void testSaveAttachCommentServer() { 
        String commentValue = 'testing', Comment_Type = 'firstLineSupComment';
        String fileName='test.txt', base64Data= 'testing purpose', contentType='Position Description', fileId='';
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
        Id attachmentId = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId);
         Test.startTest();
            TQBCPWizardController.saveAttachCommentServer(commentValue, Comment_Type, candpkgId, attachmentId);
            String commentValueRetrieved = TQBCPWizardController.populateAttachCommentsServer(candpkgId, Comment_Type, attachmentId);
         Test.stopTest();
         System.assertEquals(commentValueRetrieved, commentValue);
     }
    
    @isTest static void testSaveAttachCommentServerIfCase() { 
        String commentValue = 'testing', Comment_Type = 'firstLineSupComment';
        String fileName='test.txt', base64Data= 'testing purpose', contentType='Position Description', fileId='';
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
        Id attachmentId = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId);
        List<TQB_Comment__c> comment = TestDataFactoryCPWizard.createCPAttachComments(1, attachmentId, candpkgId);
         Test.startTest();
            TQBCPWizardController.saveAttachCommentServer(commentValue, Comment_Type, candpkgId, attachmentId);
            String commentValueRetrieved = TQBCPWizardController.populateAttachCommentsServer(candpkgId, Comment_Type, attachmentId);
         Test.stopTest();
         System.assertEquals(commentValueRetrieved, commentValue);
     }
    
    @isTest static void testValidateCandidateAttachments() { 
        String fileName='test.txt',fileName1='test1.txt',fileName2='test2.txt', fileName3='test3.txt', base64Data= 'testing purpose', contentType='Curriculum Vitae', contentType1='Work Product', fileId='';        
        String errorMessage;
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName1, base64Data, contentType1, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName2, base64Data, contentType1, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName3, base64Data, contentType1, fileId);
        Test.startTest();
        try{
            TQBCPWizardController.validateCandidateAttachments(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug(e);
            errorMessage = 'Script-thrown exception';
        }
        Test.stopTest();
        System.debug('Error Message is =' + errorMessage);
        System.assertNotEquals(errorMessage, 'Script-thrown exception');
    }
    
    @isTest static void testValidateCandidateAttachmentsExceptionWorkProduct() { 
        String fileName='test.txt',fileName1='test1.txt',fileName2='test2.txt', fileName3='test3.txt', base64Data= 'testing purpose', contentType='Curriculum Vitae', contentType1='Work Product', fileId='';        
        String errorMessage;
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName1, base64Data, contentType1, fileId); 
        Test.startTest();
        try{
            TQBCPWizardController.validateCandidateAttachments(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug(e);
            errorMessage = 'Script-thrown exception';
        }
        Test.stopTest();
        System.debug('Error Message is =' + errorMessage);
        System.assertEquals(errorMessage, 'Script-thrown exception');
    }
    
    @isTest static void testSaveReviewCommentAndApprove() {
       List<User> firstLineUser = TestDataFactory.create1stLineUser(1); 
       Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
       System.runAs(firstLineUser[0]) {
          TQB_Comment__c commentEntry = new TQB_Comment__c(Comment__c='John commented', TQB_Candidate_Package_ID__c= candpkgId);
          String fileName='test.txt',fileName1='test1.txt', base64Data= 'testing purpose', contentType='Position Description', contentType1='Recommendation Memo', fileId='', errorMessagePD, errorMessageRM;  
          Id attachment1 = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId); 
          Id attachment2 = TQBCPWizardController.saveTheChunk(candpkgId, fileName1, base64Data, contentType1, fileId);
           System.debug('value of 1st attachment is =' + attachment1);
           System.debug('value of 1st attachment is =' + attachment2);
          Test.startTest();
                try{
                    TQBCPWizardController.saveReviewCommentAndApprove(candpkgId, commentEntry , 'TQB 1st Line Supervisor Role');
                }
                catch(Exception e){
                    System.debug('value of exception is' + e);
                    errorMessageRM = 'Script-thrown exception';
                }
         Test.stopTest();
            System.assert(errorMessageRM == null);
           }       
    }
    
    @isTest static void testSaveReviewCommentAndApproveException1() {
       List<User> secondLineUser = TestDataFactory.create2ndLineUser(1); 
       Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
       System.runAs(secondLineUser[0]) {
          TQB_Comment__c commentEntry = new TQB_Comment__c(Comment__c='John commented', TQB_Candidate_Package_ID__c= candpkgId);
          String fileName='test.txt',fileName1='test1.txt', base64Data= 'testing purpose', contentType='Position Description', contentType1='Recommendation Memo', fileId='', errorMessagePD, errorMessageRM;  
          Id attachment1 = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId); 
          Id attachment2 = TQBCPWizardController.saveTheChunk(candpkgId, fileName1, base64Data, contentType1, fileId);
           System.debug('value of 1st attachment is =' + attachment1);
           System.debug('value of 1st attachment is =' + attachment2);
          Test.startTest();
                try{
                    TQBCPWizardController.saveReviewCommentAndApprove(candpkgId, commentEntry , 'TQB 2nd Line Supervisor Role');
                }
                catch(Exception e){
                    System.debug('value of exception is' + e);
                    errorMessageRM = 'Script-thrown exception';
                }
         Test.stopTest();
            System.assert(errorMessageRM == null);
           }       
    }
    
    @isTest static void testSaveReviewCommentAndApproveException2() {
       List<User> firstLineUser = TestDataFactory.create1stLineUser(1); 
       Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
       System.runAs(firstLineUser[0]) {
          TQB_Comment__c commentEntry = new TQB_Comment__c(Comment__c='John commented', TQB_Candidate_Package_ID__c= candpkgId);
          String fileName='test.txt',fileName1='test1.txt', base64Data= 'testing purpose', contentType='Position Description', contentType1='Recommendation Memo', fileId='', errorMessagePD, errorMessageRM, errorMessageComment;  
          Test.startTest();
                try{
                    TQBCPWizardController.saveReviewCommentAndApprove(candpkgId, commentEntry , 'TQB 1st Line Supervisor Role');
                }
                catch(AuraHandledException e){
                    System.debug(e);
                    errorMessagePD = 'Script-thrown exception';
                }
                try{
                    Id attachment1 = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId); 
                    TQBCPWizardController.saveReviewCommentAndApprove(candpkgId, commentEntry , 'TQB 1st Line Supervisor Role');
                }
                catch(AuraHandledException e){
                    System.debug('value of exception is' + e);
                    errorMessageRM = 'Script-thrown exception';
                }
                try{
                    TQB_Comment__c commentEntry1 = new TQB_Comment__c();
                    Id attachment1 = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId);
                    Id attachment2 = TQBCPWizardController.saveTheChunk(candpkgId, fileName1, base64Data, contentType1, fileId);
                    TQBCPWizardController.saveReviewCommentAndApprove(candpkgId, commentEntry1 , 'TQB 1st Line Supervisor Role');
                }
                catch(AuraHandledException e){
                    System.debug('value of exception is' + e);
                    errorMessageComment = 'Script-thrown exception';
                }
         Test.stopTest();
            System.assert(errorMessagePD != null);
            System.assert(errorMessageRM != null);
            System.assert(errorMessageComment != null);
           }       
    }
    
    @isTest static void testValidateCandidateAttachmentsExceptionCurriculum() { 
        String fileName='test.txt',fileName1='test1.txt',fileName2='test2.txt', fileName3='test3.txt', base64Data= 'testing purpose', contentType='Curriculum Vitae', contentType1='Work Product', fileId='';        
        String errorMessage;
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          TQBCPWizardController.saveTheChunk(candpkgId, fileName1, base64Data, contentType1, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName2, base64Data, contentType1, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName3, base64Data, contentType1, fileId);
        Test.startTest();
        try{
            TQBCPWizardController.validateCandidateAttachments(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug(e);
            errorMessage = 'Script-thrown exception';
        }
        Test.stopTest();
        System.debug('Error Message is =' + errorMessage);
        System.assertEquals(errorMessage, 'Script-thrown exception');
    }
    
    @isTest static void testValidateCandidateQuestionnaire() {
        String errorMessage;
        Test.startTest();
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<TQB_Candidate_Questionnaire__c> questions = TQBCPWizardController.getCandidateQuestions(candpkgId);
        try{
            TQBCPWizardController.validateCandidateQuestionnaire(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug(e);
            errorMessage='Script-thrown exception';
        }
        Test.stopTest();
        System.assertEquals(errorMessage, 'Script-thrown exception');
    }
    
    @isTest static void testGetTQBChairPersonList() { 
        User chairUser = TestDataFactory.createChairUserTest();
        System.runAs(chairUser) {        
           Test.startTest();
             List<User> chairUsers = TQBCPWizardController.getTQBChairPersonList();
           Test.stopTest();
           System.debug('value of chairUsers obtained'+ chairUsers.size());
           System.assert(chairUsers.size() != 0);
        }
    }
    
    
    @isTest static void testGetOrCreateCandidatePackage() {
        List<User> firstLineUser = TestDataFactory.create1stLineUser(1);
        TestDataFactory.createLOIRecords(1);
        TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        Test.startTest();
        System.runAs(firstLineUser[0]) {
                TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id); 
                System.debug(cp.Id);
                System.assert(cp.Id != null);
            } 
        Test.stopTest();
    }
       
    /*    
     @isTest static void testSubmitCandidatePackage() {
        String errorMessageQuestionnaire, errorMessageAttachments, errorMessageAdhocMinMax;
        Test.startTest();
         try{
            TQBCPWizardControllerTest.testValidateCandidateQuestionnaire();
            TQBCPWizardControllerTest.testValidateCandidateAttachments();
            TQBCPWizardControllerTest.testValidateAdHocMinMax();
        }
        catch(AuraHandledException e){
            System.debug(e);
            errorMessageQuestionnaire='Script-thrown exception';
        }
         try{
            TQBCPWizardControllerTest.testValidateCandidateAttachments();
        }
        catch(AuraHandledException e){
            System.debug(e);
            errorMessageAttachments='Script-thrown exception';
        }
         try{
            TQBCPWizardControllerTest.testValidateAdHocMinMax();
        }
        catch(AuraHandledException e){
            System.debug(e);
            errorMessageAdhocMinMax='Script-thrown exception';
        }
        Test.stopTest();
        System.assertEquals(errorMessageQuestionnaire, 'Script-thrown exception');
        System.assertNotEquals(errorMessageAttachments, 'Script-thrown exception');
        System.assertNotEquals(errorMessageAdhocMinMax, 'Script-thrown exception');
     }*/
    
       
    public static Id createAttachmentData(){
        String fileName='test.txt', base64Data= 'testing purpose', contentType='Position Description', fileId='';
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
        Id attachmentId = TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId); 
        return attachmentId;
    }
                 
    public static Id createCandidatePackage() {
        
        TestDataFactory.createLOIRecords(1);
        TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
        TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);        
        cp.TQB_Chair_Person_Name__c = 'TQB_Chair';
        upsert cp;
       return cp.Id;         
    }
        
    
}