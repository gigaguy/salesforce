//Developer :Naveen Sadhu
//Test cases for TQBCPWizardController apex server controller

@isTest
public class TQBCPWizardControllerTest {
    
    @isTest static void testGetCandidatePackage() {
        TestDataFactory.createLOIRecords(1);
        Test.startTest();               
          TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
          TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);
        Test.stopTest();
        System.assert(cp.Id!=null);
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
    
     @isTest static void testSaveAdHocCommentServer() { 
          
         String testValue = 'hello';
         Test.startTest();  
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          TQBCPWizardController.saveAdHocCommentServer(testValue,'firstLineSupComment', candpkgId);
          String commentValue = TQBCPWizardController.populateAdHocCommentsServer(candpkgId,'firstLineSupComment');
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
    /*
    @isTest static void testGetTQBChairPersonList() {
        Test.startTest();
          List<User> tqbChairUsersCreated = TestDataFactory.createTQBChairUser();
          List<User> tqbChairUsers = TQBCPWizardController.getTQBChairPersonList();
        Test.stopTest();
        System.debug('tqbChairUsersCreated Created'+ tqbChairUsersCreated.size());
        System.debug('tqbChairUsers Created'+ tqbChairUsers.size());
        System.assertEquals(tqbChairUsersCreated.size(), tqbChairUsers.size());
    }*/
    
    @isTest static void testGetTQBCoordinatorEmailNotification() {
        Test.startTest(); 
           Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
            Boolean result = TQBCPWizardController.getTQBCoordinatorEmailNotification(candpkgId);
        Test.stopTest();
        System.debug('value of email result'+result);
        System.assertEquals(false, result);
    }
        
   @isTest static void testSetTQBPanelMembersList() {
       User user = TestDataFactory.createUser();
       Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<User> panelMembers = TQBCPWizardController.setTQBPanelMembersList(candpkgId, user);
       Test.stopTest();
       System.assertEquals(1, panelMembers.size());
    }
    
   @isTest static void testGetTQBPanelMembersList() {
       User user = TestDataFactory.createUser();
       Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<User> setPanelMembers = TQBCPWizardController.setTQBPanelMembersList(candpkgId, user);
          List<User> getPanelMembers = TQBCPWizardController.getTQBPanelMembersList(candpkgId);
       Test.stopTest();
       System.assertEquals(setPanelMembers.size(), getPanelMembers.size());
    }
    
    
    @isTest static void testDeleteSelectedPanelMember() {
        User user = TestDataFactory.createUser();
        Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          List<User> setPanelMembers = TQBCPWizardController.setTQBPanelMembersList(candpkgId, user);
          List<User> getPanelMembers = TQBCPWizardController.getTQBPanelMembersList(candpkgId);
          Boolean deleteResult = TQBCPWizardController.deleteSelectedPanelMember(candpkgId, user.Id);
        Test.stopTest();
        System.assert(deleteResult);
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
        User user = TestDataFactory.createUser();
        User user1 = TestDataFactory.createAnotherUser();
        List<User> users = new List<User>();
        users.add(user);
        users.add(user1);
        String coordinatorEmail = 'naveen.sadhu@cgi.com';
        Test.startTest(); 
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          String message = TQBCPWizardController.sendNotifyEmailCoordinator(candpkgId, users, coordinatorEmail);
        Test.stopTest();
        System.debug('Message for sending email is = ' + message);
        System.assertEquals(message, 'Email to Coordinator Sent Successfully');
    }
    
    /*
    @isTest static void testGetCPbyCandidateName() {
          
       Test.startTest(); 
         Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
         TQB_Candidate_Package__c candPkg = TQBCPWizardController.getCPbyCandidateName(candidateName);
       Test.stopTest();
        System.debug('value of candpackage candidate name' + candPkg.Candidate_Name__c);
    }
    */
    
    @isTest static void testGetCandidateQuestionForPagination() {
       TestDataFactory.createLOIRecords(1);  
      Test.startTest();
         TQB_Candidate_Package__c newCP = TQBCPWizardController.createCandidatePackage();
         TQB_Candidate_Package__c cp = TQBCPWizardController.getOrCreateCandidatePackage(newCP.Id);  
         List<TQB_Candidate_Questionnaire__c> questions = TQBCPWizardController.getCandidateQuestions(cp.Id);
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
        
    /*
    @isTest static void testSendNotifyEmailToAdhocMembers() {
         User user = TestDataFactory.createUser();
         User user1 = TestDataFactory.createAnotherUser();
         List<Id> users = new List<Id>();
         users.add(user.Id);
         users.add(user1.Id);
        Test.startTest();
          Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          String message = TQBCPWizardController.sendNotifyEmailToAdhocMembers(candpkgId, users);
        Test.stopTest();
        System.debug('message for sendnotifyemail' + message);
        //System.assertEquals(message, 'Email to Coordinator Sent Successfully');
    }
    */
    
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
            errorMessage ='exception occured';
        }
      Test.stopTest(); 
        System.assert(errorMessage == null);
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
            errorMessage ='exception occured';
        }
      Test.stopTest(); 
        System.assert(errorMessage == null);
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
    
    @isTest static void testSaveTheChunk() {
     
       Test.startTest();
         Id attachmentId =  TQBCPWizardControllerTest.createAttachmentData();
       Test.stopTest(); 
         System.debug('attachmentId generated =' + attachmentId);
         System.assert(attachmentId != null);
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
    
     @isTest static void testSaveRetrieveAttachCommentServer() { 
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
    
    @isTest static void testValidateCandidateAttachments() { 
        String fileName='test.txt',fileName1='test1.txt',fileName2='test2.txt', fileName3='test3.txt', base64Data= 'testing purpose', contentType='Curriculum Vitae', contentType1='Work Product', fileId='';        
        String errorMessage;
        Id candpkgId  =  TQBCPWizardControllerTest.createCandidatePackage();
          TQBCPWizardController.saveTheChunk(candpkgId, fileName, base64Data, contentType, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName1, base64Data, contentType, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName2, base64Data, contentType, fileId); 
          TQBCPWizardController.saveTheChunk(candpkgId, fileName3, base64Data, contentType1, fileId);
        Test.startTest();
        try{
            TQBCPWizardController.validateCandidateAttachments(candpkgId);
        }
        catch(AuraHandledException e){
            System.debug('Exception occured');
            errorMessage = 'Exception occured';
        }
        Test.stopTest();
        System.assert(errorMessage != null);
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
            System.debug('Exception occured');
            errorMessage='Exception Occured';
        }
        Test.stopTest();
        System.assert(errorMessage == null);
    }
       
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