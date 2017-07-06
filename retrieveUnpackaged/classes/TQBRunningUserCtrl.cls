public class TQBRunningUserCtrl {
    @AuraEnabled
    public static User getCurrentUser() {
      User user = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
      return user;
  }
}