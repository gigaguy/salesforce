public class FormsTriggerHandler {
    public static Boolean isFirstTime = true;   //used in BeforeUpdate
    public static Boolean isFirstTimeAfter = true;   //used in AfterUpdate
    
    public void beforeInsert(List<Forms__c> forms){
        for (forms__c form : forms){
          //if Type-3 user creating form, sets Type-1 Owner field to that user
          //otherwise, Type-1 user is Type-1 Owner
            if(form.Unauthenticated_Owner__c == null){ 
                form.Unauthenticated_Owner__c = userInfo.getUserID();
              }
            form.Originator_Type1__c = form.Form_Owner__c;
            
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
        if(isFirstTime){
        isFirstTime = false;
        updateFormLookups(formMap.values(), false);
        
        // (sf-182 / ord-111 processes -- set form owner to person prepared for and then clear Prepare For field
        for (forms__c form : formMap.values()) {
    
            if (form.Approval_Step__c != null) {
                if (form.Prepare_Form_for__c != null && String.valueOf(form.Approval_Step__c).startsWith('Form Prepared for')) {
                    contact c = [select id, LAN_ID__c from contact where id = :form.prepare_Form_for__c limit 1];
                    user u = [select id, LAN_ID__c from user where LAN_ID__c = :c.LAN_ID__c limit 1];                    
                    if (form.Unauthenticated_Owner__c == null){
                        form.ownerid = u.id;}                    
                    else {form.Unauthenticated_Owner__c = u.id;                          
                        }
                    //update Type 1 Owner Contact    
                    form.Type_1_Owner_Contact__c = c.id;
                    //remove value
                    form.Prepare_Form_for__c = null;
                      }
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
        if(isFirstTimeAfter){
        isFirstTimeAfter = false;
        system.debug('in after update');
        system.debug('isFirstTimeAfter: '+isFirstTimeAfter);
        //get sf-182 record type
            Id rtID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('SF-182').getRecordTypeId();
            system.debug('sf-182 rt: '+rtID);
            
        for (forms__c form : formMap.values()) {
                if(form.Approval_Step__c != 'Approved'){
                    system.debug('approval step does not equal approved');
                    createFormShares(formMap.keyset());
                  }                
            }
        }
    }
    
    @future
    // Shares Form record with Approvers
    public static void createFormShares(Set<id> mainIds){
        isFirstTimeAfter = false;
        id delAppID;
        
        //unlock record on submittal
        list<string> formTypes = new list<string>();
        formTypes.add('SF-182');
        formTypes.add('EPA-100');
        formTypes.add('ORD-111');
        formTypes.add('EPA-3160-6v5');
        
        forms__c[] formList = [select id, Approval_Step__c, Form_Type_Name__c from forms__c where id in :mainIds AND Approval_Step__c != 'Approved' AND Form_Type_Name__c in :formTypes];
     
        Approval.UnlockResult[] formUnlocks = Approval.Unlock(formList, false);
        
        //gets approval process info for Form(s)
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
                //get delegated approver
                try{
                delAppID = [select id, DelegatedApproverID from user where id = :personID limit 1].DelegatedApproverID;
                    }
                catch(exception e){system.debug(e);}
                    if(delAppID != null){
                    personIds.add(delAppID);
                    }
            }
        }
        
        //shares form(s) with approvers
        List<Forms__Share> formShares = new List<Forms__Share>();
        for (Integer i = 0; i < formIds.size();i++){
              formShares.add(new Forms__Share(ParentID = formIds[i], UserorGroupID = personids[i], AccessLevel = 'edit'));
          }
        database.insert(formShares, false);
        
        //shares line item(s) with approvers
        list<line_item__c> litems = new list<line_item__c>();
        list<line_item__Share> lineShares = new list<line_item__Share>();
        for (Integer b = 0; b < formIds.size();b++){
             try{litems = [select id from line_item__c where related_Form__c = :formIds[b]];}
             catch(exception e){system.debug('No related Line Items.');}
             if(litems.size()>0){
                 for(line_item__c litem : litems){
                 lineShares.add(new line_item__Share(ParentID = litem.id, userorGroupID = personids[b], AccessLevel = 'edit'));         
             }            
           }
         }   
        database.insert(lineShares, false);
        
        //Approver reassigned
            List<forms__c> forms = [select id, name, Approval_Step__c, Form_Type_Name__c, Unauthenticated_Owner__c, Finalize_Approval_Reassignment__c 
            FROM forms__c WHERE id in :mainIds];
            
            for(forms__c form : forms){    
            
        if(form.Finalize_Approval_Reassignment__c && form.Approval_Step__c != null){   
            ProcessInstanceWorkItem Pitem = [SELECT ActorID, OriginalActorId 
            FROM ProcessInstanceWorkItem
            WHERE ProcessInstance.Status = 'Pending' AND ProcessInstance.TargetObjectId = :form.ID limit 1];
            system.debug('Pitem: '+Pitem);
            
          if(Pitem.ActorID != Pitem.OriginalActorId) { 
            string lanID = [select lan_id__c from user where id = :form.Unauthenticated_Owner__c limit 1].lan_id__c;
            contact ct = [select id, email from contact where lan_id__c = :lanID limit 1];
            
            Schema.SObjectType actorToken = Pitem.ActorID.getSObjectType();            
            string drActor = actorToken .getDescribe().getName();

            Schema.SObjectType oActorToken = Pitem.OriginalActorID.getSObjectType();            
            string drOActor = oActorToken.getDescribe().getName();
            
            system.debug('actor desc: '+drActor);
            system.debug('Orig actor desc: '+drOActor);
            
            string oldApproverName;
            string newApproverName;
            
            if(drActor == 'User'){
            user newApprover = [Select id, email, firstname, lastname From User Where ID = :Pitem.ActorID Limit 1];
            newApproverName = newApprover.FirstName+' '+newApprover.LastName;
            }
            else {
            group newApprover = [Select id, name from group where id = :Pitem.ActorID limit 1];
            newApproverName = newApprover.Name;
            }
            
            if(drOActor == 'User'){
            user oldApprover = [Select id, email, firstname, lastname From User Where ID = :Pitem.OriginalActorId Limit 1]; 
            oldApproverName = oldApprover.FirstName+' '+oldApprover.LastName;
            }
            else {
            group oldApprover = [Select id, name from group where id = :Pitem.OriginalActorId limit 1];
            oldApproverName = oldApprover.Name;
            }
            
            string timeNow;
            if(system.now().minute() < 10){
               timeNow = system.now().hour()+':0'+system.now().minute(); 
                }
             else {timeNow = system.now().hour()+':'+system.now().minute();} 
        
            form.Finalize_Approval_Reassignment__c = false;
            form.Last_Approval_Reassignment__c = 'Reassigned from ' + oldApproverName + ' to ' +
                 newApproverName +' on ' + 
                 system.now().month()+'/'+system.now().day()+'/'+system.now().year() + ' at ' +
                 timeNow;
                
            update form;
            
            //send notification email to originator            
            string[] toAddress = new String[] {ct.email};
            
            Messaging.reserveSingleEmailCapacity(2);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
            mail.setSenderDisplayName('BAP Approval Notification');            
            ID templateId = [Select id from EmailTemplate where name = 'Notify Form Owner Approver Reassigned' limit 1].id;
            mail.setWhatId(form.id);
            mail.setTargetObjectId(ct.id);
            mail.setTemplateID(templateId);
            mail.setToAddresses(toAddress);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            
           }     //END  if ActorID != OriginalActorId    
               else {form.Finalize_Approval_Reassignment__c = false;
                      update form;}       
         }     // END if Finalize_Approval_Reassignment__c is checked AND form was submitted
         if(form.Finalize_Approval_Reassignment__c && form.Approval_Step__c == null){
             form.Finalize_Approval_Reassignment__c = false;
             update form;
             }
      }    //END forms__c loop
   }    //END createFormShares method
}