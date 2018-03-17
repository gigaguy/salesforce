trigger PCformEnterApprovalProcess on Forms__c (before update) {
    
    Forms__c previousForm;
    Map<Id,Boolean> lineItemMap1 = new Map<Id, Boolean>();
    List<Line_Item__c> lineItemList;
    List<Forms__c> tmpFormsList;
    List<ID> LineItemIds = new List<ID>();
    List<ContentDocumentLink> fileList;
    Map<ID,ID> formRtPcMap = new Map<ID,ID>();
    
    for(RecordType RT: [select id, name from recordtype where name ='Purchase Card: New Purchase Card' or 
                        name = 'Purchase Card: New Convenience Check' or 
                        name = 'Purchase Card: New Approving Official (AO)'])
    {
        formRTPcMap.put(RT.Id, RT.Id);
         LineItemIds.add(RT.Id);
    }
    system.debug(formRTPcMap.size());
    
    LineItemIds.addAll(formRTPcMap.values());
    
    System.debug('lineitems: '+LineItemIds);
    
    //Get a collection of all Purchase Card forms that have been submitted for approval and have the Approval Step changed to "Awaiting AO Approval"
    tmpFormsList = [select id, recordtypeid, Approval_Step__c from Forms__c where id IN: Trigger.New and recordtypeid IN: lineItemIds ];
    
    //Get a collection of Line Items record that are related to submitted Purchase Card
    lineItemList =  [select id, Name, Completion_Date__c, Related_Form__c FROM Line_Item__c where Related_Form__c IN: tmpFormsList];
    
    //Store the Line Item Element in the list    
    for(Line_Item__c tmpItem: lineItemList)
    {
        LineItemIds.add(tmpItem.Id);
    }
    
    System.debug('lineItemList: '+lineItemList.size());
    
    //Get a collection of ContentDocumentLink that have a linked document to a Line Item
    try{
        fileList = [SELECT id, linkedEntityId from ContentDocumentLink where LinkedEntityId IN: LineItemIds];
    }catch(Exception E)
    {
        fileList = new List<ContentDocumentLink>();
    }
    
    System.debug('filelist: '+fileList.size());
    
    LineItemIds.clear();
    //Store the Line Item Element in the list    
    for(ContentDocumentLink cdl: fileList)
    {
        LineItemIds.add(cdl.linkedEntityId);
    }
    
    
    //Find all Line Item elements that does not contain a Completion Date or an Attachment
    lineItemList =  [select id, Name, Completion_Date__c, Related_Form__c FROM Line_Item__c where Related_Form__c IN: tmpFormsList and 
                     (ID NOT IN: LineItemIds or Completion_Date__c = null) ];
    
    
    System.debug('lineitemList: '+lineItemList.size());    
    //Store the Form and a false bool
    for(Line_Item__c tmpItem : lineItemList)
    {
        System.debug(tmpItem);
        lineItemMap1.put(tmpItem.Related_Form__c, false);
    }
    
    for(Forms__c form : trigger.new) 
    {
        System.debug('Start of PCformEnterApprovalProcess');
        previousForm = Trigger.oldMap.get(form.id);
        System.debug('Start');
        system.debug(form.RecordTypeId);
        system.debug(formRTPcMap.keySet());
        System.debug(previousForm.Approval_Step__c);
        System.debug(form.Approval_Step__c);
        System.debug(formRTPcMap.containsKey(form.id));
        SYstem.debug('End');
        
        if(previousForm.Approval_Step__c != form.Approval_Step__c && 
           form.Approval_Step__c == 'Awaiting AO Approval' && formRTPcMap.containsKey(form.RecordTypeId))  
        {
            System.debug('Found Purchase Card Forms that are submitted for approval');
            //
            if(lineItemMap1.containsKey(form.Id) || fileList.isEmpty())
            {
                form.addError('One or more of your training records is missing required information and/or the training certificate is not attached.  Please review the records and complete them before submitting for approval.');
            }
        }
    }
} 


/*
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
 */
 


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