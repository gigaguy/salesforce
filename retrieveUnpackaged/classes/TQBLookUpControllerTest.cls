//Developer :Naveen Sadhu
//Test cases for TQBLookUpController apex server controller

@isTest
public class TQBLookUpControllerTest  {
    
    @isTest static void testFetchUser() {
        List<User> panelUser = TestDataFactory.createPanelUser();
        List<User> chairUser = TestDataFactory.createTQBChairUser(1);
        List <User> searchedUsers;
         System.runAs(chairUser[0]) {
           Test.startTest(); 
              for(Integer i=0; i< panelUser.size(); i++) {
            	String searchName = panelUser[i].LastName;
            	searchedUsers = TQBLookUpController.fetchUser(searchName);
              }
           Test.stopTest();
           System.assertEquals(searchedUsers.size(), panelUser.size());
         }        
    }

}