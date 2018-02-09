trigger autoChkLineItem on ContentDocumentLink (after insert, after delete, before delete) {
    
    String objectStr = 'Line_Item__c';
    String currentObjStr;
    List<ContentDocumentLink> cdlList;
    List<ID> itemIds = new List<ID>();
    List<Line_Item__c> updateItemList = new List<Line_Item__c>();
    
    System.debug('In autoChkLineItem class');
    
    if(Trigger.isInsert)
    {
        System.debug('A file is linked to a record');
        for(ContentDocumentLink tmpList: Trigger.New)
        {
            currentObjStr = (tmpList.LinkedEntityId).getSObjectType().getDescribe().getName();
            if(currentObjStr.equalsIgnoreCase(objectStr))
            {
                itemIds.add(tmpList.LinkedEntityId);
            }
        }
        
        if(itemIds.size() > 0)
        {
            System.debug('There is at least one Line Item record that have a file');
            for(Line_Item__c tmpItem: [select id, name, File_Attached__c FROM Line_Item__c where ID IN: itemIds])
            {
                if(tmpItem.File_Attached__c == false)
                {
                    tmpItem.File_Attached__c = true;
                    updateItemList.add(tmpItem);
                }
            }
            if(updateItemList.size() > 0)
                update updateItemList;
        } 
    }
    
    if(Trigger.isDelete)
    {
        System.debug('A file is being unlinked to a record');
        for(ContentDocumentLink tmpList: Trigger.Old)
        {
            currentObjStr = (tmpList.LinkedEntityId).getSObjectType().getDescribe().getName();
            if(currentObjStr.equalsIgnoreCase(objectStr))
            {
                itemIds.add(tmpList.LinkedEntityId);
            }
        }
        
        if(itemIds.size() > 0)
        {
            System.debug('There is at least one Line Item record that have a file');
            for(Line_Item__c tmpItem: [select id, name, File_Attached__c FROM Line_Item__c where ID IN: itemIds])
            {
                if(tmpItem.File_Attached__c == true)
                {
                    tmpItem.File_Attached__c = false;
                    updateItemList.add(tmpItem);
                }
            }
            if(updateItemList.size() > 0)
                update updateItemList;
        }
    } 
}