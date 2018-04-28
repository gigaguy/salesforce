/**
 * Class and methods for testing the AwardsTriggerHandler class.
 */
@IsTest
public with sharing class AwardTriggerHandler_Test {
    @TestSetup
    public static void createTestData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-ABC-DEF-GHI');
        insert hrOrg;

        Contact employeeContact = AwardTestUtilities.createEmployee(hrOrg);
        insert employeeContact;
    }

    @IsTest
    public static void testSettingDivsionAndBranch() {
        Contact employee = [SELECT Id, Account.Name FROM Contact LIMIT 1];

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;

        Test.startTest();
        try {
            insert award;
        } catch (Exception e) {
            System.debug('Caught a exception on insert with message: ' + e.getMessage());
        }
        Test.stopTest();

        List<String> orgPartStrings = employee.Account.Name.split('-');
        Award__c insertedAward = [SELECT Id, LCO__c, Division__c, Branch__c FROM Award__c WHERE Id = :award.Id];

        System.assertEquals(orgPartStrings[1], insertedAward.LCO__c, 'LCO strings are not the same.');
        System.assertEquals(orgPartStrings[2], insertedAward.Division__c, 'Division strings are not the same.');
        System.assertEquals(orgPartStrings[3], insertedAward.Branch__c, 'Branch strings are not the same.');
    }

    @IsTest
    public static void testBudgetAndContactSettings() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        User testUser = AwardTestUtilities.createTestUser();
        insert testUser;

        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'Supervisor';
        testUserSupervisor.Username = 'test.supervisor@epa.gov.test';
        insert testUserSupervisor;

        Contact relatedUserContact = new Contact();
        relatedUserContact.User__c = testUser.Id;
        relatedUserContact.FirstName = testUser.FirstName;
        relatedUserContact.LastName = testUser.LastName;
        relatedUserContact.Person_Type__c = 'Employee';
        relatedUserContact.AccountId = hrOrg.Id;
        relatedUserContact.Supervisor__c = testUserSupervisor.Id;
        insert relatedUserContact;

        PermissionSetAssignment assignAwardPermissionSet = AwardTestUtilities.assignAwardSupervisorPermSet(testUser);
        System.runAs(testUser) {
            insert assignAwardPermissionSet;
        }

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.OwnerId = testUser.Id;

        Test.startTest();
        System.runAs(testUser) {
            insert award;
        }
        Test.stopTest();

        Award__c updatedAward = [SELECT Id, Authorizing_Official__c, Budget__c, Owner_Contact__c FROM Award__c LIMIT 1];

        System.assertEquals(budget.Id, updatedAward.Budget__c, 'Budget Ids do not match.');
        System.assertEquals(testUserSupervisor.Id, updatedAward.Authorizing_Official__c, 'Authorizing official Id does not ' +
                'match testSupervisor Id.');
        System.assertEquals(relatedUserContact.Id, updatedAward.Owner_Contact__c, 'Owner contact Id does not match ' +
                'relatedUserContact Id.');
    }

    @IsTest
    public static void testChangingAwardOwner() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        User testUser = AwardTestUtilities.createTestUser();
        insert testUser;

        User testNewOwner = AwardTestUtilities.createTestUser();
        testNewOwner.LastName = 'New Owner';
        testNewOwner.Username = 'test.newowner@epa.gov.test';
        insert testNewOwner;

        PermissionSetAssignment assignAwardPermissionSet = AwardTestUtilities.assignAwardSupervisorPermSet(testNewOwner);
        System.runAs(testUser) {
            insert assignAwardPermissionSet;
        }

        Account newHrOrg = AwardTestUtilities.createOrganization('ORD-ZYX-WVU');
        insert newHrOrg;

        Contact newOwnerContact = new Contact();
        newOwnerContact.FirstName = testNewOwner.FirstName;
        newOwnerContact.LastName = testNewOwner.LastName;
        newOwnerContact.User__c = testNewOwner.Id;
        insert newOwnerContact;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.OwnerId = testUser.Id;
        insert award;

        Test.startTest();
        award.OwnerId = testNewOwner.Id;
        update award;
        Test.stopTest();

        Award__c updatedAward = [SELECT Id, Owner_Contact__c FROM Award__c WHERE Id = :award.Id];
        System.assertEquals(newOwnerContact.Id, updatedAward.Owner_Contact__c, 'Award should have the new owner\'s contact.');
    }

    @IsTest
    public static void testCustomSharing() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        // User that owns the award.
        User testAwardOwner = AwardTestUtilities.createTestUser();
        insert testAwardOwner;

        // IOAA Supervisor User on the award.
        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        insert testIoaaSupervisor;

        // User's supervisor related on the User's related contact.
        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'User Supervisor';
        testUserSupervisor.Username = 'test.usersupervisor@epa.gov.test';
        insert testUserSupervisor;

        // User who is listed as the awardee's supervisor.
        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        insert testAwardeeSupervisor;

        Contact testAwardOwnerContact = AwardTestUtilities.createEmployee(hrOrg);
        testAwardOwnerContact.User__c = testAwardOwner.Id;
        testAwardOwnerContact.Supervisor__c = testUserSupervisor.Id;
        insert testAwardOwnerContact;

        employee.Supervisor__c = testAwardeeSupervisor.Id;
        update employee;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.OwnerId = testAwardOwner.Id;
        award.IOAA_Approver__c = testIoaaSupervisor.Id;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Budget__c = budget.Id;
        award.Cash_Award_Amount__c = 1000;
        insert award;

        Test.startTest();
        award.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
        update award;
        Test.stopTest();
    }

    @IsTest
    public static void testSubmitForDirectSupervisorApproval() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        Account newHrOrg = AwardTestUtilities.createOrganization('ORD-ZYX-WVU');
        insert newHrOrg;

        // User that owns the award.
        User testAwardOwner = AwardTestUtilities.createTestUser();
        insert testAwardOwner;

        // IOAA Supervisor User on the award.
        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        insert testIoaaSupervisor;

        // User's supervisor related on the User's related contact.
        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'User Supervisor';
        testUserSupervisor.Username = 'test.usersupervisor@epa.gov.test';
        insert testUserSupervisor;

        // User who is listed as the awardee's supervisor.
        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        insert testAwardeeSupervisor;

        Contact testAwardOwnerContact = AwardTestUtilities.createEmployee(newHrOrg);
        testAwardOwnerContact.User__c = testAwardOwner.Id;
        testAwardOwnerContact.Supervisor__c = testUserSupervisor.Id;
        insert testAwardOwnerContact;

        employee.Supervisor__c = testAwardeeSupervisor.Id;
        update employee;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.OwnerId = testAwardOwner.Id;
        award.IOAA_Approver__c = testIoaaSupervisor.Id;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Budget__c = budget.Id;
        award.Cash_Award_Amount__c = 1000;
        insert award;

        Test.startTest();
        award.Status__c = AwardConstants.AWARD_STATUS_APPROVED;
        update award;
        Test.stopTest();
    }
}