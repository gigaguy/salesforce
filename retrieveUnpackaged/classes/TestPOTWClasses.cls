@isTest
public class TestPOTWClasses {
    public static testMethod void testPOTWDisplayController() {
     
        POTW_Facility__c[] facs = new POTW_Facility__c[]{
            new POTW_Facility__c(Name='Facility 1', Address1__c='Address Line 1', Address2__c='Address Line 2', City__c='Arlington', State__c='VA', Zip__c='22201'),
            new POTW_Facility__c(Name='Facility 2', Address1__c='Address Line 1', Address2__c='Address Line 2', City__c='Alexandria', State__c='VA', Zip__c='22302'),
            new POTW_Facility__c(Name='Facility 3', Address1__c='Address Line 1', Address2__c='Address Line 2', City__c='Manassas', State__c='VA', Zip__c='20110')
            };
        insert facs;      
        ApexPages.StandardController stdController = new ApexPages.StandardController(facs[0]);

        PageReference pageRef = Page.POTW_Search_Page;
        Test.setCurrentPage(pageRef);

        // Test Search Controller Class:
        POTWSearchController searchCtrl = new POTWSearchController();
        String strState = searchCtrl.states[50];
        searchCtrl.sortField = 'InvalidFieldName';
        searchCtrl.runSearch(); // run search with invalid field name to throw error

        searchCtrl.sortField = 'City__c';
        searchCtrl.sortDir = 'desc';
        searchCtrl.toggleSort();
        searchCtrl.runSearch(); // run search with no parameters to run "else" logic

        pageRef.getParameters().put('facname', 'Facility');
        pageRef.getParameters().put('city', 'Arlington');
        pageRef.getParameters().put('state', 'VA');
        pageRef.getParameters().put('zip', '22201');
        pageRef.getParameters().put('npdes', 'VA');
        searchCtrl.runSearch(); // run search with parameters

        // Test Display Controller Class:
        POTWDisplayController displayCtrl = new POTWDisplayController(stdController);

        // Click cancel button and verify that the search page displays:
        String nextPage = displayCtrl.cancelRequest().getUrl();
        System.assertEquals('/apex/potw_search_page', nextPage);

        // Submit form with no fields filled and verify that errors are generated:
        displayCtrl.submitRequest();
        System.assert(Apexpages.hasMessages());

        // Submit with all fields filled except email confirmation and verify that error is generated:
        displayCtrl.fac.First_Name__c = 'FirstName';
        displayCtrl.fac.Last_Name__c = 'LastName';
        displayCtrl.fac.Professional_Title__c = 'Facility Manager';
        displayCtrl.fac.Phone__c = '123-456-7890';
        displayCtrl.fac.Email_Address__c = 'first.last@test.com';
        displayCtrl.submitRequest(); 
        System.assert(Apexpages.hasMessages(), 'Your confirmation email address does not match your email address.');

        // Add missing field (confirmation email) but make phone number invalid and verify that error is generated:
        displayCtrl.fac.Confirm_Email_Address__c = 'first.last@test.com';
        displayCtrl.fac.Phone__c = '123-456-789';
        System.assert(Apexpages.hasMessages(), 'Please include your full 10-digit phone number in case we need to contact you.');

        // Fix phone number and verify that the confirmation page displays:
        displayCtrl.fac.Phone__c = '123-456-7890';
        nextPage = displayCtrl.submitRequest().getUrl();
        System.assertEquals('/apex/potw_confirmation_page', nextPage);
        
        POTWDisplayController reopenDisplayCtrl = new POTWDisplayController(stdController);
     
    }
}