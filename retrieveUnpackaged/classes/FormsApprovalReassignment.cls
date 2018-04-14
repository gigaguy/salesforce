public class FormsApprovalReassignment {   
    
    public static void FormsApprovalReassignment() {
     Boolean needsUpdate;
     String oldApproverName;
     String newApproverName;
     User oldApprover;
     Group oldApproverGroup;
     User newApprover;
     Group newApproverGroup; 
        
        list<ProcessInstanceStep> Psteps = [SELECT Id, StepStatus, ProcessInstanceId, ProcessInstance.TargetObjectId 
                                             FROM ProcessInstanceStep 
                                             WHERE stepstatus = 'Reassigned'
                                               AND ProcessInstance.status = 'Pending'];
        
        list<id> PstepIDs = new list<id>();
            for(ProcessInstanceStep Pstep : Psteps){
                PstepIDs.add(Pstep.ProcessInstance.TargetObjectId);
               }
            system.debug('PstepIDs: '+PstepIDs);
        
       list<forms__c> theForms = [select id, Finalize_Approval_Reassignment__c, Last_Approval_Reassignment__c 
                                    FROM forms__c 
                                    WHERE ID in :PstepIDs
                                      AND Finalize_Approval_Reassignment__c = false];
            system.debug('theForms: '+theForms);
 
        system.debug('pstep size: '+PstepIDs.size());    
    
        ProcessInstanceWorkItem Pitem = new ProcessInstanceWorkItem();
        
        for(forms__c theForm : theForms){
              Pitem = [SELECT ActorID, OriginalActorId, ProcessInstanceID, ProcessInstance.TargetObjectId 
                    FROM ProcessInstanceWorkItem
                    WHERE ProcessInstance.Status = 'Pending' 
                       AND ProcessInstance.TargetObjectId = :theForm.ID limit 1];        
                system.debug('Original Actor: '+Pitem.OriginalActorId);
        
            if(string.valueOf(Pitem.OriginalActorId).left(3)=='00G'){   //checks if approver is group/queue
                 oldApproverGroup = [Select id, name From Group Where ID = :Pitem.OriginalActorId Limit 1]; 
                oldApproverName = oldApproverGroup.name;
            }
                else{    
         oldApprover = [Select id, firstname, lastname From User Where ID = :Pitem.OriginalActorId Limit 1]; 
            oldApproverName = oldApprover.FirstName+' '+oldApprover.LastName;
                }
                
            if(string.valueOf(Pitem.ActorID).left(3)=='00G'){    //checks if new approver is group/queue
                newApproverGroup = [Select id, name From Group Where ID = :Pitem.ActorId Limit 1]; 
                newApproverName = newApproverGroup.name;
            }
            else{ 
                newApprover = [Select id, firstname, lastname From User Where ID = :Pitem.ActorID Limit 1];
                newApproverName = newApprover.FirstName+' '+newApprover.LastName;
                  }
        
        needsUpdate = theForm.Last_Approval_Reassignment__c == null || (theForm.Last_Approval_Reassignment__c != null && theForm.Last_Approval_Reassignment__c.IndexOf('Reassigned from ' + oldApproverName + ' to ' + newApproverName +' on ')<0);
          system.debug('needsUpdate? '+needsUpdate);
        
            if(needsUpdate){theForm.Finalize_Approval_Reassignment__c=true;
              update theForm;
                 }
        
        }    //end of for loop
    
        system.debug('FormsApprovalReassignment finished');
    }
}