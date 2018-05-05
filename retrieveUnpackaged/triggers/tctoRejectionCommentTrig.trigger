/* Author: 			Trellis Sherman
 * Email:  			trellis.sherman@csra.com
 * 
 * Test Class:		tctoRejectionCommentTrig_Test
 * 
 * Description: 	An Apex Trigger to prevent an Approver from rejecting a TCTO form without providing a reason
 * 
 */
trigger tctoRejectionCommentTrig on Forms__c (before update) {
    
    Forms__c oldForm;
    map<ID, Forms__c> rejectedTCTOList = new map<ID, Forms__c>();
    ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
    
    //Get the list of recently rejected TCTO records
    for(Forms__c form: Trigger.new)
    {
        oldForm = Trigger.oldMap.get(form.Id);
        
        if(form.approval_step__c == 'Rejected' && form.approval_step__c != oldForm.approval_step__c && form.RecordTypeId == tctoFormID)
        {
            rejectedTCTOList.put(form.id,form);
        }
    }
    
    if(rejectedTCTOList.isEmpty() == false && rejectedTCTOList.size() > 0)
    {
        //Find the most recent Approval Process for all rejected TCTO Forms
        List<Id> processInstanceIds = new List<Id>{};
            
            for (Forms__c form : [SELECT (SELECT ID
                                          FROM ProcessInstances
                                          ORDER BY CreatedDate DESC
                                          LIMIT 1)
                                  FROM Forms__c
                                  WHERE ID IN :rejectedTCTOList.keySet()])
        {
            processInstanceIds.add(form.ProcessInstances[0].Id);
        }
        
        //For each process, check to see if the comment is null
        for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1 )
                                   FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC])   
        {                   
            if ((pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0))
            {
                rejectedTCTOList.get(pi.TargetObjectId).addError(
                    'TCTO Rejection Action Cancelled! -- Please provide a rejection reason!');
            }
        }  
    }
    
}