public with sharing class AttachmentUploadController {
    public string sID {get;set;}
    public id uID {get;set;}
    public boolean valid {get;set;}
    public id formID {get;set;}
        
  public AttachmentUploadController(){
        formID = ApexPages.currentPage().getParameters().get('formID');
        
        valid = false;
        // Get session ID from URL parameters, get user ID from the matching session
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);
        
        // Validate Session, temporarily disabled until more user data from proxy 
        valid = UtilityMethods.validateSession(sID, uID);
    }
  
  public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }

  public PageReference upload() {

    attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = formID; // the record the file is attached to
    attachment.IsPrivate = true;

    try {
      insert attachment;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      return null;
    } finally {
      attachment = new Attachment(); 
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    return null;
  }
  
   public PageReference validateOrRedirect() {
       
        // Valid value from Verify Session call above
        if (!valid) {
            PageReference retURL = new PageReference('/');
            return retURL;
        }
        else { return null; }       
    }
    public PageReference goToForm() {
        return null;
      }
}