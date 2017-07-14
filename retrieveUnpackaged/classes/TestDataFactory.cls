public class TestDataFactory {
    
    public static List<TQB_Letter_of_Intent__c> createLOIRecords(Integer LOICount) {
                
        List<TQB_Letter_of_Intent__c> LOIList = new List<TQB_Letter_of_Intent__c>();
        
            for(Integer i=0;i<LOICount;i++) {
                TQB_Letter_of_Intent__c LOI = new TQB_Letter_of_Intent__c(Current_Lab_Work_Location_Assignment__c='Office of Science Policy',
                                                                               Current_GS_Level__c='GS 13',
                                                                               CurrentRegion__c='Region 1',
                                                                               IntendedTrack__c='Research',
                                                                               Status__c='Submitted',
                                                                               Candidates_1st_Line_Supervisor_Name__c= '005r0000001EozMAAS',
                                                                               Candidates_2nd_Line_Supervisor_Name__c= '005r0000001EozCAAS');
                
                LOIList.add(LOI);
            }
        insert LOIList;
        return LOIList;
    }
    
    public static List<TQB_Candidate_Package__c> createCPRecords(Integer CPCount) {
                
        List<TQB_Candidate_Package__c> CPList = new List<TQB_Candidate_Package__c>();
        
            for(Integer i=0; i< CPCount; i++) {
                 TQB_Candidate_Package__c  CP = new TQB_Candidate_Package__c(Status__c= 'Not Started',Candidates_1st_Line_Supervisor_Name__c= '005r0000001EozMAAS', File_Type__c='Work Product');
                CPList.add(CP);
            }
        insert CPList;
        return CPList;
    }
    
    public static List<TQB_Policies_and_Procedures__c> createPoliciesNProceduresRecords(Integer PPCount) {
                
        List<TQB_Policies_and_Procedures__c> PPList = new List<TQB_Policies_and_Procedures__c>();
        
            for(Integer i=0; i< PPCount; i++) {
                 TQB_Policies_and_Procedures__c  PP = new TQB_Policies_and_Procedures__c(Link__c= 'www.google.com', Link_Title__c= 'Google' + i);
                PPList.add(PP);
            }
        insert PPList;
        return PPList;
    }
    
    public static List<TQB_Bulletin_Board__c> createBulletinBoardRecords(Integer BBCount) {
                
        List<TQB_Bulletin_Board__c> BBList = new List<TQB_Bulletin_Board__c>();
        
            for(Integer i=0; i< BBCount; i++) {
                 TQB_Bulletin_Board__c  BB = new TQB_Bulletin_Board__c(BulletinBoardPostText__c= 'www.google.com', PostDate__c= System.today());
                BBList.add(BB);
            }
        insert BBList;
        return BBList;
    }
    
    public static User createUser() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='TQB Candidate User Profile']; 
        User user = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1707@testorg.com');
                                                   
        insert user;
        return user;
    }
    
    public static List<User> createPanelUser() {
       Integer panelCount = 5;
       List<User> panelUser = new List<User>();
       
        for(Integer i=0; i< panelCount; i++) {     
            User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'TQB Panel Profile'].Id,
             LastName = 'last'+ System.currentTimeMillis(),
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
           );
           panelUser.add(u);
        }
       insert panelUser;
       return panelUser;
    }
    
    public static List<User> createCoordinatorUser(Integer panelCount) {
       List<User> coordinatorUser = new List<User>();
       
        for(Integer i=0; i< panelCount; i++) {     
            User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'TQB Coordinator Profile'].Id,
             LastName = 'last'+ System.currentTimeMillis(),
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
           );
           coordinatorUser.add(u);
        }
       insert coordinatorUser;
       return coordinatorUser;
    }
    
    public static List<User> create1stLineUser(Integer firstLineCount) {
        List<User> firstLineUser = new List<User>();
       
        for(Integer i=0; i< firstLineCount; i++) {     
            User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'TQB 1st Line Supervisor Profile'].Id,
             LastName = 'last'+ System.currentTimeMillis(),
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
           );
           firstLineUser.add(u);
        }
       insert firstLineUser;
       return firstLineUser;        
    }
    
    public static List<User> create2ndLineUser(Integer secondLineCount) {
        List<User> secondLineUser = new List<User>();
       
        for(Integer i=0; i< secondLineCount; i++) {     
            User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'TQB 2nd Line Supervisor Platform'].Id,
             LastName = 'last'+ System.currentTimeMillis(),
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
           );
           secondLineUser.add(u);
        }
       insert secondLineUser;
       return secondLineUser;        
    }
    
     public static User create2ndLineUserTest() {
      
        List<User> users = [Select Id, Name from User where Name='2nd Line Supervisor C122LS'];
         return users[0];
     }
    
    public static User createChairUserTest() {
      
        List<User> users = [Select Id, Name from User where Name='TQB Chair'];
         return users[0];
     }
    
     public static User createCoordinatorUserTest() {
      
        List<User> users = [Select Id, Name from User where Name='TQB Coordinator'];
         return users[0];
     }
    
    public static User createAnotherUser() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User user = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser17071@testorg.com');
                                                   
        insert user;
        return user;
    }
    
    public static List<User> createTQBChairUser() {
        List<User> userList = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='TQB Chair Profile']; 
        User user = new User(Alias = 'standt', Email='TQBChair@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Chair_Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='tqbchairuser1707@testorg.com');
        userList.add(user);                             
        insert userList;
        return userList;
    } 
    
    public static List<User> createTQBPanelUser() {
        List<User> userList = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='TQB Panel Profile']; 
        User user = new User(Alias = 'standt', Email='TQBChair@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Panel_Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='tqbpaneluser1707@testorg.com');
        userList.add(user);                             
        insert userList;
        return userList;
    }

}