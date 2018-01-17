public class TrainingController {
    //public static string TRAINING_RECORD_TYPE_ID = '';
    public static string TRAINING_RECORD_TYPE_NAME = 'Training';
    public static string TRAINING_RECORD_DEFUALT_APPROVAL_STEP = 'Saved';
	@auraEnabled
    public static List<Forms__c> getUserTrainingForms(string sID){
        System.debug('getUserTrainingForms ' + sID);
        List<Forms__c> trainings = null;        
        User u;
        try{
            
            string TRAINING_RECORD_TYPE_ID = [select id from RecordType where name = :TRAINING_RECORD_TYPE_NAME limit 1].ID;
            System.debug('TRAINING_RECORD_TYPE_ID ' +TRAINING_RECORD_TYPE_ID);
            u = [select id from User where Session_Token__c = :sID];     
            //t.s. 1.16.18 Purchase_Card_Request__c
            trainings = [select id,Purchase_Card_Request__c, PC_Course_Title__c, Location__c, Date__c, CLP_s__c, Pass_Fail__c from Forms__c where PC_Course_Title__c != NULL AND Unauthenticated_Owner__c = :u.ID AND RecordTypeId =:TRAINING_RECORD_TYPE_ID order by Date__c DESC];
         //	trainings = [select id,Purchase_Card_Request__c, PC_Course_Title__c, Location__c, Date__c, CLP_s__c, Pass_Fail__c from Forms__c where PC_Course_Title__c != NULL AND Unauthenticated_Owner__c = :u.ID AND RecordTypeId =:TRAINING_RECORD_TYPE_ID order by Date__c DESC];
        }
        catch (exception e){
            System.debug('getUserTrainingForms - '+e.getMessage());
        }
        return trainings;
    }
    @AuraEnabled
    public static Forms__c insertTrainingForm(string sID, string pcRecordId){
       
        Forms__c trainingForm;
        User u;
        try{
            u = [select id from User where Session_Token__c = :sID];
            if (u != null){
                trainingForm = new Forms__c();
                string TRAINING_RECORD_TYPE_ID = [select id from RecordType where name = :TRAINING_RECORD_TYPE_NAME limit 1].ID;
                trainingForm.put('RecordTypeId', TRAINING_RECORD_TYPE_ID);
                trainingForm.put('Approval_Step__c', TRAINING_RECORD_DEFUALT_APPROVAL_STEP);
                trainingForm.put('Unauthenticated_Owner__c',u.Id);
                if(pcRecordId!=null){
                    trainingForm.put('Purchase_Card_Request__c',Id.valueOf(pcRecordId));
                }
                insert trainingForm;
            }
        }
        catch (exception ex){
            System.debug('insertTrainingForm '+ex.getMessage());
        }
        return trainingForm;
    }
    @AuraEnabled
    public static string deleteForm(ID formID){
        delete [select id from Forms__c where ID = :formID];		
        return 'Form Deleted';
    }
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        
        System.debug('parentId = '+parentId);
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
    
    
  @InvocableMethod(label='Update Training Date' description='Update training last taken date on the user contact record.')
  public static void updateTrainingDate(List<Id> uIds) {  
      
      Contact cont;
      User u;
       
      try{ 
          if(uIds.size()>0){
              Id uId = uIds.get(0);
	          u = [select Name, LAN_ID__c from User where Id = :uId];
    		  cont = [Select Id,GSA_SmartPay_Training_Date__c from Contact where LAN_ID__c = :u.LAN_ID__c];
              String theName = u.Name;
              List<Forms__c> myForms = [SELECT Date__c FROM Forms__c WHERE Form_Owner__c = :theName];
              Date newestDate;

              for(Forms__c thisForm : myForms){
                if(thisForm.Date__c != null){
                    if(newestDate == null || thisForm.Date__c > newestDate){
                        newestDate = thisForm.Date__c;
                    }
                }
              }
        	  cont.GSA_SmartPay_Training_Date__c = newestDate;
	          update cont;
          }
          
         }catch(Exception e){
              System.debug(e.getMessage());
       }
  }

}