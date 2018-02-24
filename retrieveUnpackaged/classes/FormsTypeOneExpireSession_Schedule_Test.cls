@isTest
public class FormsTypeOneExpireSession_Schedule_Test {

    @isTest
    static void testExpireSession_Schedule(){
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
        Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
        
        string datestring = '2016-11-22 16:47:07';
        User u = new User(Session_Timestamp__c = datetime.valueof(dateString), FirstName='Bob', LastName='Smith', lan_ID__c='smith123', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
        
        Account a = new account (name='acme');
            insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
            insert c;    
     
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        
        Test.StartTest();
            FormsTypeOneExpireSession_Schedule sh1 = new FormsTypeOneExpireSession_Schedule();
            String sch = '0 0 23 * * ?'; system.schedule('Test Expire Session', sch, sh1);
        Test.stopTest(); 
        
    }
    
}