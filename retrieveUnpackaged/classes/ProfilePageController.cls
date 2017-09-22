public class ProfilePageController { 
    public string sID {get;set;}
    public boolean valid {get;set;}
    public id uID {get;set;}
    public string userName {get;set;}
    public id supID {get;set;}
    public id timekID {get;set;}
    public id sup2ID {get;set;}
    public id fundID {get;set;}
    public id trainID {get;set;}

    public User u {get;set;}
    public Contact c {get;set;}
    public Boolean useContact {get;set;}
    public String licName {get;set;}
    public Boolean t1User {get;set;}
    public String canMsg {get;set;}
    public Boolean lanError {get;set;}
    public Boolean noContact {get;set;}
    public Boolean profSaved {get;set;}
    
    public ProfilePageController() {
        ID userID = UserInfo.getUserID();
        licName = UtilityMethods.getLicName(userID);
        lanError=false;
        noContact=false;
        string saveCheck=ApexPages.currentPage().getParameters().get('saved');
        if(saveCheck=='true'){profSaved=true;}
        
        if(licName != 'Guest User License'){t1User=false; canMsg='Back to Forms';}
        else{t1User=true; canMsg='Back to Form Types';}
        if(t1User){
        valid = false;
        // Get session ID from URL parameters, get user ID from the matching session
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);
        
        // Validate Session, temporarily disabled until more user data from proxy 
        valid = UtilityMethods.validateSession(sID, uID);
          }
        else {uID = UserInfo.getUserId(); valid= true;}
        
        useContact = Contact_Approvers__c.getValues('Use Contact Fields').Use_Contact__c; // checkbox from "Contact Approvers" Custom Setting
        
        // Get related users from User record for Approval process
        if (uID != null && valid) {
            if(t1User){
                u = [select id, LAN_ID__c, Supervisor__c, Time_Keeper__c, Supervisor_2__c, Funding_official__c, Training_Officer__c from User where Session_Token__c = :sID];
                }
            else {u = [select id, LAN_ID__c, Supervisor__c, Time_Keeper__c, Supervisor_2__c, Funding_official__c, Training_Officer__c from User where ID = :uID];}
           
           if(u.LAN_ID__c == null){lanError=true;}
            userName = UtilityMethods.getUserName(uID);
              //get related users from Contact fields for Approval process
                
              system.debug('user lanID: '+u.Lan_ID__c); 
           try {   
              c = [select id, Name, LAN_ID__c, Supervisor__c, Time_Keeper__c, Supervisor_2__c, Funding_official__c, Training_Officer__c from Contact where LAN_ID__c = :u.LAN_ID__c limit 1];
                  supID = c.supervisor__c;
                  timekID = c.Time_Keeper__c;
                  sup2ID = c.Supervisor_2__c;
                  fundID = c.Funding_official__c;
                  trainID = c.Training_Officer__c; } catch (Exception e) {noContact=true;}
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
       
        // Valid value from Verify Session call above
        if (!valid) {
            PageReference retURL = new PageReference('/');
            return retURL;
        }
        else { return null; }       
    }
    
    public pageReference save() {
        if(!lanError) {
        update u;
        
        c.supervisor__c = supID;
        c.Time_Keeper__c = timekID;
        c.Supervisor_2__c = sup2ID;
        c.Funding_official__c = fundID;
        c.Training_Officer__c = trainID;
        update c;
         }
        
        PageReference newPR = new PageReference('/ProfilePage');
        if(!t1User){newPR = ApexPages.currentPage();}
        newPR.getParameters().clear();
        newPR.getParameters().put('sID', sID);
        newPR.getParameters().put('saved', 'true');
        newPR.setRedirect(true);
        return newPR;
    }
    
    public pageReference cancel() {
        string url = '/FormPage';
        if(!t1User){url = 'https://epaoei--oeiodsta.cs33.my.salesforce.com/a03/o';}     
        PageReference newPR = new PageReference(url);
        newPR.getParameters().clear();
        newPR.getParameters().put('sID', sID);
        newPR.setRedirect(true);
        return newPR;
    }
    
}