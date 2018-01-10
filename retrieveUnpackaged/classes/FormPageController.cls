public class FormPageController {
    @auraEnabled
    public static List<RecordType> getFormRTs(string sID){
        //query for permissionsetassignments for this user
        User u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];        
        Set<id> psIds = new Set<id>();
        for (PermissionSetAssignment psa : [select id, PermissionSetId from PermissionSetAssignment where AssigneeId = :u.Id]){
            psIds.add(psa.PermissionSetID);
        }
        
        Set<string> formNames = new Set<String>();
        for (PermissionSet ps : [select id, Label from PermissionSet where id in :psIDs]){
            
            formNames.add(ps.label.removeStart('BAPForms User - '));
            //hardcoding EPA-100 for all users
            formNames.add('EPA-100');
        }
        return [select id, Name, Description from RecordType where sObjectType = 'Forms__c' and IsActive = true and Name in :formNames];
    }
    
    @AuraEnabled
    public static List<Forms__c> findExistingForms(string sID){
        Forms__c existingForm;
        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
            
            return [select id, Name, Form_Type_Name__c, Approval_Step__c, CreatedDate, LastModifiedDate, AWL_Phone_Number__c, User_Supervisor__c from Forms__c where Unauthenticated_Owner__c = :u.ID order by CreatedDate DESC];
        }
        catch (exception e){}        
        return null;
    }
    
    @AuraEnabled
    public static Forms__c viewForm(string formID){
        forms__c form = [select id, name, Approval_step__c from Forms__c where id = :formID limit 1];
        if(form.approval_step__c != null){
        if(string.valueOf(form.approval_step__c).startsWith('Form Prepared for you')){
            form.approval_step__c = null;
            update form;}
          }
        return form;        
    }
    
    @AuraEnabled
    public static Forms__c insertNewForms(string sID, string rtID, String formOption){

        string rtName = '';
        if(formOption!=null && formOption!='' && rtID=='Purchase Card'){
            rtName = 'Purchase_Card';
        }else{
			rtName = [select id, developerName from recordtype where id = :rtID limit 1].developerName;            
        }        
        Forms__c existingForm;
        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];            
            /*existingForm = [select id, Approval_step__c, AWL_Phone_Number__c, User_Supervisor__c from Forms__c where RecordTypeId = :rtID and Unauthenticated_Owner__c = :u.ID and Approval_Step__c != 'Approved' order by CreatedDate DESC limit 1];
            if (existingForm != null) return existingForm;*/
        }
        catch (exception ex){
        }
        try{
            
            //no existing form
            if (u != null){
                Forms__c nf = new Forms__c();
                
                nf.put('Unauthenticated_Owner__c', u.id);
                if(rtName != 'SF_182') nf.put('User_Supervisor__c', u.Supervisor__c);
                // Pre populate user detials for the purchase card form
                if(rtName != null && (rtName == 'Purchase_Card')){                    
                    prePopulatePruchaseCardDetails(nf, u,formOption);                    
                    if(formOption!=null){
						nf.put('Purchase_Card_Request_Type__c',formOption);                        
                    }
                }else{
                    nf.put('RecordTypeId', rtID);
                }                                
                nf.put('Quantity__c', 1);
                insert nf;
                System.debug('newForms'+nf);
                return nf;
            }
        }
        catch(DMLException ex){
           AuraHandledException e = new AuraHandledException(ex.getMessage() + ' - ' + string.valueOf(ex.getLineNumber()));
            system.debug(ex.getMessage());
           throw e;
        }
        return null;        
    }
    
    @AuraEnabled
    public static string deleteForm(ID formID, string sID){
        delete [select id from Forms__c where ID = :formID];        
        return 'Form Deleted';
    }
    
    @AuraEnabled
    public static string saveForm(Forms__c sentForm, string sID){
        String message = 'Saved';
        try{
            upsert sentForm;
            return message;
        }
        catch(exception ex){
            message = ex.getMessage();
            return message;
        }
    }
    
    @AuraEnabled
    public static string submitForApproval(ID formID, string sID, string recordTypeId){
        String message = 'Not Submitted - Please check that all your approvers are set and try again';
        try{
            system.debug(formId);
            User u = null;
            // For all purchase cards forms requestors, requestor should be the submittor
            if(UtilityMethods.isPurchaseCardFormId(recordTypeId)){
              u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
            }else{
              u = [select id from User where Name = 'EPA Business Automation Platform User' limit 1];    
            }
                        
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Automatically Submitted');
            req1.setObjectId(formId);
            //req1.setSubmitterId('00535000000VAA9');
            req1.setSubmitterID(u.ID);
            Approval.ProcessResult result = Approval.process(req1);
            if (result.IsSuccess()) message = 'Submitted';
            return message;
        }
        catch(exception ex){
            message = string.valueof(ex);
            return message;
        }
    }

    @AuraEnabled
    public static List<BAP_Fill_and_Print_List__mdt> getFandP_FormRTs(){
                
          return [select Label, Description__c, File_Url__c from BAP_Fill_and_Print_List__mdt ORDER BY Label ASC];
          
    }
    
    /**
     * This method return list of options for a given form type id
     * */
    @AuraEnabled
    public static List<String> getAllFormOptions(String formTypeId){
        //Right now we are not using the form record type id.
        List<String> formOptions = null;
		Schema.DescribeFieldResult formPickList = Forms__c.Purchase_Card_Request_Type__c.getDescribe();    
		List<Schema.PicklistEntry> listValues = formPickList.getPicklistValues();
        if(listValues.size()>0){
            formOptions = new List<String>();
            for(Schema.PicklistEntry pEntry : listValues){
                if(pEntry.isActive()){
	                formOptions.add(pEntry.getValue());                    
                }
            }
        }
        return formOptions;
	}
    @AuraEnabled
    public static String getFormIntroduction(String formName){
        String introText = '';
        if(formName!=null){
            try{
                Map<String,String> pcPageLayouts = UtilityMethods.getPCRequestRecordTypeMappings();
	            String recordType = pcPageLayouts.get(formName);
                if(recordType!=null){
                    formName = recordType;
                }
				Instructions__c instructions = null;
	            instructions = [select Id, InstructionContent__c from Instructions__c where ParentRecordType__c = :formName];
                introText = instructions.InstructionContent__c;
            }catch(Exception e){
                System.debug('getFormIntroduction');
            }
            //introText = '<p>As a reminder with a revision, the moratorium is still in effect on the issuance of new purchase card and convenience check accounts.</p> <p>For those instances where establishing a new account is mission critical, the cognizant senior resource official and/or Division Director must submit a written justification, explaining that mission criticality, to the EPA National Purchase Card Program Manager (NPCPM) Mr. Brian Long. </p> <p>Authorizations may be granted on an exception basis. </p> <p>Reminder: Refer to <a href="http://purchasecard.epa.gov">http://purchasecard.epa.gov</a> Important Reminders About Existing Agency Purchase Card Policy that are in effect and remain unchanged. </p> <p>The EPA Acquisition Guide (EPAAG) section 13.3.1 was posted in December 2015 which includes the latest policy for the purchase card program and is located at <a href="https://oamintra.epa.gov/EPAAG">https://oamintra.epa.gov/EPAAG</a>. </p>  <p>The EPA purchase card program provides an efficient and convenient way of buying commercial/off the shelf goods and services in order to meet the Agency mission. However, it is essential that cardholders and approving officials ensure that all purchases made with the purchase card comply with the rules and regulations, and that proper documentation is completed to justify all purchase card transactions. </p> <p>Please note that purchase card and/or convenience check misuse will result in either suspension or rescission of an Approving Official and/or Purchase Cardholder delegation of authority. </p> <p>All cardholders and approving officials are responsible for ensuring appropriate use of purchase cards. Please communicate this information to your subordinates and stress that you will personally hold purchase cardholders accountable for proper use of the purchase card. Approving Officials will also be held accountable for proper review and authorization of their purchase cardholder transactions and records. </p> <p>The Office of Acquisition Management provides this Purchase Card Web Site for cardholders. Before disputing any purchase card transaction please review the appropriate guidelines. </p> <p>SP2 JPMC Bank (Fleet): Dispute Guidelines Customer Service:(888)297-0781 SP2 JPMC Bank (Purchase): Dispute Guidelines Customer Service:(888)297-0781</p><p>Purchase Card Program issues: Dianne Lyles (202)564-6111</p><p>Fleet Card Program issues: Bryford Metoyer (202)564-0310</p><p>Allocation and Finance issues: Cynthia Spadaro (513)487-2069</p>';
        }
        return introText;
    }
    /**
     * 
     *  This method prepopulate all user detials in  the form record.
     * */
    private static void prePopulatePruchaseCardDetails(Forms__c form, User user, String pcType){
        
        try{
            user = [select id, Name,EmployeeNumber,LAN_ID__c,Phone, MobilePhone,Email,street, PostalCode, Mail_Stop__c, city,state, country, Supervisor__c from User where Id = :user.Id];
            Contact cont = [Select Id, Name, AccountId  from Contact where LAN_ID__c = :user.LAN_ID__c];
            Map<String,String> pcPageLayouts = UtilityMethods.getPCRequestRecordTypes();
            String recordType = pcPageLayouts.get(pcType);
            if(recordType!=null){
                form.put('RecordTypeId', recordType);
            }
            // Marking the user id as the owner
            //form.put('OwnerId', user.Id);
			form.put('EIN__c', (user.EmployeeNumber!=null?user.EmployeeNumber:''));
            form.put('Mailing_Address__c', (user.street!=null?user.street:''));
            form.put('City__c', (user.city!=null?user.city:''));
            form.put('State__c', (user.state!=null?user.state:''));
			form.put('Mail_Code__c', (user.Mail_Stop__c!=null?user.Mail_Stop__c:''));           
            form.put('Zip__c', (user.PostalCode!=null?user.PostalCode:''));            
            form.put('Email_Address__c',(user.Email!=null?user.Email:''));
            form.put('Purchase_Card_Request_Type__c', pcType);            
            if(cont != null){
				form.put('Cardholder_AO_Name__c', cont.Id);
                form.put('Cardholder_AO_Display_Name__c', cont.Name);
	            form.put('HR_Organization__c', cont.AccountId);                
            }            
			//form.put('Approval_Step__c','0');
            String phoneNumber = user.Phone;
            if(phoneNumber == null){
                phoneNumber = user.MobilePhone;
            }            
            form.put('Telephone_Number__c', (phoneNumber!=null?phoneNumber:''));
        }catch(Exception e){
            System.debug('Exception - prePopulatePruchaseCardDetails - '+string.valueof(e));
        }        
    }
}