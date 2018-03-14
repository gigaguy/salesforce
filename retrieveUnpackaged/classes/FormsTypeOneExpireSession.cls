global class FormsTypeOneExpireSession implements Database.Batchable<SObject> {
    integer expirationHours;    
    
    global Database.QueryLocator start(Database.BatchableContext context) {
        List<User> users = new List<User>();
        List<String> userIDs = new List<String>();
        // Set the threshold for an expired session in hours, setting to zero for testing
        if (expirationHours == null)  {
            expirationHours = -6;
        }
        datetime expiredDateTime = System.now().addHours(expirationHours);
        // Query all users whose type-1 session is older than expired threshold
        users = [SELECT Id, Session_Timestamp__c
                FROM User 
                WHERE Session_Timestamp__c < :expiredDateTime];
        for (User u : users) {
            userIDs.add(u.Id);
        } 
        // Query all Form records for these users
        if (users.size() > 0) {
            return Database.getQueryLocator('SELECT Id, Unauthenticated_Owner__c FROM Forms__c WHERE Unauthenticated_Owner__c IN :userIDs');
        }
        else return null;
    }
    
    global void execute(Database.BatchableContext context, List<Forms__c> forms) {
        List<String> formIDs = new List<String>();
        List<Forms__Share> formShares = new List<Forms__Share>();
        //string siteUserID = UtilityMethods.getAnyUserID('EPA BAP Forms', 'Site Guest User');
        string siteUserID = [select id from User where FirstName = 'EPA BAP Forms' AND LastName = 'Site Guest User' limit 1].id;
        for (Forms__c form : forms) {
            formIDs.add(form.Id);
        }
        // Query all FormShares for these forms that are shared with Forms Site Guest User
        if (forms.size() > 0) {
            system.debug(formIDs);
            system.debug(siteUserID);
            formShares = [SELECT Id
                         FROM Forms__Share 
                         WHERE ParentID IN :formIDs
                         AND AccessLevel = 'edit'
                         AND UserOrGroupId = :siteUserID];
        }
        // Delete FormShares
        if (formShares.size() > 0) {
            Database.delete(formShares,false);
        }
    }
    
    global void finish(Database.BatchableContext context) {
        
    }
    
}