public class TestDataFactory {
    
    public static List<TQB_Letter_of_Intent__c> createLOIRecords(Integer LOICount, User candidateUser, User firstLineUser, User secondLineUser) {
        List<TQB_Letter_of_Intent__c> LOIList =  new List<TQB_Letter_of_Intent__c>();
            for(Integer i=0;i<LOICount;i++) {
                TQB_Letter_of_Intent__c LOI = new TQB_Letter_of_Intent__c(Current_Lab_Work_Location_Assignment__c='Office of Science Policy',
                                                                               Current_GS_Level__c='GS 13',
                                                                               CurrentRegion__c='Region 1',
                                                                               IntendedTrack__c='Research',
                                                                               Status__c='Submitted',
                                                                               Candidates_1st_Line_Supervisor_Name__c= firstLineUser.Id,
                                                                               Candidates_2nd_Line_Supervisor_Name__c= secondLineUser.Id);
                
                LOIList.add(LOI);
            }
        insert LOIList;
       return LOIList;
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
            User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'TQB Candidate User Profile'].Id,
             LastName = 'last'+ System.currentTimeMillis(),
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = [Select Id from UserRole where Name='TQB Candidate Role'].Id
           );        
       insert u;
       return u;
    }
    
    public static List<User> createPanelUser() {
       Integer panelCount = 5;
       List<User> panelUser = new List<User>();
       
        for(Integer i=0; i< panelCount; i++) {     
            User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'TQB Panel Profile'].Id,
             LastName = 'last'+ System.currentTimeMillis(),
             FirstName = 'first'+ System.currentTimeMillis(),
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = [Select Id from UserRole where Name='TQB PANEL'].Id
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
             LocaleSidKey = 'en_US',
             UserRoleId = [Select Id from UserRole where Name='TQB COORDINATOR'].Id
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
             LocaleSidKey = 'en_US',
             UserRoleId = [Select Id from UserRole where Name='TQB 1st Line Supervisor Role'].Id
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
             LocaleSidKey = 'en_US',
             UserRoleId = [Select Id from UserRole where Name='TQB 2nd Line Supervisor Role'].Id
           );
           secondLineUser.add(u);
        }
       insert secondLineUser;
       return secondLineUser;        
    }
    
    
    
            
    public static List<User> createTQBChairUser(Integer chairCount) {
        List<User> chairUser = new List<User>();
       
        for(Integer i=0; i< chairCount; i++) {     
            User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'TQB Chair Profile'].Id,
             LastName = 'last'+ System.currentTimeMillis(),
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = [Select Id from UserRole where Name='TQB Chair'].Id
           );
           chairUser.add(u);
        }
       insert chairUser;
       return chairUser;
    }
 
}