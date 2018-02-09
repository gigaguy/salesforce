trigger updateGSACompletionDate on Line_Item__c (before update) {
    /*
    List<Line_Item__c> lineItemList;
    List<ID> employeeContactIDList;
  	Map<ID,ID> a1 = new Map<ID,ID>();
    Date currentDate;
    Map<ID,Date> Item_And_Date_Map = new Map<ID,Date>();
	lineItemList = [SELECT ID, Employee__c, Completion_Date__c,Course_Title__c,Related_Form__c FROM Line_Item__c WHERE id IN: Trigger.New and 
                   Course_Title__c = 'GSA SmartPay Purchase Card Training'];
    
    
    List<Contact> contactList;
    
    for(Line_Item__c tmp: lineItemList)
    {
        employeeContactIDList.add(tmp.Employee__c);
        currentDate = null;
        if(Item_And_Date_Map.containsKey(tmp.id) == false)
        {
        	Item_And_Date_Map.put(tmp.id, tmp.Completion_Date__c);  
        }
        else
        {
        	currentDate = Item_And_Date_Map.get(tmp.Id);
            if(currentDate < tmp.Completion_Date__c)
            {
                Item_And_Date_Map.remove(tmp.Id);
                Item_And_Date_Map.put(tmp.Id, tmp.Completion_Date__c);
            }
            
        }
        
    }
    
    for(Contact con: [select ID, GSA_SmartPay_Training_Date__c FROM Contact where ID IN: employeeContactIDList])
    {
        
    }
    */
}