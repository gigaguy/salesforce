@istest(SeeAllData=true)
public class TrainingController_Test {
    public static string TRAINING_RECORD_DEFUALT_APPROVAL_STEP = 'Saved';
    @isTest
    static void testGetUserTrainingForms(){
        
        string TRAINING_RECORD_TYPE_ID = [select id from RecordType where name = 'Training' limit 1].ID;
        string sID = '123ABC';
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = sID;
        update u;
        
        Forms__c trainingForm;
        trainingForm = new Forms__c();
        trainingForm.put('RecordTypeId', TRAINING_RECORD_TYPE_ID);
        trainingForm.put('Pass_Fail__c', 'P');
        trainingForm.put('Course_Title__c', 'GSA SmartPay Purchase Card Training');
        trainingForm.put('Approval_Step__c', TRAINING_RECORD_DEFUALT_APPROVAL_STEP);
        trainingForm.put('Unauthenticated_Owner__c',u.Id);        
        insert trainingForm;
        
        List<Forms__c> trainings = TrainingController.getUserTrainingForms(sID);
		System.assert(trainings.size()>0);
    }
    @isTest
    static void testInsertTrainingFormWithOutParent(){
        
        String parentId = null;
        
        string sID = '123ABC';
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = sID;
        update u;
        
        Forms__c trainingForm = TrainingController.insertTrainingForm(sID,parentId);
        System.assert(trainingForm!=null);
    }
    @isTest
    static void testInsertTrainingFormWithParent(){
        
        string sID = '123ABC';
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = sID;
        update u;
        
        Forms__c pcform = new Forms__c();
        pcform.put('Purchase_Card_Request_Type__c', 'New Purchase Card');
        pcform.put('Pass_Fail__c', 'P');
        pcform.put('RecordTypeId', [select id from RecordType where name = 'Purchase Card' limit 1].ID);
        pcform.put('Course_Title__c', 'GSA SmartPay Purchase Card Training');
        pcform.put('Unauthenticated_Owner__c', u.Id);
        insert pcform;
        
        String parentId = ''+pcform.ID;
     
        Forms__c trainingForm = TrainingController.insertTrainingForm(sID,parentId);
        System.assert(trainingForm!=null);
    }
    @isTest
    static void testDeleteForm(){
        
        string TRAINING_RECORD_TYPE_ID = [select id from RecordType where name = 'Training' limit 1].ID;
        string sID = '123ABC';
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = sID;
        update u;
        
        Forms__c trainingForm;
        trainingForm = new Forms__c();
        trainingForm.put('RecordTypeId', TRAINING_RECORD_TYPE_ID);
        trainingForm.put('Pass_Fail__c', 'P');
        trainingForm.put('Course_Title__c', 'GSA SmartPay Purchase Card Training');
        trainingForm.put('Approval_Step__c', TRAINING_RECORD_DEFUALT_APPROVAL_STEP);
        trainingForm.put('Unauthenticated_Owner__c',u.Id);        
        insert trainingForm;
        
        String res = TrainingController.deleteForm(trainingForm.ID);
        System.assert(res=='Form Deleted');
        
    }
    @isTest
    static void testUpdateTrainingDate(){
        
        string TRAINING_RECORD_TYPE_ID = [select id from RecordType where name = 'Training' limit 1].ID;
        string sID = '123ABC';
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = sID;
        update u;
        
        Forms__c trainingForm;
        trainingForm = new Forms__c();
        trainingForm.put('RecordTypeId', TRAINING_RECORD_TYPE_ID);
        trainingForm.put('Pass_Fail__c', 'P');
        trainingForm.put('Course_Title__c', 'GSA SmartPay Purchase Card Training');
        trainingForm.put('Approval_Step__c', TRAINING_RECORD_DEFUALT_APPROVAL_STEP);
        trainingForm.put('Unauthenticated_Owner__c',u.Id);        
        insert trainingForm;
        
		TrainingController.updateTrainingDate(new List<Id>{trainingForm.ID});        
    }
    @isTest
    static void testUpload(){
		
		string TRAINING_RECORD_TYPE_ID = [select id from RecordType where name = 'Training' limit 1].ID;
        string sID = '123ABC';
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = sID;
        update u;
        
        Forms__c trainingForm;
        trainingForm = new Forms__c();
        trainingForm.put('RecordTypeId', TRAINING_RECORD_TYPE_ID);
        trainingForm.put('Pass_Fail__c', 'P');
        trainingForm.put('Course_Title__c', 'GSA SmartPay Purchase Card Training');
        trainingForm.put('Approval_Step__c', TRAINING_RECORD_DEFUALT_APPROVAL_STEP);
        trainingForm.put('Unauthenticated_Owner__c',u.Id);        
        insert trainingForm;        

        string before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
   	    string base64Data = EncodingUtil.base64Encode(beforeblob);
        
        String fileName = 'demo';
        String contentType = 'text';
        
        String fileId = '';
        
        fileId = TrainingController.saveChunk(trainingForm.Id, fileName, base64Data, contentType, fileId);
        fileId = TrainingController.saveChunk(trainingForm.Id, fileName, base64Data, contentType, fileId);
		System.assert(fileId!=null);
    }
}