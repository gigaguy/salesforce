public class FormsTriggerHandler {
    public static Boolean isFirstTime = true;
    
    public void beforeInsert(List<Forms__c> forms){
        for (forms__c form : forms){
          //if Type-3 user creating form, sets Type-1 Owner field to that user
          //otherwise, Type-1 user is Type-1 Owner
            if(form.Unauthenticated_Owner__c == null){ 
                form.Unauthenticated_Owner__c = userInfo.getUserID();
              }
              
            //find and set Type-1 Owner Contact  
            try{ 
                string uLan = [select LAN_ID__c from user where ID = :form.Unauthenticated_Owner__c].LAN_ID__c;          
                form.Type_1_Owner_Contact__c = [select id,LAN_ID__c from contact where LAN_ID__c = :uLan limit 1].id;
               }
               catch(Exception e) {       
                    Trigger.new[0].addError('No related Contact record found for User');
               }
          }
        
        updateFormLookups(forms, true);
    }
    
    public void beforeUpdate(Map<id,Forms__c> formMap){
        updateFormLookups(formMap.values(), false);
        
        // (sf-182 / ord-111 processes -- set form owner to person prepared for and then clear Prepare For field
        for (forms__c form : formMap.values()) {
    
            if (form.Approval_Step__c != null) {
                if (form.Prepare_Form_for__c != null && String.valueOf(form.Approval_Step__c).startsWith('Form Prepared for you by')) {
                    contact c = [select id, LAN_ID__c from contact where id = :form.prepare_Form_for__c limit 1];
                    user u = [select id, LAN_ID__c from user where LAN_ID__c = :c.LAN_ID__c limit 1];                    
                    if (form.Unauthenticated_Owner__c == null){
                        form.ownerid = u.id;}                    
                    else {form.Unauthenticated_Owner__c = u.id;}
                    
                    //remove value
                    form.Prepare_Form_for__c = null;
                      }
              }
          }
    }
    
    private void updateFormLookups(List<Forms__c> forms, boolean onInsert){
        Boolean useContact = Contact_Approvers__c.getValues('Use Contact Fields').Use_Contact__c; // checkbox from "Contact Approvers" Custom Setting
        Set<id> uIds = new Set<id>();
        Set<String> lanIds = new Set<String>();
        Map<id, Contact> contactMap = new Map<id, Contact>();
        if (!onInsert) for (Forms__c form : forms) uIds.add(form.Unauthenticated_Owner__c == null ? form.OwnerID : form.Unauthenticated_Owner__c);
        else for (Forms__c form : forms) uIds.add(form.Unauthenticated_Owner__c == null ? userInfo.getUserID() : form.Unauthenticated_Owner__c);
            
        Map<id, User> userMap = new Map<id, User>([select id, 
                                                            Supervisor__c, 
                                                            Supervisor_2__c, 
                                                            Time_Keeper__c, 
                                                            Training_Officer__c, 
                                                            Funding_Official__c,
                                                            Email,
                                                            LAN_ID__c                   // Lan_ID__c exists on both Users and Contacts, 
                                                                                        // used to match records
                                                        from User where id in :uIDs]);
        
        if(!useContact){ 
        for (forms__c form : forms){ // start update from User fields loop
            //get record type name
              recordtype rt = [select id, developerName from recordtype where id = :form.recordtypeid limit 1];
            
            user u;
            if (!onInsert) u =userMap.get(form.Unauthenticated_Owner__c == null ? form.OwnerID : form.Unauthenticated_Owner__c);
            else u =userMap.get(form.Unauthenticated_Owner__c == null ? userInfo.getUserID() : form.Unauthenticated_Owner__c);
            if (u != null && rt.developerName == 'SF_182'){
                if(form.Prepare_Form_for__c == null){
                    if(form.User_supervisor__c == null && form.Approval_Routing_Options__c != null){form.User_supervisor__c = u.Supervisor__c;}
                    if(form.User_Supervisor_2__c == null && form.Approval_Routing_Options__c != null){form.User_Supervisor_2__c = u.Supervisor_2__c;}
                    if(form.User_Time_Keeper__c == null && form.Approval_Routing_Options__c != null){form.User_Time_Keeper__c = u.Time_Keeper__c;}
                    if(form.User_Training_Officer__c == null && form.Approval_Routing_Options__c != null){form.User_Training_Officer__c = u.Training_Officer__c;}
                    if(form.User_Funding_Official__c == null && form.Approval_Routing_Options__c != null){form.User_Funding_Official__c = u.Funding_Official__c;}
                    if(form.Unlicensed_Owner_Email__c == null && form.Approval_Routing_Options__c != null){form.Unlicensed_Owner_Email__c = u.Email;}
                  }
                else if(form.Prepare_Form_for__c != null){
                 contact prep4U = [select id, Supervisor__c, Supervisor_2__c, Time_Keeper__c, Training_Officer__c, Funding_Official__c, email from contact where id = :form.Prepare_Form_for__c limit 1];
                  if(form.User_supervisor__c == null && form.Approval_Routing_Options__c != null){form.User_supervisor__c = prep4U.Supervisor__c;}
                  if(form.User_Supervisor_2__c == null && form.Approval_Routing_Options__c != null){form.User_Supervisor_2__c = prep4U.Supervisor_2__c;} 
                  if(form.User_Time_Keeper__c == null && form.Approval_Routing_Options__c != null){form.User_Time_Keeper__c = prep4U.Time_Keeper__c;}
                  if(form.User_Training_Officer__c == null && form.Approval_Routing_Options__c != null){form.User_Training_Officer__c = prep4U.Training_Officer__c;}
                  if(form.User_Funding_Official__c == null && form.Approval_Routing_Options__c != null){form.User_Funding_Official__c = prep4U.Funding_Official__c;}
                  if(form.Unlicensed_Owner_Email__c == null && form.Approval_Routing_Options__c != null){form.Unlicensed_Owner_Email__c = prep4U.Email;} 
                 }
               }
            else if (u != null && rt.developerName != 'SF_182'){
                form.User_supervisor__c = u.Supervisor__c;
                form.User_Supervisor_2__c = u.Supervisor_2__c;
                form.User_Time_Keeper__c = u.Time_Keeper__c;
                form.User_Training_Officer__c = u.Training_Officer__c;
                form.User_Funding_Official__c = u.Funding_Official__c;
                form.Unlicensed_Owner_Email__c = u.Email;
                }
            } // end update from User fields loop
        }
        else { // USE Contact records for approvers
         // get related Contacts
            for (user u : userMap.values()) {  // collecting Lan_ID__c values from Users to find matching Contacts
                   lanIds.add(u.Lan_ID__c);
                }
            contactMap.putAll([select id, 
                                Supervisor__c, 
                                Supervisor_2__c, 
                                Time_Keeper__c, 
                                Training_Officer__c, 
                                Funding_Official__c,
                                Email,
                                LAN_ID__c 
                            from Contact where Lan_ID__c in :lanIDs]);
                            
        Map<string,id> lanMap = new Map<string,id>();    // Map of Lan_ID__c and Contact to match with Users (Form owners)
        for (contact c : contactMap.values()) lanMap.put(c.Lan_ID__c, c.id);       
        for (forms__c form : forms){ // start update from Contact fields loop
            recordtype rt = [select id, developerName from recordtype where id = :form.recordtypeid limit 1];
            
            User u;
            Contact c;
            String lan;
            if (!onInsert) u =userMap.get(form.Unauthenticated_Owner__c == null ? form.OwnerID : form.Unauthenticated_Owner__c);
            else u =userMap.get(form.Unauthenticated_Owner__c == null ? userInfo.getUserID() : form.Unauthenticated_Owner__c);
            lan = lanMap.get(u.Lan_ID__c);  // gets Contact ID based on Lan_ID__c
            c = contactMap.get(lan);
            if (c != null && rt.developerName == 'SF_182'){
              if(form.Prepare_Form_for__c == null){
                if(form.User_supervisor__c == null && form.Approval_Routing_Options__c != null){form.User_supervisor__c = c.Supervisor__c;}
                if(form.User_Supervisor_2__c == null && form.Approval_Routing_Options__c != null){form.User_Supervisor_2__c = c.Supervisor_2__c;} 
                if(form.User_Time_Keeper__c == null && form.Approval_Routing_Options__c != null){form.User_Time_Keeper__c = c.Time_Keeper__c;}
                if(form.User_Training_Officer__c == null && form.Approval_Routing_Options__c != null){form.User_Training_Officer__c = c.Training_Officer__c;}
                if(form.User_Funding_Official__c == null && form.Approval_Routing_Options__c != null){form.User_Funding_Official__c = c.Funding_Official__c;}
                if(form.Unlicensed_Owner_Email__c == null && form.Approval_Routing_Options__c != null){form.Unlicensed_Owner_Email__c = c.Email;}
               }
              else if(form.Prepare_Form_for__c != null){
               contact prep4U = [select id, Supervisor__c, Supervisor_2__c, Time_Keeper__c, Training_Officer__c, Funding_Official__c, email from contact where id = :form.Prepare_Form_for__c limit 1];
                if(form.User_supervisor__c == null && form.Approval_Routing_Options__c != null){form.User_supervisor__c = prep4U.Supervisor__c;}
                if(form.User_Supervisor_2__c == null && form.Approval_Routing_Options__c != null){form.User_Supervisor_2__c = prep4U.Supervisor_2__c;} 
                if(form.User_Time_Keeper__c == null && form.Approval_Routing_Options__c != null){form.User_Time_Keeper__c = prep4U.Time_Keeper__c;}
                if(form.User_Training_Officer__c == null && form.Approval_Routing_Options__c != null){form.User_Training_Officer__c = prep4U.Training_Officer__c;}
                if(form.User_Funding_Official__c == null && form.Approval_Routing_Options__c != null){form.User_Funding_Official__c = prep4U.Funding_Official__c;}
                if(form.Unlicensed_Owner_Email__c == null && form.Approval_Routing_Options__c != null){form.Unlicensed_Owner_Email__c = prep4U.Email;}
               }
            }
            else if (c != null && rt.developerName != 'SF_182'){
                form.User_supervisor__c = c.Supervisor__c;
                form.User_Supervisor_2__c = c.Supervisor_2__c;
                form.User_Time_Keeper__c = c.Time_Keeper__c;
                form.User_Training_Officer__c = c.Training_Officer__c;
                form.User_Funding_Official__c = c.Funding_Official__c;
                form.Unlicensed_Owner_Email__c = c.Email;
            }
        } // end update from Contact fields loop
        }    
    }
    
    public void afterUpdate(Map<id,Forms__c> formMap){
        if(isFirstTime){
        isFirstTime = false;
        system.debug('in after update');
        //get sf-182 record type
            ID rtID = [SELECT Id,Name FROM RecordType WHERE name = 'SF-182' limit 1].id;
            
        for (forms__c form : formMap.values()) {
                if(form.Approval_Step__c != 'Approved'){
                    system.debug('approval step does not equal approved');
                    createFormShares(formMap.keyset());
                  }  
            //send email to cincinatti for approved SF-182 forms       
            system.debug('cin check: '+form.Approval_Step__c);
                    if(form.Approval_Step__c == 'Approved' && form.RecordTypeID == rtID){
                         SF_182_SendEmailWithAttachments.sendMessage(form.id);  
                    if(!form.Form_emailed_to_Cincinnati__c){
                        SF_182_SendCincinnatiEmail.sendMessage(form.id);  
                       }                   
                    }
                }
        
               ////////////////////////////////////////////////////////////////////////
               //         /*List<Forms__Share> formShares = new List<Forms__Share>();
               //         for (id formID : formIdToPeopleIds.keyset()){
               //             Set<id> usedPeople = new Set<id>();
               //             for (id personID: formIdToPeopleIds.get(formId)){
               //                 if (!usedPeople.contains(personid)){
               //                     formShares.add(new Forms__Share(ParentID = formId, UserorGroupID = personid, AccessLevel = 'edit'));
               //                     usedPeople.adD(personId);
               //                 }
               //             }
               //         }
               //         
               //         database.insert(formShares, false);*/
               ///////////////////////////////////////////////////////////////////////////
        }
    }
    
    @future
    // Shares Form record with Approvers
    public static void createFormShares(Set<id> mainIds){
        List<ProcessInstance> processInstances = [SELECT Id, (SELECT Id, ActorID,TargetObjectId, isPending, StepStatus, Comments FROM StepsAndWorkitems) FROM ProcessInstance where TargetObjectId in :mainIds];
        system.debug('pis: ' + processInstances);
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