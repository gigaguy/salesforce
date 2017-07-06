public class FormsTriggerHandler {
    public void beforeInsert(List<Forms__c> forms){
        updateFormLookups(forms, true);
    }
    
    public void beforeUpdate(Map<id,Forms__c> formMap){
        updateFormLookups(formMap.values(), false);
    }
    
    private void updateFormLookups(List<Forms__c> forms, boolean onInsert){
        Set<id> uIds = new Set<id>();
        if (!onInsert) for (Forms__c form : forms) uIds.add(form.Unauthenticated_Owner__c == null ? form.OwnerID : form.Unauthenticated_Owner__c);
        else for (Forms__c form : forms) uIds.add(form.Unauthenticated_Owner__c == null ? userInfo.getUserID() : form.Unauthenticated_Owner__c);
            
        Map<id, User> userMap = new Map<id, User>([select id, 
                                                            Supervisor__c, 
                                                            Supervisor_2__c, 
                                                            Time_Keeper__c, 
                                                            Training_Officer__c, 
                                                            Funding_Official__c,
                                                            Email 
                                                        from User where id in :uIDs]);
        
        for (forms__c form : forms){
            user u;
            if (!onInsert) u =userMap.get(form.Unauthenticated_Owner__c == null ? form.OwnerID : form.Unauthenticated_Owner__c);
            else u =userMap.get(form.Unauthenticated_Owner__c == null ? userInfo.getUserID() : form.Unauthenticated_Owner__c);
            if (u != null){
                form.User_supervisor__c = u.Supervisor__c;
                form.User_Supervisor_2__c = u.Supervisor_2__c;
                form.User_Time_Keeper__c = u.Time_Keeper__c;
                form.User_Training_Officer__c = u.Training_Officer__c;
                form.User_Funding_Official__c = u.Funding_Official__c;
                form.Unlicensed_Owner_Email__c = u.Email;
            }
        }
    }
    
    public void afterUpdate(Map<id,Forms__c> formMap){
        
        createFormShares(formMap.keyset());
       
        /*List<Forms__Share> formShares = new List<Forms__Share>();
        for (id formID : formIdToPeopleIds.keyset()){
            Set<id> usedPeople = new Set<id>();
            for (id personID: formIdToPeopleIds.get(formId)){
                if (!usedPeople.contains(personid)){
                    formShares.add(new Forms__Share(ParentID = formId, UserorGroupID = personid, AccessLevel = 'edit'));
                    usedPeople.adD(personId);
                }
            }
        }
        
        database.insert(formShares, false);*/
    }
    
    @future
    public static void createFormShares(Set<id> mainIds){
        List<ProcessInstance> processInstances = [SELECT Id, (SELECT Id, ActorID,TargetObjectId, isPending, StepStatus, Comments FROM StepsAndWorkitems) FROM ProcessInstance where TargetObjectId in :mainIds];
        
        Map<id, List<id>> formIdToPeopleIds = new Map<id, List<id>>();
        for (ProcessInstance pi : processInstances){
            system.debug(pi);
            for (ProcessInstanceHistory pih : pi.StepsAndWorkItems){
                system.debug(pih);
                //if (pih.isPending){
                    if (!formIdToPeopleIds.containsKey(pih.TargetObjectID) ){
                        formIdToPeopleIds.put(pih.TargetObjectId, new List<Id>{pih.ActorId});
                    }
                    else{
                        formIdToPeopleIds.get(pih.TargetObjectId).add(pih.ActorId);                        
                    }
                //}
            }
        }
        system.debug(formIdToPeopleIds);
        List<id> formIds = new List<Id>();
        List<id> personIDs = new List<id>();
        for (id formID : formIdToPeopleIds.keyset()){
            for (id personID: formIdToPeopleIds.get(formId)){
                formIDs.add(formID);
                personIds.add(personID);
            }
        }
        
        List<Forms__Share> formShares = new List<Forms__Share>();
        for (Integer i = 0; i < formIds.size();i++){
            formShares.add(new Forms__Share(ParentID = formIds[i], UserorGroupID = personids[i], AccessLevel = 'edit'));
            
        }
        
        database.insert(formShares, false);
    }
}