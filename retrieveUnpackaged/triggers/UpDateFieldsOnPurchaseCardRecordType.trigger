trigger UpDateFieldsOnPurchaseCardRecordType on Forms__c (before insert, before update) {
    System.debug('The UpDateFieldsOnPurchaseCardRecordType Trigger fired.');
    
    //03.06.18
    //Store Form Purchase Card RecordType in a map
    //****Do not change label for recordtype without updating line 8-16
    Map<ID,ID> formRtPcMap = new Map<ID,ID>();
    for(RecordType RT: [select id, name from recordtype where name like 'Purchase Card:%'])
    {
        formRTPcMap.put(RT.Id, RT.Id);
    }
    for (Forms__c a : Trigger.new){
        if(formRtPcMap.containsKey(a.RecordTypeId)) //3.6.18, If the recordtype is not the map, dont execute the loop
        {
            
            if(a.Cardholder_AO_Name__c != null){
                System.debug('a.Cardholder_AO_Name__c was not null.');
                Contact myContact = [SELECT Name, Phone, Email, Employee_Number__c, Mail_Stop__c, MailingStreet, MailingCity, MailingState, MailingPostalCode FROM Contact WHERE Id = :a.Cardholder_AO_Name__c];
                //update the fields with the information from that contact
                
                a.Cardholder_AO_Display_Name__c = myContact.Name;

                if(myContact.Phone != null){
                    a.Telephone_Number__c = myContact.Phone;
                }else{
                    a.Telephone_Number__c = null;
                }

                if(myContact.Email != null){
                    a.Email_Address__c = myContact.Email;
                }else{
                    a.Email_Address__c = null;
                }

                if(myContact.Employee_Number__c != null){
                    a.EIN__c = myContact.Employee_Number__c;
                }else{
                    a.EIN__c = null;
                }

                if(myContact.MailingStreet != null){
                    a.Mailing_Address__c = myContact.MailingStreet;
                }else{
                    a.Mailing_Address__c = null;
                }

                if(myContact.Mail_Stop__c != null){
                    a.Mail_Code__c = myContact.Mail_Stop__c;
                }else{
                    a.Mail_Code__c = null;
                }

                if(myContact.MailingCity != null){
                    a.City__c = myContact.MailingCity;
                }else{
                    a.City__c = null;
                }

                if(myContact.MailingState != null){
                    a.State__c = myContact.MailingState;
                }else{
                    a.State__c = null;
                }

                if(myContact.MailingPostalCode != null){
                    a.Zip__c = myContact.MailingPostalCode;
                }else{
                    a.Zip__c = null;
                }
                
            }else{
                //Get the user name
                System.debug('the Name__c = ' + a.Cardholder_AO_Display_Name__c);
                Contact myContact = [SELECT Id FROM Contact WHERE Email = :a.Email_Address__c];            
                //Fill the Cardholder_AO_Name__c withe
                a.Cardholder_AO_Name__c = myContact.Id;
            }
        }
    }

}