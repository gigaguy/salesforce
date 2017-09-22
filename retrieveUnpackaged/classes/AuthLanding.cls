public class AuthLanding { 
    private map<string, string> headers;
    private map<string, string> params;
    private string UID;

    private user u;
    private string sessionID;

    public AuthLanding(){
        UID = '';
        // Get headers and parameters from the page
        headers = ApexPages.currentPage().getHeaders();
        params = ApexPages.currentPage().getParameters();

        // Check for user identification from WAM headers and confirm it is coming from WAM server
        if (headers.containsKey('uid') 
            && headers.get('Shib-Identity-Provider') == 'https://idpstg.epa.gov/' 
            //&& headers.get('X-Forwarded-Host') == 'oeiodstadev.epa.gov'   
            // Disabled 8/24/2017 to accomadate different EPA subdomains for other environments and changing WAM values
            ) 
            { UID = headers.get('uid'); }
        else if (headers.containsKey('AUTH_USER')
            && headers.get('Shib-Identity-Provider') == 'https://idpstg.epa.gov/' 
            //&& headers.get('X-Forwarded-Host') == 'oeiodstadev.epa.gov'
            // Disabled 8/24/2017 to accomadate different EPA subdomains for other environments and changing WAM values
            ) 
            { UID = headers.get('AUTH_USER'); }    
        else if (headers.containsKey('REMOTE_USER')
            && headers.get('Shib-Identity-Provider') == 'https://idpstg.epa.gov/' 
            //&& headers.get('X-Forwarded-Host') == 'oeiodstadev.epa.gov'
            // Disabled 8/24/2017 to accomadate different EPA subdomains for other environments and changing WAM values
            ) 
            { UID = headers.get('REMOTE_USER'); } 

        // Manual override URL parameter for testing, will be removed once deployed
        if (params.containsKey('UID')) uId = params.get('UID');
        
        // Set any found user identification to lowercase for comparison to user object
        UID = UID.toLowerCase();
    }

    public PageReference onLoad() {
        // 9/21/2017 - Larry Spackman - Disabled for deployment to Production because HeaderLogs custom object not being deployed
        /*
        // Log Header & Parameters
        UtilityMethods.logHeaders();
        // End Log Header & Parameters
		*/   
        
        // If user identification is present
        if (UID != '') {
            //find contact/user
            u = findUser();
            
            // If a user is found with the matching federation id, generate session and store information about the users environment
            if (u != null) {
                // Generate sessionID and store on user record
                sessionID = UtilityMethods.generateSessionID(20);
                u.Session_Token__c = sessionId;
                
                // Get and store information about the users IP address (if available), browser and current timestamp
                if (headers.get('X-Salesforce-SIP') != null) { u.Session_IP__c = headers.get('X-Salesforce-SIP'); }
                else { u.Session_IP__c = 'not available'; }
                u.Session_Environment__c = headers.get('User-Agent');
                u.Session_Timestamp__c = System.now();
                
                update u;
                
                // Redirect user to the initSession page with the new session ID set
                PageReference newPR = new PageReference(Init_Session_URL__c.getValues('Init Session URL').URL__c);
                newPR.getParameters().put('sID', sessionID);
                //newPr.setRedirect(true);
                return newPR;
            } // End if (u != null)
        } // End if (UID != '') 
        return null;
    } // End onLoad()

    private User findUser(){
        User u = [select id from User where FederationIdentifier = :UID limit 1];
        return u;
    }
    
}