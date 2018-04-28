/**
 * Methods for testing
 */
@IsTest
public with sharing class SubmitForApprovalController_Test {
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

        Contact employee = AwardTestUtilities.createEmployee(hrOrg);
        employee.Supervisor__c = testAwardeeSupervisor.Id;
        insert employee;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 20000);
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.OwnerId = UserInfo.getUserId();
        award.IOAA_Approver__c = testIoaaSupervisor.Id;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Budget__c = budget.Id;
        award.Cash_Award_Amount__c = 1000;
        insert award;
    }

    @IsTest
    public static void testSubmit() {
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Award__c]);
        SubmitForApprovalController controller = new SubmitForApprovalController(sc);
        controller.submitSingleAward();
        Test.stopTest();
    }

    @IsTest
    public static void testSubmittingOutsideOrdAward() {
        Award__c award = [SELECT Id FROM Award__c];
        award.Outside_ORD__c = true;
        update award;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Award__c]);
        SubmitForApprovalController controller = new SubmitForApprovalController(sc);
        controller.submitSingleAward();
        Test.stopTest();
    }
}