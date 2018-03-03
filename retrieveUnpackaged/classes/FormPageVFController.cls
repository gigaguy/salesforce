public class FormPageVFController { 
    public string sID {get;set;}
    public boolean valid {get;set;}
    public boolean instructions {get;set;}
    public id uID {get;set;}
    public string userName {get;set;}
    public Boolean lanError {get;set;}
    public Boolean noContact {get;set;}
    
    public FormPageVFController() {
        valid = false;
        lanError=false;
        noContact=false;
        // Get session ID from URL parameters, get user ID from the matching session 
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);
        
        // Validate Session
        valid = UtilityMethods.validateSession(sID, uID);

        // instructions needed if essential approvers not set
        Boolean useContact = Contact_Approvers__c.getValues('Use Contact Fields').Use_Contact__c; // checkbox from "Contact Approvers" Custom Setting 
        instructions = false;
        
        user u = [select id, Lan_ID__c, Supervisor__c, Time_Keeper__c, Funding_Official__c from user where id = :uID ];
        if(u.Lan_ID__c==null){lanError=true;}
        if(!useContact){
            if (u.Supervisor__c == null || u.Time_Keeper__c == null || u.Funding_Official__c == null){
                instructions = true;
                }
            }
        else {
            try {contact c = [select id, Lan_ID__c, Supervisor__c, Time_Keeper__c, Funding_Official__c from contact where Lan_ID__c = :u.Lan_ID__c limit 1];
            if (c.Supervisor__c == null || c.Time_Keeper__c == null || c.Funding_Official__c == null){
                instructions = true;
                }
            }
            catch (Exception e) {noContact=true;}
            }
        
        // set valid to TRUE for session
        if (uID != null && valid) {
            valid = true;
            userName = UtilityMethods.getUserName(uID);
        }
        return;
    }
    
    public PageReference validateOrRedirect() {
        // 9/21/2017 - Larry Spackman - Disabled for deployment to Production because HeaderLogs custom object not being deployed
         /*
        // Log Header & Parameters
        UtilityMethods.logHeaders();
        // End Log Header & Parameters
        */ 
        
        //value for "valid" set in Validate Session call above
        if (!valid) {
            PageReference retURL = new PageReference('/');
            return retURL;
        }
        else { return null; }       
    }
    
    public PageReference logout(){
        //logout process
        PageReference logoutPage = Page.LogoutPage;
        LogoutPage.getparameters().put('sID',sID);
        logoutPage.setRedirect(true);
        return logoutPage;
    }
}