trigger pcValidateApproversBox on Forms__c (before update) {
    Forms__c previousForm;
    String fieldName;
    ID pcRecordTypeID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
    
    //for each form that is being approved, check to see if the user fill in the appropriate information
    for(Forms__c form : trigger.new) 
    {
        System.debug('Start of pcValidateApproversBox');
        previousForm = Trigger.oldMap.get(form.id);
        
        if(previousForm.Approval_Step__c != form.Approval_Step__c && form.RecordTypeId == pcRecordTypeID &&
           (form.Approval_Step__c == 'Awaiting Purchase Card Manager Approval' || form.Approval_Step__c == 'Awaiting Division Director/Manager Approval') )  
        {
            if(form.Approval_Step__c == 'Awaiting Division Director/Manager Approval' && (form.I_Agree_with_Terms_Approver_1__c == false || form.Business_Justification__c == null))
            {
                fieldName = Schema.Forms__c.fields.I_Agree_with_Terms_Approver_1__c.getDescribe().getLabel();
                form.addError('This form cannot be approved because it is missing information. Please make sure to read the Purchase Card Instructions and indicate that you agree by selecting the "I Agree with Terms (Approver 1)" box. Also please complete the businsess justification field before attempting to select the Approve button.');
            }
            
            if(form.Approval_Step__c == 'Awaiting Purchase Card Manager Approval' && form.I_Agree_with_Terms_Approver_2__c == false)
            {
                fieldName = Schema.Forms__c.fields.I_Agree_with_Terms_Approver_2__c.getDescribe().getLabel();
                form.addError('This form cannot be approved because it is missing information. Please make sure to read the Purchase Card Instructions and indicate that you agree by selecting the "I Agree with Terms (Approver 2)" box before attempting to select the Approve button.');
            }
            
            if(form.Approval_Step__c == 'Awaiting Purchase Card Manager Approval' && form.I_Agree_with_Terms_Approver_1__c == false)
            {
                fieldName = Schema.Forms__c.fields.I_Agree_with_Terms_Approver_1__c.getDescribe().getLabel();
                form.addError('This form cannot be approved because it is missing information because "I Agree with Terms (Approver 1)" box has been unselected.');
            }

        }
    }
}