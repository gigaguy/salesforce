@istest
public class FormPageController_Test {

    @isTest
    static void testGetFormRTs(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
         u.Session_Token__c = '123ABC';
        update u;
        
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = [select id from PermissionSet where Label like '%BAPForms User%' limit 1].ID, AssigneeID = u.Id);
        try{
            insert psa;
        }
        catch (Exception e){
            system.debug(e.getMessage());
        }
        
        system.assert(FormPageController.getFormRTs('123ABC').size() > 0);
    }
    
    @isTest
    static void testInsertNewForms(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true limit 1];
        User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and id != :u.id limit 1];
        u.Session_Token__c = '123ABC';
        u.Supervisor__c = u2.id;
        u.Supervisor_2__c = u2.id;
        update u;
        
        Forms__c testForm = new Forms__c();
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.RecordTypeID = [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].id;
        insert testForm;
        
        
        Forms__c form = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].ID);     
        form = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Forms__c' limit 1].ID);
        
        Forms__c xform;
        
        try{
            xform = FormPageController.insertNewForms('123ABC', [select id from RecordType where name = 'EPA-100' limit 1].ID);
            }
            catch(exception ex){
                system.debug(ex.getMessage());  
              }
        
        Forms__c yform;
        try{
            yform = FormPageController.insertNewForms('xyz', [select id from RecordType where name = 'EPA-100' limit 1].ID);
            }
             catch(exception ex){
            system.debug(ex.getMessage());  
              }
               
        if (xform.id != null) {FormPageController.submitForApproval(xform.ID, '123ABC'); }  
        FormPageController.submitForApproval(form.ID, '123ABC');         
        FormPageController.findExistingForms('xyz');
        FormPageController.findExistingForms('123ABC');
        FormPageController.viewForm(form.ID);
        FormPageController.viewForm(testForm.ID);
        FormPageController.saveForm(form, '123ABC');
        FormPageController.saveForm(yform, '123ABC');
        FormPageController.deleteForm(form.ID, '123ABC');
        FormPageController.getFandP_FormRTs();
    }
    
    @isTest
    static void testErrorDML(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
         u.Session_Token__c = '123ABC';
        update u;  
    
        try{
          Forms__c zform = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Account' limit 1].ID);
          }
        catch(exception ex){
            system.debug(ex.getMessage());  
          }
      
      }
}