@isTest(Seealldata=true)
 private class  RevokeLicense_Test{
  static testMethod void testRevokeSuccess(){
    
    List<Id>UserId=new List<Id>();
    Profile p = [SELECT Id FROM Profile WHERE Name='EPA Starter'];
    User UserObj= new User(Alias = 'Test', Email='testuser@epa.gov',
    EmailEncodingKey='UTF-8', LastName='testuser', LanguageLocaleKey='en_US',
    LocaleSidKey='en_US', ProfileId = p.Id,
    TimeZoneSidKey='America/New_York', UserName='testuser@epa.gov');
    
    Insert UserObj;
    RevokeLicense.revoke(UserObj.Id);
    }
    }