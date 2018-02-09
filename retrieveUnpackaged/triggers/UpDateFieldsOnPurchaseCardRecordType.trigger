trigger UpDateFieldsOnPurchaseCardRecordType on Forms__c (before insert, before update) {
    System.debug('The UpDateFieldsOnPurchaseCardRecordType Trigger fired.');
   
	for (Forms__c a : Trigger.new){
        if(a.Cardholder_AO_Name__c != null){
            System.debug('a.Cardholder_AO_Name__c was not null.');
            Contact myContact = [SELECT Name, Phone, Email, Employee_Number__c, Mail_Stop__c, MailingStreet, MailingCity, MailingState, MailingPostalCode FROM Contact WHERE Id = :a.Cardholder_AO_Name__c];
            //update the fields with the information from that contact
            a.Cardholder_AO_Display_Name__c = myContact.Name;
            a.Telephone_Number__c = myContact.Phone;
            a.Email_Address__c = myContact.Email;
            a.EIN__c = myContact.Employee_Number__c;
            a.Mailing_Address__c = myContact.MailingStreet;
            a.Mail_Code__c = myContact.Mail_Stop__c;
            a.City__c = myContact.MailingCity;
            a.State__c = myContact.MailingState;
            a.Zip__c = myContact.MailingPostalCode;
            
        }else{
            //Get the user name
            System.debug('the Name__c = ' + a.Cardholder_AO_Display_Name__c);
			Contact myContact = [SELECT Id FROM Contact WHERE Name = :a.Cardholder_AO_Display_Name__c];            
            //Fill the Cardholder_AO_Name__c withe
            a.Cardholder_AO_Name__c = myContact.Id;
        }
        
	}

}