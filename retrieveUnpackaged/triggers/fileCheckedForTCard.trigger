trigger fileCheckedForTCard on Line_Item__c (before update) {
    
    List<Line_Item__c> lineList = new List<Line_Item__c>();
    List<ContentDocumentLink> cdlIds = new List<ContentDocumentLink>();
    List<ID> lineIds = new List<ID>();
    Map<Id,String> cdlMapIds = new Map<Id, String>();
    
    //get Line Items that are in Trigger.New
    lineList = [select id from Line_Item__c where id IN: Trigger.New];
    
    //retrieve all Line Items ids in a collection var
    for(Line_Item__c tmpItem: lineList)
    {
        lineIds.add(tmpItem.id);
    }
    
    //Find cdl links that link a Line Item record to a file
    cdlIds = [select id, LinkedEntityId from ContentDocumentLink where LinkedEntityId IN: lineIds];
    
    
    //Store the linked Line Items record that are linked to a file, in a map collection
    for(ContentDocumentLink tempCDL: cdlIds)
    {
        cdlMapIds.put(tempCDL.LinkedEntityId, 'Yes');
    }
    
    
    //Checked to see if each Line Item in Trigger.new is currently linked to a file
    for(Line_Item__c currentLineItem: Trigger.New)
    {
        if(cdlMapIds.containsKey(currentLineItem.Id))
        {
            currentLineItem.File_Attached__c = true;
        }
        else
        {
            currentLineItem.File_Attached__c = false;
        }
    } 

}