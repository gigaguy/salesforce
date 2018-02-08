trigger PCformEnterApprovalProcess on Forms__c (before update) {
/*
    Forms__c previousForm;
    String errorMsg;
    ID mapKey;
    String errorMsgChk = 'The following Line Items are missing a file: ';
    List<ContentDocument> attachmentedFiles;
    List<Line_Item__c> lineItemList;
    ID pcRecordTypeID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card').getRecordTypeId();
    Map<Id,Boolean> lineItemMap1 = new Map<Id, Boolean>();
    Map<Id,Line_Item__c> lineItemMap2 = new Map<Id, Line_Item__c>();
    List<Forms__c> tmpFormsList = [select id, recordtypeid, Approval_Step__c from Forms__c where id IN: Trigger.New
                                  and recordtypeid =: pcRecordTypeID and Approval_Step__c = 'Awaiting AO Approval'];
    
    lineItemList =  [select id, Name, File_Attached__c, Related_Form__c FROM Line_Item__c where Related_Form__c IN: tmpFormsList];
    
    for(Line_Item__c tmpItem : lineItemList)
    {
        lineItemMap1.put(tmpItem.Related_Form__c, tmpItem.File_Attached__c);
        lineItemMap2.put(tmpItem.Related_Form__c, tmpItem);
    }
    lineItemList = lineItemMap2.values();
    
    for(Forms__c form : trigger.new) 
    {
        errorMsg = 'The following Line Items are missing a file: ';
        previousForm = Trigger.oldMap.get(form.id);
        
        
        if(previousForm.Approval_Step__c != form.Approval_Step__c && 
           form.Approval_Step__c == 'Awaiting AO Approval' && form.RecordTypeId == pcRecordTypeID)  
        {
            System.debug('Found Purchase Card Forms that are submitted for approval');
            
            if(lineItemMap.containsKey(form.Id) && lineItemMap2.containsKey(form.Id))
            {
				if(lineItemMap.get(form.Id) == false)
				{
				   form.addError('Form '+form.Name+' contains at least one Line Item record that does not contain a file attachment. Please check all Line Items!');
				}
            }

            
            for(Line_Item__c tempItem: lineItemList)
            {
                if(tempItem.File_Attached__c == false)
                {
                    System.debug('check box not checked');
                    errorMsg = errorMsg + tempItem.Name+' , ';
                }
            }
            errorMsg = errorMsg.removeEnd(' , ');
            System.debug('errorMsg = '+errorMsg);
            
            if(!errorMsg.equals(errorMsgChk))
            {
                form.addError(errorMsg);
            }
            errorMsg = errorMsgChk;
            
        }
        errorMsg = 'The following Line Items are missing a file: ';
    }
} */



    Forms__c previousForm;
    String errorMsg;
    String errorMsgChk = 'The following Line Items are missing a file: ';
    List<ContentDocument> attachmentedFiles;
    List<Line_Item__c> lineItemList;
    ID pcRecordTypeID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card').getRecordTypeId();
    Map<Id,Boolean> lineItemMap = new Map<Id, Boolean>();
    for(Forms__c form : trigger.new) 
    {
        errorMsg = 'The following Line Items are missing a file: ';
        previousForm = Trigger.oldMap.get(form.id);
        
        
        if(previousForm.Approval_Step__c != form.Approval_Step__c && 
           form.Approval_Step__c == 'Awaiting AO Approval' && form.RecordTypeId == pcRecordTypeID)  
        {
            System.debug('Found Purchase Card Forms that are submitted for approval');
            lineItemList =  [select id, Name, File_Attached__c, Related_Form__c FROM Line_Item__c where Related_Form__c =: form.Id];
            
            for(Line_Item__c tempItem: lineItemList)
            {
                if(tempItem.File_Attached__c == false)
                {
                    System.debug('check box not checked');
                    errorMsg = errorMsg + tempItem.Name+' , ';
                }
            }
            errorMsg = errorMsg.removeEnd(' , ');
            System.debug('errorMsg = '+errorMsg);
            
            if(!errorMsg.equals(errorMsgChk))
            {
                form.addError(errorMsg);
            }
            errorMsg = errorMsgChk;
            
        }
        errorMsg = 'The following Line Items are missing a file: ';
    }
}
 
 


//Commented out on 2/8/18 by Trellis
/*trigger PCformEnterApprovalProcess on Forms__c (before insert) {
boolean b = false;
    List<Forms__c> pcform = new List<Forms__c>();
    for(Forms__c pcform : trigger.new) 
    {
        if(pcform.Files_attached_to_Trainings__c == null){ 
            //test for the error
        pcform.form_status__c.addError('You must upload a file to the related Training records');
    b = true; //set the boolean to true so that update can't happen
            
        }
if(b==false){ //only when there are no errors can you update
    update pcform;
        }
    }
}*/