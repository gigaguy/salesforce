public class WebFormsMenuVFController { 
    public string sID {get;set;}
    public boolean valid {get;set;}
    public id uID {get;set;}

    public void onLoad() {
        valid = false;
        
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);
        
        if (uID != null) {
            valid = true;
        }
    } // end onLoad()


    /*
    public void onLoad() {
        valid = false;
        //sID = UtilityMethods.unobfuscateString( ApexPages.currentPage().getParameters().get('sID'));
        sID = ApexPages.currentPage().getParameters().get('sID');
        if (sID != null) {
            User u = [select id from User where Session_Token__c = :sId];
            if (u != null) {
                valid = true;
                uID = u.ID;
            } // end if (u != null)
        } // end if (sID != null)
    } // end onLoad()
    */

    public PageReference navtoFormsPage(){
        PageReference newPR = new PageReference('/FormPage');
        newPR.getParameters().put('sID', sID);
        newPr.setRedirect(true);
        return newPR;
    }

    public pageReference navToProfilePage(){
        PageReference newPR = new PageReference('/ProfilePage');
        newPR.getParameters().put('sID', sID);
        newPr.setRedirect(true);
        return newPR;
    }
}