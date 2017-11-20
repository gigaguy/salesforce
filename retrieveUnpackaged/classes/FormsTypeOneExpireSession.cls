global class FormsTypeOneExpireSession {
    global void expireSession() {
    	List<User> users = new List<User>();
        List<String> userIDs = new List<String>();
        List<Forms__c> forms = new List<Forms__c>();
        List<String> formIDs = new List<String>();
        List<Forms__Share> formShares = new List<Forms__Share>();
        // Set the threshold for an expired session in hours, setting to zero for testing
        datetime expiredDateTime = System.now().addHours(-6);
        // Query all users whose type-1 session is older than expired threshold
    	users = [SELECT Id, Session_Timestamp__c
                FROM User 
                WHERE Session_Timestamp__c < :expiredDateTime];
        for (User u : users) {
        	userIDs.add(u.Id);
        } 
        // Query all Form records for these users
        if (users.size() > 0) {
         	forms = [SELECT Id, Unauthenticated_Owner__c
                	FROM Forms__c 
                	WHERE Unauthenticated_Owner__c IN :userIDs];  
        }
        for (Forms__c form : forms) {
        	formIDs.add(form.Id);
        }
    	// Query all FormShares for these forms that are shared with Forms Site Guest User, hardcoded ID of "00535000000UUHc"
    	// In the future, will need to add querying for the actual user ID of Forms Site Guest User dynamically.
    	if (forms.size() > 0) {
        	formShares = [SELECT Id
                         FROM Forms__Share 
                         WHERE ParentID IN :formIDs
                         AND AccessLevel != 'All'
                         AND UserOrGroupId = '00535000000UUHc'];
        }
        // Delete FormShares
        if (formShares.size() > 0) {
            Database.delete(formShares,false);
        }
    } // End expireSession()
    
}