public class ProfileController { 

	@AuraEnabled
	public static ID findUser(String sID){
		return [select id from User where Session_Token__c = :sID limit 1].ID;
	}

	@AuraEnabled
	public static string testThing(){
		return 'test';
	}
}