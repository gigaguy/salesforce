public class TQBLookUpController {
   @AuraEnabled
 public static List < User > fetchUser(String searchKeyWord) {
  String searchKey = searchKeyWord + '%';
  List < User > returnList = new List < User > ();
  List < User > lstOfUsers = [select Name,Title,Phone,Email from User where UserRole.Name = 'TQB PANEL' and  Name LIKE: searchKey];

  for (User user: lstOfUsers) {
     returnList.add(user);
     }
  return returnList;
 }
}