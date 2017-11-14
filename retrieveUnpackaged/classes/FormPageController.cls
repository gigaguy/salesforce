public class FormPageController {
    @auraEnabled
    public static List<RecordType> getFormRTs(string sID){
        //query for permissionsetassignments for this user
        User u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
        
        Set<id> psIds = new Set<id>();
        for (PermissionSetAssignment psa : [select id, PermissionSetId from PermissionSetAssignment where AssigneeId = :u.Id]){
            psIds.add(psa.PermissionSetID);
        }
        
        Set<string> formNames = new Set<String>();
        for (PermissionSet ps : [select id, Label from PermissionSet where id in :psIDs]){
            
            formNames.add(ps.label.removeStart('BAPForms User - '));
            //hardcoding EPA-100 for all users
            formNames.add('EPA-100');
        }
        return [select id, Name, Description from RecordType where sObjectType = 'Forms__c' and IsActive = true and Name in :formNames];
    }
    
    @AuraEnabled
    public static List<Forms__c> findExistingForms(string sID){
        Forms__c existingForm;
        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
            
            return [select id, Name, Form_Type_Name__c, Approval_Step__c, CreatedDate, LastModifiedDate, AWL_Phone_Number__c, User_Supervisor__c from Forms__c where Unauthenticated_Owner__c = :u.ID order by CreatedDate DESC];
        }
        catch (exception e){}
        
        return null;
    }
    
    @AuraEnabled
    public static Forms__c viewForm(string formID){
        forms__c form = [select id, name, Approval_step__c, SF_182_Prepare_For_checker__c from Forms__c where id = :formID limit 1];
     return form;
        
    }
    
    @AuraEnabled
    public static Forms__c insertNewForms(string sID, string rtID){
        system.debug('Starting insertNewForms');
        string rtName = [select id, developerName from recordtype where id = :rtID limit 1].developerName;
        Forms__c existingForm;
        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
            
            /*existingForm = [select id, Approval_step__c, AWL_Phone_Number__c, User_Supervisor__c from Forms__c where RecordTypeId = :rtID and Unauthenticated_Owner__c = :u.ID and Approval_Step__c != 'Approved' order by CreatedDate DESC limit 1];
            if (existingForm != null) return existingForm;*/
        }
        catch (exception ex){
        }
        try{
            //no existing form
            if (u != null){
                Forms__c nf = new Forms__c();
                nf.put('Unauthenticated_Owner__c', u.id);
                if(rtName != 'SF_182') nf.put('User_Supervisor__c', u.Supervisor__c);
                nf.put('RecordTypeId', rtID);
                nf.put('Quantity__c', 1);
                insert nf;
                System.debug('newForms'+nf);
                return nf;
            }
        }
        catch(DMLException ex){
           AuraHandledException e = new AuraHandledException(ex.getMessage() + ' - ' + string.valueOf(ex.getLineNumber()));
            system.debug(ex.getMessage());
           throw e;
        }
        return null;        
    }
    
    @AuraEnabled
    public static string deleteForm(ID formID, string sID){
        delete [select id from Forms__c where ID = :formID];
        
        return 'Form Deleted';
    }
    
    @AuraEnabled
    public static string saveForm(Forms__c sentForm, string sID){
        String message = 'Saved';
        try{
            upsert sentForm;
            return message;
        }
        catch(exception ex){
            message = ex.getMessage();
            return message;
        }
    }
    
    @AuraEnabled
    public static string submitForApproval(ID formID, string sID){
        String message = 'Not Submitted - Please check that all your approvers are set and try again';
        try{
            system.debug(formId);
    //        User u = [select id from User where Name = 'EPA Business Automation Platform User' limit 1];

            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Automatically Submitted');
            req1.setObjectId(formId);
            //req1.setSubmitterId('00535000000VAA9');
    //        req1.setSubmitterID(u.ID);
            Approval.ProcessResult result = Approval.process(req1);
            if (result.IsSuccess()) message = 'Submitted';
            return message;
        }
        catch(exception ex){
            message = string.valueof(ex);
            return message;
        }
    }

    @AuraEnabled
    public static List<BAP_Fill_and_Print_List__mdt> getFandP_FormRTs(){
                
          return [select Label, Description__c, File_Url__c from BAP_Fill_and_Print_List__mdt ORDER BY Label ASC];
          
    }
    
    @AuraEnabled
    public static Id uploadFile(String FormID, String fileName, String base64Data, String contentType) { 
     //   base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = new Attachment();
        a.parentId = FormID;
        a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType; 
        insert a;
        System.debug(a.Id);
        return a.Id;
    }
    
    @AuraEnabled
    public static List<attachment> getListOfAttachments(String formID) {        
        return [select id, Name, CreatedDate from Attachment where parentID = :formID order by CreatedDate DESC];        
    }
        
    @AuraEnabled
    public static string deleteFormAttachment(ID attID){
     
            delete [select id from Attachment where ID = :attID];
            return '-- Attachment Deleted';    
    }
    
    @AuraEnabled
    public static Forms__c cloneForm(ID FormID) { 
        
            String soql = UtilityMethods.getCreatableFieldsSOQL('forms__c','id=\''+FormID+'\'');
            forms__c f = (forms__c)Database.query(soql);
            forms__c f2 = f.clone(false, true);
            insert f2;    

            return f2;
    }
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
 
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
 
        update a;
    }
     
}