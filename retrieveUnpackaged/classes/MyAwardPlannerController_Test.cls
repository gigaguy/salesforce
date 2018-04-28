/**
 * Test methods for MyAwardPlannerController.
 */

@IsTest
public with sharing class MyAwardPlannerController_Test {
    @TestSetup
    public static void setupTestData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-ABC-DEF-GHI');
        insert hrOrg;

        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        insert testAwardeeSupervisor;

        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        insert testIoaaSupervisor;

        List<Contact> employees = new List<Contact>();
        for(Integer i = 0; i < 3; i++) {
            Contact employee = AwardTestUtilities.createEmployee(hrOrg);
            employee.LastName = 'LastName' + i;
            employee.Supervisor__c = testAwardeeSupervisor.Id;

            employees.add(employee);
        }
        insert employees;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 20000);
        insert budget;

        List<Award__c> awards = new List<Award__c>();
        for(Contact employee : employees) {
            Award__c award = AwardTestUtilities.createAward(employee);
            award.OwnerId = UserInfo.getUserId();
            award.IOAA_Approver__c = testIoaaSupervisor.Id;
            award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
            award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
            award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
            award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
            award.Budget__c = budget.Id;
            award.Cash_Award_Amount__c = 1000;

            awards.add(award);
        }
        insert awards;
    }

    @IsTest
    public static void testLoadAndSave() {
        Test.startTest();
        PageReference pageRef = Page.AwardsPlanner;
        Test.setCurrentPageReference(pageRef);

        MyAwardPlannerController controller = new MyAwardPlannerController();
        controller.getPlannedAwards(UserInfo.getUserId());
        controller.save();
        Test.stopTest();
    }

    @IsTest
    public static void testLoadWithMultipleBudgets() {
        Account newHrOrg = AwardTestUtilities.createOrganization('ORD-ZYX-WVU');
        insert newHrOrg;

        Document__c newBudget = AwardTestUtilities.createBudget(newHrOrg, 20000);
        insert newBudget;

        Award__c award = [SELECT Id FROM Award__c LIMIT 1];
        award.Budget__c = newBudget.Id;
        update award;

        Test.startTest();
        PageReference pageRef = Page.AwardsPlanner;
        Test.setCurrentPageReference(pageRef);

        MyAwardPlannerController controller = new MyAwardPlannerController();
        controller.getPlannedAwards(UserInfo.getUserId());
        Test.stopTest();
    }

    @IsTest
    public static void testSubmitAward() {
        Test.startTest();
        PageReference pageRef = Page.AwardsPlanner;
        Test.setCurrentPageReference(pageRef);

        MyAwardPlannerController controller = new MyAwardPlannerController();
        controller.getPlannedAwards(UserInfo.getUserId());
        controller.awardsList[0].selected = true;
        controller.awardsList[1].award.Outside_ORD__c = true;
        controller.awardsList[1].selected = true;

        controller.submitAwardsForApproval();
        Test.stopTest();
    }

    @IsTest
    public static void testErrorHandling() {
        Test.startTest();
        PageReference pageRef = Page.AwardsPlanner;
        Test.setCurrentPageReference(pageRef);

        MyAwardPlannerController controller = new MyAwardPlannerController();
        controller.getPlannedAwards(UserInfo.getUserId());
        for(MyAwardPlannerController.AwardWrapper aw : controller.awardsList) {
            aw.award.Cash_Award_Amount__c = 8000;
            aw.selected = true;
        }

        controller.submitAwardsForApproval();
        Test.stopTest();

    }

}