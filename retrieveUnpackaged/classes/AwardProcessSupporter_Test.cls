@IsTest
public with sharing class AwardProcessSupporter_Test {
    static String TYPE_OF_BENEFIT = 'Tangible';
    static String VALUE_OF_BENEFIT = 'Substantial';
    static String EXTENT_OF_CONTRIBUTION = 'Broad';
    static String SUPERVISOR_JUSTIFICATION = 'Good work.';

    @TestSetup
    public static void testData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-ABC-NRML');
        insert hrOrg;

        List<Contact> employees = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            Contact employee = AwardTestUtilities.createEmployee(hrOrg);
            employee.LastName = employee.LastName + i;

            employees.add(employee);
        }
        insert employees;

        Document__c budget = new Document__c();
        budget.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME).getRecordTypeId();
        budget.Award_Total_Budget__c = 10000;
        budget.Award_Budget_Start_Date__c = System.today();
        insert budget;

        List<Award__c> awards = new List<Award__c>();
        for (Integer i = 0; i < employees.size(); i++) {
            Award__c award = AwardTestUtilities.createAward(employees[i]);
            award.Budget__c = budget.Id;
            award.Planned_Date__c = System.today();
            award.OwnerId = UserInfo.getUserId();

            awards.add(award);
        }
        insert awards;
    }

    @IsTest
    public static void testSupervisorApproval() {
        List<Decimal> awardAmounts = new List<Decimal>{1000, 2000, 3000};
        List<Award__c> awards = [
                SELECT Id
                FROM Award__c
                LIMIT 3
        ];

        for (Integer i = 0; i < awardAmounts.size(); i++) {
            awards[i].Cash_Award_Amount__c = awardAmounts[i];
        }

        Test.startTest();
        AwardProcessSupporter.checkSupervisorApproval(awards);
        Test.stopTest();

        System.assert(!awards[0].Requires_Supervisor_Approval__c, 'Cash award less than $1,000 does not require supervisor approval');
        System.assert(awards[1].Requires_Supervisor_Approval__c, 'Cash award of exactly $2,000 requires supervisor approval');
        System.assert(awards[2].Requires_Supervisor_Approval__c, 'Cash award greater than $2,000 requires supervisor approval');
    }


    @IsTest
    public static void testBudgetBalances() {
        Document__c budget = [
                SELECT Id
                FROM Document__c
                WHERE RecordType.Name = :AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME
        ];

        Contact employee = [SELECT Id FROM Contact LIMIT 1];

        budget.Award_Total_Budget__c = 3000;
        update budget;

        Award__c award = new Award__c();
        award.Budget__c = budget.Id;
        award.Emp_Name__c = employee.Id;
        award.OwnerId = UserInfo.getUserId();
        award.Cash_Award_Amount__c = 4000;
        award.Type_of_Benefit__c = TYPE_OF_BENEFIT;
        award.Value_of_Benefit__c = VALUE_OF_BENEFIT;
        award.Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION;
        award.Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION;
        insert award;

        Test.startTest();
        award.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
        try {
            // Need to set this to false because all updates are run in the same context, thus the Boolean is not reset
            AwardProcessSupporter.hasBeenCalculated = false;
            update award;
            System.assert(false, 'Should have caught a budget error here.');
        } catch (DmlException dmle) {
            System.debug('Caught AwardException with error: ' + dmle.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void retrieveBudgetsById() {
        List<Document__c> budgets = new List<Document__c>();
        Set<Id> budgetIds = new Set<Id>();
        Account org = AwardTestUtilities.createOrganization('ORD-ACC-USB');
        insert org;

        Id budgetRecordTypeId = [
                SELECT Id
                FROM RecordType
                WHERE SobjectType = 'Document__c'
                AND Name = :AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME
                LIMIT 1
        ].Id;

        for (Integer i = 0; i < 3; i++) {
            Document__c budget = new Document__c();
            budget.Award_Total_Budget__c = 300000;
            budget.RecordTypeId = budgetRecordTypeId;

            budgets.add(budget);
        }
        insert budgets;

        for (Document__c budget : budgets) {
            budgetIds.add(budget.Id);
        }

        Test.startTest();
        Map<Id, Document__c> budgetsByIds = AwardProcessSupporter.getBudgetsById(budgetIds);
        Test.stopTest();

        System.assertEquals(budgetIds.size(), budgetsByIds.size(), 'Should have retrieved all budgets for the given Ids.');
    }

    @IsTest
    public static void testTimeOffAwards() {
        List<Decimal> timeOffAmounts = new List<Decimal>{5, 12};
        Award__c[] awards = [SELECT Id FROM Award__c LIMIT 2];
        String timeOffException;

        for (Integer i = 0; i < awards.size(); i++) {
            awards[i].Time_Off_Amount__c = timeOffAmounts[i];
            awards[i].Type_of_Benefit__c = TYPE_OF_BENEFIT;
            awards[i].Value_of_Benefit__c = VALUE_OF_BENEFIT;
            awards[i].Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION;
            awards[i].Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION;
        }
        update awards;

        Test.startTest();
        for (Award__c award : awards) {
            // Set hasBeenCalculated to false to mimic a new trigger context.
            AwardProcessSupporter.hasBeenCalculated = false;
            award.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;

            try {
                update award;
            } catch (DmlException dmle) {
                timeOffException = dmle.getMessage();
            }
        }
        Test.stopTest();

        Award__c supervisorApprovalNeededAward = [
                SELECT Id, Requires_Supervisor_Approval__c
                FROM Award__c
                WHERE Time_Off_Amount__c > 10
        ];

        System.assertEquals(true, supervisorApprovalNeededAward.Requires_Supervisor_Approval__c, 'A 10-hour award should have triggered supervisor approval');
    }
    
    @IsTest
    public static void testCumulativeTimeOffLimit() {
        // Mimic filling out the award
        Award__c award = [SELECT Id, Emp_Name__c, Budget__c FROM Award__c LIMIT 1];
        award.Time_Off_Amount__c = 50;
        award.Type_of_Benefit__c = TYPE_OF_BENEFIT;
        award.Value_of_Benefit__c = VALUE_OF_BENEFIT;
        award.Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION;
        award.Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION;
        update award;

        // Submit the award
        award.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
        award.Submitted_Date__c = System.today();
        update award;

        // Create a new award that would bring the employee's total to greater than 80 cumulative hours
        Award__c newAward = new Award__c(
                Emp_Name__c = award.Emp_Name__c,
                Time_Off_Amount__c = 40,
                Type_of_Benefit__c = TYPE_OF_BENEFIT,
                Value_of_Benefit__c = VALUE_OF_BENEFIT,
                Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION,
                Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION,
                Budget__c = award.Budget__c,
                OwnerId = UserInfo.getUserId()
        );
        insert newAward;

        Test.startTest();
        // Submit the award and catch an error
        newAward.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
        newAward.Submitted_Date__c = System.today();
        try {
            update newAward;
            System.assert(false, 'Should have caught a DmlException because the total hours is greater than 80.');
        } catch (DmlException dmle) {
            System.debug('Caught DmlException with message: ' + dmle.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void testMultipleAwardsForOneEmployee() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];

        Award__c firstAward = AwardTestUtilities.createAward(employee);
        firstAward.Cash_Award_Amount__c = 3000;
        firstAward.STAA_Award_Amount__c = 0;
        firstAward.Title_42_SL_ST_Award_Amount__c = 0;

        Award__c secondAward = AwardTestUtilities.createAward(employee);
        secondAward.Cash_Award_Amount__c = 3000;
        secondAward.STAA_Award_Amount__c = 0;
        secondAward.Title_42_SL_ST_Award_Amount__c = 0;

        List<Award__c> awards = new List<Award__c>{firstAward, secondAward};

        Test.startTest();
        AwardProcessSupporter.checkIoaaApproval(awards);
        Test.stopTest();

        System.assertEquals(true, firstAward.Requires_IOAA_Approval__c, 'Award should require IOAA approval.');
        System.assertEquals(true, secondAward.Requires_IOAA_Approval__c, 'Award should require IOAA approval.');
    }
}