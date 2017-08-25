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
        // Log Header & Parameters
        UtilityMethods.logHeaders();
        // End Log Header & Parameters
        
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

    private User findUser(){
        User u = [select id from User where Session_Token__c = :sID limit 1];
        return u;
    }
    
}