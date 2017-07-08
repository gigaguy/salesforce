@istest
public class FormPageController_Test {

    @isTest
    static void testGetFormRTs(){
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = '123ABC';
        update u;
        
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = [select id from PermissionSet where Label like '%WebForm User%' limit 1].ID, AssigneeID = u.Id);
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
        User u = [select id from User where isActive = true limit 1];
        u.Session_Token__c = '123ABC';
        update u;
        
        
        Forms__c form = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Forms__c' limit 1].ID);
        form = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Forms__c' limit 1].ID);
        
        FormPageController.submitForApproval(form.ID, '123ABC');
        
        FormPageController.findExistingForms('123ABC');
        
        FormPageController.viewForm(form.ID);
        FormPageController.saveForm(form, '123ABC');
        FormPageController.deleteForm(form.ID, '123ABC');
    }
}