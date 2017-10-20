public class logoutPageController {
     public string sID {get;set;}
     public id uID {get;set;}
     public User u {get;set;}
    
    public logoutPageController(){
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);
        
        // Get user to remove SessionID from User Record during logout
        if (uID != null) { //start get SessionID
            u = [select id, Session_Token__c from User where Session_Token__c = :sID];
            } //end get SessionID
    }
    
    public PageReference logout(){
        String wamURL = WAM_URL__c.getValues('WAM URL').url__c;
        PageReference logout = new PageReference(wamURL);
        u.Session_Token__c = '';
        update u;
        return logout;
    }
    
    public PageReference cancel(){
        PageReference cancel = Page.FormPage;
        cancel.getparameters().put('sID',sID);
        return cancel;
    }
}