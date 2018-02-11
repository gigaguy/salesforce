trigger pcValidateApproversBox on Forms__c (before update) {
/*
    Forms__c previousForm;
    String fieldName;
    ID pcRecordTypeID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
    
    for(Forms__c form : trigger.new) 
    {
        System.debug('Start of pcValidateApproversBox');
        previousForm = Trigger.oldMap.get(form.id);
        
        if(previousForm.Approval_Step__c != form.Approval_Step__c && form.RecordTypeId == pcRecordTypeID &&
           (form.Approval_Step__c == 'Awaiting Purchase Card Manager Approval' || form.Approval_Step__c == 'Awaiting Division Director/Manager Approval') )  
        {
            if(form.Approval_Step__c == 'Awaiting Division Director/Manager Approval' && form.Confirm_AO_Supervisor__c == false)
            {
                fieldName = Schema.Forms__c.fields.Confirm_AO_Supervisor__c.getDescribe().getLabel();
                form.addError('Form could not be approved! Please check "I Agree" to the '+fieldName+' and approve the form again!');
            }
            
            if(form.Approval_Step__c == 'Awaiting Purchase Card Manager Approval' && form.Confirm_AO_Supervisor__c == false)
            {
                fieldName = Schema.Forms__c.fields.Confirm_AO_Supervisor__c.getDescribe().getLabel();
                form.addError('Form could not be approved! Please check "I Agree" to the '+fieldName+' and approve the form again!');
            }
            
            if(form.Approval_Step__c == 'Awaiting Purchase Card Manager Approval' && form.Confirm_AO_Supervisor__c == false)
            {
                fieldName = Schema.Forms__c.fields.Confirm_AO_Supervisor__c.getDescribe().getLabel();
                form.addError('Form could not be approved! '+fieldName+' cannot be changed');
            }

        }
    }*/
}