public class FormPrintableTypeOne { 
    public string sID {get;set;}
    public boolean valid {get;set;}
    public id uID {get;set;}

    public string fID {get;set;}

    public FormPrintableTypeOne () {

        // Get session ID from URL parameters
        sID = UtilityMethods.getSessionID();
        
        // If internal user (apex trigger or class), else get user ID from the matching session
        if(sID == 'internalSysUser'){ 
            valid = true;
            uID = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1].id; 
          }
        else {
            uID = UtilityMethods.getUserID(sID);
            
            // Validate Session
            valid = UtilityMethods.validateSession(sID, uID);
            system.debug('uID: '+uID);
        }
        system.debug('sID: '+sID);
        
        system.debug('valid: '+valid);
        if (uID != null && valid) {
            fID = '';
            // Get form ID from URL parameters
            fID = ApexPages.currentPage().getParameters().get('fID');
            system.debug('fID: ' + fID);
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