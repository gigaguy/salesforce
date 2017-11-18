public class initSession { 
    public string sID {get;set;}
    public id uID {get;set;}
    public map<string, string> headers;
    public map<string, string> params;

    private user u;

    public initSession(){
        // Get session ID from URL parameters, get user ID from the matching session
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);

        return;
    }

    public PageReference onLoad() {
        // Get headers and parameters from the page
        headers = ApexPages.currentPage().getHeaders();
        params = ApexPages.currentPage().getParameters();
        
        // 2017/09/21 - Larry Spackman - Disabled for deployment to Production because HeaderLogs custom object not being deployed
        /*
        // Log Header & Parameters
        UtilityMethods.logHeaders();
        // End Log Header & Parameters
        */
        
        // If matching user found for the session ID
        if (uID != null) {
            // Find user
            u = findUser();
            
            // If a user is found with the matching session id, store information about the users environment and initiate session fully
            if (u != null) {
                // Get and store information about the users IP address (if available), browser and current timestamp
                if (headers.get('X-Salesforce-SIP') != null) { u.Session_IP__c = headers.get('X-Salesforce-SIP'); }
                else { u.Session_IP__c = 'not available'; }
                u.Session_Environment__c = headers.get('User-Agent');
                u.Session_Timestamp__c = System.now();
                
                update u;
                
                // LS 2017/11/17: Temporary method to share records with Forms Site Guest User
                shareRecords(u);
                
                // Redirect user to the form page with the new session ID set
                //PageReference newPR = new PageReference('https://oeiodsta-oeiodstadev.cs33.force.com/FormPage');
                PageReference newPR = new PageReference(Forms_URL__c.getValues('Form URL').URL__c);
                newPR.getParameters().put('sID', sID);
                newPr.setRedirect(true);
                return newPR;
            } // End if (u != null)
        } // End if (uID != null) 
        return null;
    } // End onLoad()

    private User findUser() {
        User u = [select id from User where Session_Token__c = :sID limit 1];
        return u;
    } // End findUser()
    
    private void shareRecords(User u){
        // LS 2017/11/17: Temporary bulk method to get all form records for the logging in type-1 user and share read/write access with the general Forms Site Guest User.
    	// In the future, this method should either be bulkified to not break with tons of form records or removed entirely to be done on-demand when an existing form is opened. 
        List<Forms__c> forms = new List<Forms__c>(); 
        List<id> formIds = new List<Id>();
        List<Forms__Share> formShares = new List<Forms__Share>();  
        // Get all forms for this logging in user
        forms = [SELECT Id, Unauthenticated_Owner__c
                FROM Forms__c 
                WHERE Unauthenticated_Owner__c = :u.Id];      
        // If this user has already existing forms, share each with Forms Site Guest User with read/write access. Using hard-coded ID for testing for this user of "00535000000UUHc".
        // In the future, will need to add querying for the actual user ID of Forms Site Guest User dynamically.
        if (forms.size() > 0) {
            for (forms__c form : forms) {
                formIDs.add(form.Id);
            } // End for
            for (Integer i = 0; i < formIds.size();i++) {
            	formShares.add(new Forms__Share(ParentID = formIds[i], UserorGroupID = '00535000000UUHc', AccessLevel = 'edit'));
      		}
        	database.insert(formShares, false);
        } // End if
    } // End shareRecords(User u)
    
}