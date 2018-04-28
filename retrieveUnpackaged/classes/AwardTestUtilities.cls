@IsTest
public class AwardTestUtilities {
    public static String TYPE_OF_BENEFIT = 'Tangible';
    public static String VALUE_OF_BENEFIT = 'Substantial';
    public static String EXTENT_OF_CONTRIBUTION = 'Broad';
    public static String SUPERVISOR_JUSTIFICATION = 'Good work.';

    public static Contact createEmployee(Account hrOrg) {
        Contact employee = new Contact();
        employee.FirstName = 'First Name';
        employee.LastName = 'Last Name';
        employee.Person_Type__c = 'Employee';
        employee.AccountId = hrOrg.Id;

        return employee;
    }

    public static Account createOrganization(String acctName) {
        Account org = new Account();
        org.Name = acctName;

        return org;
    }

    public static Award__c createAward(Contact employee) {
        Award__c award = new Award__c();
        award.Emp_Name__c = employee.Id;

        return award;
    }

    public static Document__c createBudget(Account hrOrg, Decimal budgetAmount) {
        Id budgetRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME).getRecordTypeId();
        Document__c budget = new Document__c();
        budget.RecordTypeId = budgetRecordTypeId;
        budget.Award_Total_Budget__c = budgetAmount;
        budget.Award_Budget_Org__c = hrOrg.Id;
        budget.Award_Budget_Start_Date__c = System.today();

        return budget;
    }

    public static User createTestUser() {
        Profile profile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'EPA Starter'
        ];

        User testUser = new User(Alias = 'testUser', Email = 'test.user@epa.gov.test', FirstName = 'Test', LastName = 'User',
        ProfileId = profile.Id, Username = 'test.user@epa.gov.test', TimeZoneSidKey = 'America/Indiana/Indianapolis',
        LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');

        return testUser;
    }

    public static PermissionSetAssignment assignAwardSupervisorPermSet(User testUser) {
        PermissionSet awardSupervisorPermSet = [
                SELECT Id
                FROM PermissionSet
                WHERE Label = 'Awards - Supervisor Access'
        ];

        PermissionSetAssignment awardSupervisorAssignment = new PermissionSetAssignment();
        awardSupervisorAssignment.AssigneeId = testUser.Id;
        awardSupervisorAssignment.PermissionSetId = awardSupervisorPermSet.Id;

        return awardSupervisorAssignment;
    }

    public static void createTestData() {
        Account testAccount = createOrganization('0RD-ABC-DEF-GHI');
        insert testAccount;

        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            Contact testContact = createEmployee(testAccount);
            testContacts.add(testContact);
        }
    }
}