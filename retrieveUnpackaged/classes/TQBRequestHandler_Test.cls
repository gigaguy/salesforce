@isTest(SeeAllData=true)
public class TQBRequestHandler_Test {

    public static string TEST_TRACK = 'Development';
    //Candidate_Application__c
    @isTest
    public static void testInsertQuestionsToRequest(){
        // Insert a new request.
        Profile p = [select id, name from profile where name = 'Forms Profile'];                
        User u = new User(FirstName='test', LastName='User', profileID=p.id, Username='test@userdomain.abc', 
                    email='test@userdomain.abc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        
        Candidate_Application__c request = new Candidate_Application__c();
        request.Intended_Track__c = TEST_TRACK;
        request.First_Line_Supervisor__c = u.Id;
        request.Second_Line_Supervisor__c = u.Id;
        request.RecordTypeId = '012r00000005DW1AAM';
        insert request;
        
        System.debug('Status ' + request.Id + ' & Status '+ request.Intended_Track__c);        
        
        TQBRequestHandler.addRelatedQuestions(new List<Candidate_Application__c>{request});
        // Validate if questoin responses have been updated with relavent questions.
		List<Question_Response__c> newRecords = [Select Id,Question__c from Question_Response__c where Candidate_Application__r.Id =:request.Id];
        List<Questions__c> relatedQuestions = [Select id,Question__c from Questions__c where Track__c =:TEST_TRACK];
        System.assertEquals(newRecords.size(),relatedQuestions.size());
    }
}