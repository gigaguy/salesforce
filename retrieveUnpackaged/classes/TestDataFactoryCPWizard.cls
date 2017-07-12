public class TestDataFactoryCPWizard {
    
    public static List<TQB_Candidate_Questionnaire__c> createCPQuestions(Integer count, Id cpId) {
        
     List<TQB_Candidate_Questionnaire__c> questionList = new List<TQB_Candidate_Questionnaire__c>();      
      for(Integer i=0;i<count;i++) {
        TQB_Candidate_Questionnaire__c question = new TQB_Candidate_Questionnaire__c(Question__c='Brief Salesforce',
                                                                               Answer__c='salesforce',
                                                                               Category__c='Impact on Decision-Making',
                                                                               TQB_Candidate_Package__c= cpId,
                                                                               Track__c='Research');
        
        questionList.add(question);
      }
        return questionList;
    }
    
    public static Integer getQuestionsByTrack() {
        
        List<TQB_Candidate_Questions__mdt> questionList = new List<TQB_Candidate_Questions__mdt>();
        questionList = [Select Track__c, Category__c, Question__c from TQB_Candidate_Questions__mdt where Track__c = 'Research'];
        return questionList.size();
    }
    
    public static List<TQB_Ad_Hoc_Entry__c> createCPAdhocs(Integer count, Id cpId) {
        
      List<TQB_Ad_Hoc_Entry__c> adhocList = new List<TQB_Ad_Hoc_Entry__c>();
        for(Integer i=0;i<count;i++) {
          TQB_Ad_Hoc_Entry__c adhocEntry = new TQB_Ad_Hoc_Entry__c(First_Name__c='John',
                                                                                   Last_Name__c='John',
                                                                                   Mailing_Address__c='538 Cajundome',
                                                                                   Phone__c='1234567890',
                                                                                   Postal_Code__c='50709',
                                                                                   Research_Area__c='Testing',
                                                                                   City__c='Lafayette',
                                                                                   State__c='LA',
                                                                                   Email__c='nnn@gmail.com',
                                                                                   TQB_Candidate_Package__c= cpId);       
          adhocList.add(adhocEntry);
        }
     return adhocList;
    }
    
    public static List<TQB_Comment__c> createCPComments(Integer count, Id cpId) {

       List<TQB_Comment__c> commentList = new List<TQB_Comment__c>();
       for(Integer i=0;i<count;i++) {
          TQB_Comment__c commentEntry = new TQB_Comment__c(Comment__c='John commented',
                                                           TQB_Candidate_Package_ID__c= cpId);       
          commentList.add(commentEntry);
        }
      return commentList;  
    }
    
    public static List<TQB_Comment__c> createCPAdhocComments(Integer count, Id cpId) {

       List<TQB_Comment__c> commentList = new List<TQB_Comment__c>();
       for(Integer i=0;i<count;i++) {
          TQB_Comment__c commentAdhocEntry = new TQB_Comment__c(Comment__c='John commented', First_Line_Sup_Ad_Hoc_Comment__c='first line commented', Second_Line_Sup_Ad_Hoc_Comment__c='second line commented',
                                                           Comment_Type__c = 'adhoc',TQB_Candidate_Package_ID__c= cpId);       
          commentList.add(commentAdhocEntry);
        }
        insert commentList;
      return commentList;  
    }
    
    public static List<TQB_Comment__c> createCPReviewComments(Integer count, Id cpId) {

       List<TQB_Comment__c> commentList = new List<TQB_Comment__c>();
       for(Integer i=0;i<count;i++) {
          TQB_Comment__c commentEntry = new TQB_Comment__c(Comment__c='John commented',
                                                           TQB_Candidate_Package_ID__c= cpId,
                                                           Comment_Type__c = 'Review');       
          commentList.add(commentEntry);
        }
      return commentList;  
    }
    
    public static List<TQB_Ad_Hoc_Entry__c> createCPAdhocEntries(Integer count, Id cpId) {
        List<TQB_Ad_Hoc_Entry__c> adhocList = new List<TQB_Ad_Hoc_Entry__c>();
        for(Integer i=0;i<count;i++) {
          TQB_Ad_Hoc_Entry__c adhocEntry = new TQB_Ad_Hoc_Entry__c(First_Name__c='John', Last_Name__c ='smith', Mailing_Address__c='235 Johnston Street', City__c='Lafayette', State__c='LA',
                                                                   Postal_Code__c='508217',Phone__c='123-456-7845',Email__c='epaorgtech@cgi.com',TQB_Candidate_Package__c= cpId, Selected__c=true);       
          adhocList.add(adhocEntry);
        }
        insert adhocList;
        return adhocList;
    }
}