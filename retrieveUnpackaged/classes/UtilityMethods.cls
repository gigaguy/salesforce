public class UtilityMethods { 

    public static string getLicName(id uID) {
    	string licName;
    	if (uid != null) {
    	licName = [select id, Profile.UserLicense.Name from user where ID = :uID limit 1].Profile.UserLicense.Name;
    	}
     return licName;
    }
    
    public static string getSessionID() {
        string sessionID;
        sessionID = ApexPages.currentPage().getParameters().get('sID');
        return sessionID;
    }

    public static string getUserID(String sessionID) {
        string userID;
        if (sessionID != null) {
            User u = [select id from User where Session_Token__c = :sessionID];
            if (u != null) {
                userID = u.ID;
            } 
        } 
        return userID;
    }
    
    public static string getUserName(String userID) {
        string userName;
        if (userID != null) {
            User u = [select id, FirstName, LastName from User where id = :userID];
            if (u != null) {
                userName = u.FirstName + ' ' + u.LastName;
            } 
        } 
        return userName;
    }
    
    public static String generateSessionID(Integer sessionIDLength) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String sessionID = '';
        while (sessionID.length() < sessionIDLength) {
           Integer index = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           sessionID += chars.substring(index, index+1);
        }
        return sessionID; 
    }
    
    // 9/21/2017 - Larry Spackman - Disabled for deployment to Production because HeaderLogs custom object not being deployed
    /*
    public static void logHeaders() {
    // Collects header info sent from WAM
        // Log Header & Parameters
        map<string,string> headers = ApexPages.currentPage().getHeaders();
        map<string, string> params = ApexPages.currentPage().getParameters();
        string headerString = '';
        string paramString = '';
        string pageURL = '';
        pageURL = ApexPages.currentPage().getURL();
        paramString = 'getURL=' + pageURL + '\n';
        paramString += 'externalForm=' + System.URL.getSalesforceBaseUrl().toExternalForm() + '\n';
        paramString += 'currentRequest=' + System.URL.getCurrentRequestUrl() + '\n';
        paramString += 'file=' + System.URL.getCurrentRequestUrl().getFile() + '\n';
        paramString += 'host=' + System.URL.getCurrentRequestUrl().getHost() + '\n';
        paramString += 'host=' + System.URL.getCurrentRequestUrl().getPath() + '\n';
        paramString += 'port=' + System.URL.getCurrentRequestUrl().getPort() + '\n';
        paramString += 'protocol=' + System.URL.getCurrentRequestUrl().getProtocol() + '\n';
        paramString += 'query=' + System.URL.getCurrentRequestUrl().getQuery() + '\n';
        paramString += 'ref=' + System.URL.getCurrentRequestUrl().getRef() + '\n';
        for (string key : headers.keySet() ){
            headerString += key;
            headerString += '=';
            headerString += headers.get(key);
            headerString += '\n';
        }
        for (string key : params.keySet() ){
            paramString += key;
            paramString += '=';
            paramString += params.get(key);
            paramString += '\n';
        }
        HeaderLog__c hl = new HeaderLog__c(HeaderDump__c = headerString, ParamDump__c = paramString);
        insert hl;
        // End Log Header & Parameters
    }
	*/
    
    public static boolean validateSession(String sessionID, string userID) {    
        User u = [select id, Session_Token__c, Session_IP__c, Session_Environment__c, Session_Timestamp__c from User where id = :userID AND Session_Token__c = :sessionID];
        // Check that the IP address and user environment is the same as when the session was created, and that the session is less than 12 hours old
        system.debug(u);
        system.debug(ApexPages.currentPage().getHeaders());
        if (u.Session_IP__c == ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP') &&
                u.Session_Environment__c == ApexPages.currentPage().getHeaders().get('User-Agent') &&
                u.Session_Timestamp__c != null &&
                u.Session_Timestamp__c.addHours(12) > System.now()) {
            return true;
        }
        // Return false unless all elements validate
        return false;
    }
    
    /*
     *This method returns all possible purchase card request types and corresponding record types.
	 */
    public static Map<String,String> getPCRequestRecordTypes(){
        Map<String,String> pcRecordTypes = new Map<String,String>();
        Map<String,String> mappingRecordTypes = UtilityMethods.getPCRequestRecordTypeMappings();
        for(String pcOption : mappingRecordTypes.keySet()){
            try{
                String recordTypeValue = mappingRecordTypes.get(pcOption);
    	        Id recordTypeId = [select id from RecordType where name = :recordTypeValue limit 1].ID;
	            pcRecordTypes.put(pcOption, recordTypeId);
            }catch(Exception e){
                System.debug(e.getMessage());
            }            
        }
        return pcRecordTypes;                                                  
    }
    public static Map<String,String> getPCRequestRecordTypeMappings(){
        return new Map<String,String>{
            	'New Purchase Card' => 'Purchase Card',
                'New Convenience Check' => 'New-Convenience Check',
                'New Approving Official (AO)' => 'New-Approving Official (AO)',
                'Cancellation of Card or Check' => 'Cancellation-Check or Card',
                'Change Cardholder AO' => 'Change-Cardholder AO',
                'Change Contact Information' => 'Change-Contact Information',
                'Change Monthly Limit' => 'Change-Monthly Limit',
                'Change Name on Card or Check' => 'Change-Name on Card/Check',
                'Suspension of Card or Check' => 'Change-Suspension of Card/Check'};
    }
    public static Boolean isPurchaseCardFormId(String formId){
        Map<String,String> allFormIds = UtilityMethods.getPCRequestRecordTypes();
        Set<String> allValues = new Set<String>();
        allValues.addAll(allFormIds.values());
        return allValues.contains(formId);
    }
}