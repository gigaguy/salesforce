Public class sendCincinnatiEmail {
      //test coverage for this class is covered by "FormsTriggerHandler_Test"
    
    @future (callout=true)
    public static void sendMessage(ID formID) {

        String sid = 'internalSysUser';
        system.debug('sid: '+sid);
        
        PageReference formPdf = new PageReference('/apex/FormPrintableTypeOne');
        formPdf.getParameters().put('fID',formId);
        formPdf.getParameters().put('sid',sid);
        system.debug(formPDF);
        Blob b = blob.valueof('form failed to attach');
        try { b = formPdf.getContentAsPDF(); }      
        catch(Exception e){}
        
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {'jjenkins@innovateteam.com'}; 
    //    String[] ccAddresses = new String[] {'smith@gmail.com'};
          
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('NoReply@NoReply.com');
        
        mail.setSenderDisplayName('Salesforce Support');        
        mail.setSubject('SF-182 Form - Approved');
        
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
  //      mail.setUseSignature(false);
        
        // Specify the text content of the email.
        mail.setPlainTextBody('A new SF-182 form has been approved.  Please see form attached to this email.');        
        mail.setHtmlBody('A new SF-182 form has been approved.  Please see form attached to this email.');
        
        // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('attachment.pdf');
            efa.setBody(b);
            
        // Add attachment to email message
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        //update form showing message sent
        forms__c form = [select id, Form_emailed_to_Cincinnati__c from forms__c where id = :formID limit 1];
        form.Form_emailed_to_Cincinnati__c = true;
        update form;
    
    }
}