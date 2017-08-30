public with sharing class POTWDisplayController {
    private final POTW_Facility__c fac;
    private ApexPages.StandardController controller;
    public Boolean surveyAlreadySent {get;set;}
    public Boolean enableForm {get;set;}
    
    public POTWDisplayController(ApexPages.StandardController pController) {
        this.fac = (POTW_Facility__c)pController.getRecord();
        this.controller = pController;
        if (fac.Email_Address__c != null) {
            surveyAlreadySent = true;
            enableForm = false;
        }
        else {
            surveyAlreadySent = false;
            enableForm = true;
        }
    }
    
    public PageReference submitRequest() {
        Boolean bError = false;
        if (fac.First_Name__c == null) {
            fac.First_Name__c.addError('Please include your first name.');
            bError = true;
        }
        if (fac.Last_Name__c == null) {
            fac.Last_Name__c.addError('Please include your last name.');
            bError = true;
        }
        if (fac.Professional_Title__c == null) {
            fac.Professional_Title__c.addError('Please include your job title.');
            bError = true;
        }
        if (fac.Phone__c == null) {
            fac.Phone__c.addError('Please include your phone number in case we need to contact you.');
            bError = true;
        }
        else if (fac.Phone__c.replaceAll('[^0-9]', '').length() != 10) {
            fac.Phone__c.addError('Please include your full 10-digit phone number in case we need to contact you.');
            bError = true;
        }
        if (fac.Email_Address__c == null) {
            fac.Email_Address__c.addError('Please include your email address so that the survey can be emailed to you.');
            bError = true;
        }
        else if (fac.Email_Address__c.equalsIgnoreCase(fac.Confirm_Email_Address__c) == false) {
            fac.Confirm_Email_Address__c.addError('Your confirmation email address does not match your email address.');
            bError = true;
        }

        if (bError == true) {
            return null;
        }
        else {
            fac.Date_Sent__c = Datetime.now();
            update fac;
            system.debug('ID: '+ fac.id);
            
            //SendEmail(fac.id);   //<---commented out for the WEFTEC demo
            PageReference confirmPage = Page.POTW_Confirmation_Page;
            confirmPage.setRedirect(true); 
            return confirmPage; 
        }
    }

    private void SendEmail(Id facId) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        for (POTW_Facility__c fac : [SELECT Name, First_Name__c, Last_Name__c, Professional_Title__c, Phone__c, Email_Address__c, Questionnaire_Link__c, Address1__c, Address2__c, City__c, State__c, Zip__c, NPDES_ID__c FROM POTW_Facility__c WHERE Id =: facId]){
            String strAddress = fac.Address1__c;
            if (String.isBlank(fac.Address2__c) != true) {
                strAddress += ', ' + fac.Address2__c;
            }
            mail.toAddresses = new String[] { fac.Email_Address__c };
            mail.senderDisplayName = 'EPA';
            mail.subject = 'POTW Screener Questionnaire';
            mail.plainTextBody = 'Hello ' + fac.First_Name__c + ' ' + fac.Last_Name__c + ':' +
            '\nThank you for registering for the National Study of Nutrient Removal and Secondary Technologies: 2016 POTW Screener Questionnaire.' +
            '\n\nBelow is the link to the 2016 POTW Screener Questionnaire for ' + fac.Name + '.\n\n' + 'Link: ' + fac.Questionnaire_Link__c + 
            '\nFacility: ' + fac.Name + '\nAddress: ' + strAddress + '\nCity: ' + fac.City__c + '\nState: ' + fac.State__c + '\nZip: ' + fac.ZIP__c + '\nNPDES ID: ' + fac.NPDES_ID__c +
            '\n\nFirst Name: ' + fac.First_Name__c + '\nLast Name: ' + fac.Last_Name__c + '\nProfessional Title: ' + fac.Professional_Title__c + '\nPhone: ' + fac.Phone__c + '\nEmail: ' + fac.Email_Address__c +
            '\n\nIf you did not register for this link, please contact the EPA POTW Screener Questionnaire Help Line to correct this error:' + 
            '\n\nEastern Research Group, Inc.\nLocal: 703-633-XXXX\nToll-free: 1-xxx-xxx-xxxx\nPOTWhelp@erg.com';
            mail.saveAsActivity = false;    
            if (!Test.isRunningTest()) {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //<--Send email
            }
            else {
                System.Debug('MessagingService called inside a test.');
            }
        }
    }

    public PageReference cancelRequest() {
        controller.cancel(); 
        PageReference POTWSearchPage = Page.POTW_Search_Page;
        POTWSearchPage.setRedirect(true); 
        return POTWSearchPage; 
    }
}