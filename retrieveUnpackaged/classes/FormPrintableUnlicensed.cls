public class FormPrintableUnlicensed { 
    public string sID {get;set;}
    public boolean valid {get;set;}
    public id uID {get;set;}
    public string userName {get;set;}

    public string fID {get;set;}

    public FormPrintableUnlicensed () {
        valid = true;
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);
        
        // Validate Session, temporarily disabled until more user data from proxy
        //valid = UtilityMethods.validateSession(sID, uID);
        
        if (uID != null && valid) {
            fID = '';
            // Get form ID from URL parameters
            fID = ApexPages.currentPage().getParameters().get('fID');
        }
        return;
    }
    
    public PageReference validateOrRedirect() {
        if (!valid) {
            PageReference retURL = new PageReference('/');
            return retURL;
        }
        else { return null; }       
    }
        
}