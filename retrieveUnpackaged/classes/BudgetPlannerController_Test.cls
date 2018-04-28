/**
 * Methods for testing the BudgetPlannerController and BudgetPlanner Visualforce page.
 */

@IsTest
public with sharing class BudgetPlannerController_Test {

    @TestSetup
    public static void setupTestData() {
        List<Account> hrOrgs = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            Account hrOrg = AwardTestUtilities.createOrganization('ORD-ABC-' + i);
            hrOrgs.add(hrOrg);
        }
        insert hrOrgs;

        List<Document__c> budgets = new List<Document__c>();
        for (Account hrOrg : hrOrgs) {
            Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
            budgets.add(budget);
        }
    }

    @IsTest
    public static void testLoadAndSave() {
        Test.startTest();
        PageReference pageRef = Page.BudgetPlanner;
        Test.setCurrentPageReference(pageRef);

        BudgetPlannerController controller = new BudgetPlannerController();
        controller.getBudgets();
        controller.save();
        Test.stopTest();
    }
}