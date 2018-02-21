trigger updateGSACompletionDate on Line_Item__c (after insert, before update) {
    
    Date currentDate;
    List<Contact> updateContactList;
    List<ID> employeeContactIDList;
    Map<ID,Date> Item_And_Date_Map = new Map<ID,Date>();
    
    employeeContactIDList = new List<ID>();

	//Loop through each line item and store the contact id and store the most recent completion date    
    for(Line_Item__c tmp: trigger.new)
    {
        if(tmp.Course_Title__c == 'GSA SmartPay Purchase Card Training' && tmp.Completion_Date__c != null && tmp.Employee__c != null)
        {
            currentDate = null;
            if(Item_And_Date_Map.containsKey(tmp.Employee__c) == false)
            {
                employeeContactIDList.add(tmp.Employee__c);
                Item_And_Date_Map.put(tmp.Employee__c, tmp.Completion_Date__c);  
            }
            else
            {
                currentDate = Item_And_Date_Map.get(tmp.Employee__c);
                if(currentDate < tmp.Completion_Date__c)
                {
                    Item_And_Date_Map.remove(tmp.Employee__c);
                    Item_And_Date_Map.put(tmp.Employee__c, tmp.Completion_Date__c);
                }
            }
        }
    }
    
    updateContactList = new List<Contact>();
    
    //loop though the contact record ans set the new training date
    for(Contact con: [select ID, GSA_SmartPay_Training_Date__c FROM Contact where ID IN: employeeContactIDList])
    {
    	 currentDate = Item_And_Date_Map.get(con.id);
        
        if(currentDate != null)
        {
            con.GSA_SmartPay_Training_Date__c = currentDate;
            updateContactList.add(con);
        }
    }
    
    if(updateContactList != null && updateContactList.size() > 0)
        update updateContactList;
}