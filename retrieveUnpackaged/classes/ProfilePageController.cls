public class ProfilePageController { 
	public string sID {get;set;}
    public boolean valid {get;set;}
    public id uID {get;set;}
    public string userName {get;set;}

    public User u {get;set;}
    
    public ProfilePageController() {
        valid = false;
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);
        
        // Validate Session, temporarily disabled until more user data from proxy 
        valid = UtilityMethods.validateSession(sID, uID);
        
        if (uID != null && valid) {
            u = [select id, Supervisor__c, Time_Keeper__c, Supervisor_2__c, Funding_official__c, Training_Officer__c from User where Session_Token__c = :sID];
            userName = UtilityMethods.getUserName(uID);
        }
        return;
    }
	
    public PageReference validateOrRedirect() {
        // Log Header & Parameters
        UtilityMethods.logHeaders();
        // End Log Header & Parameters
        if (!valid) {
            PageReference retURL = new PageReference('/');
     		return retURL;
        }
        else { return null; }       
 	}
    
	public pageReference save() {
		update u;
        PageReference newPR = new PageReference('/ProfilePage');
        newPR.getParameters().clear();
        newPR.getParameters().put('sID', sID);
        newPR.setRedirect(true);
        return newPR;
	}
    
    public pageReference cancel() {
		PageReference newPR = new PageReference('/FormPage');
        newPR.getParameters().clear();
        newPR.getParameters().put('sID', sID);
        newPR.setRedirect(true);
        return newPR;
	}
    
}