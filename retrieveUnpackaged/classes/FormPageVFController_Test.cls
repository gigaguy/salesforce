@isTest
public class FormPageVFController_Test {

    @isTest
    static void testOnLoad(){
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = '123ABC';
        update u;
        
        Test.setCurrentPageReference(new PageReference('Page.FormPage'));
        System.currentPageReference().getParameters().put('sID', '123ABC');
        
        FormPageVFController controller = new FormPAgeVFController();
        //controller.onLoad();
        controller.validateOrRedirect();
        system.assertEquals(u.ID, controller.UID); 
    }
}