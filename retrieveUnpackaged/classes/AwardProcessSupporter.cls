/**
 * AwardProcessSupporter contains methods that handle award validations and makes sure that no awards exceed cash amount
 * and time off limits.
 */

public class AwardProcessSupporter {
    public static Boolean hasBeenCalculated = false;

    public static void performAllAwardChecks(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        checkHoursRequirements(awards, oldAwardsByIds);
        checkSupervisorApproval(awards);
        checkIoaaApproval(awards);
        checkBudgetBalances(awards, oldAwardsByIds);
    }

    /**
     * Before inserting an award nomination, check to see if the award will require supervisor approval.
     *
     * @param awards List of award nominations being created
     */
    @TestVisible
    private static void checkSupervisorApproval(List<Award__c> awards) {
        for (Award__c award : awards) {
            award.Requires_Supervisor_Approval__c = false;

            if ((award.Cash_Award_Amount__c >= 2000 || award.STAA_Award_Amount__c >= 2000 || award.Title_42_SL_ST_Award_Amount__c >= 2000) ||
                    (award.Time_Off_Amount__c != null && award.Time_Off_Amount__c > 10)) {
                award.Requires_Supervisor_Approval__c = true;
            }
        }
    }

    /**
     * Any individual awards that are greater than $2K or exceed $5K total or time off that equals more than 1
     * full workday requires IOAA approval and should be marked as such.
     *
     * @param awards Awards that are updated or inserted and need to be checked against previous awards or other in-
     * process awards
     */
    @TestVisible
    private static void checkIoaaApproval(List<Award__c> awards) {
        List<Id> employeeIds = new List<Id>();
        List<Id> awardIds = new List<Id>();
        Map<Id, Decimal> currentAwardValuesMap = new Map<Id, Decimal>();

        for (Award__c award : awards) {
            employeeIds.add(award.Emp_Name__c);
            awardIds.add(award.Id);

            Decimal currentAwardValue = award.STAA_Award_Amount__c + award.Cash_Award_Amount__c + award.Title_42_SL_ST_Award_Amount__c;
            if (currentAwardValuesMap.containsKey(award.Emp_Name__c)) {
                Decimal existingValue = currentAwardValuesMap.get(award.Emp_Name__c);
                currentAwardValuesMap.put(award.Emp_Name__c, currentAwardValue + existingValue);
            } else {
                currentAwardValuesMap.put(award.Emp_Name__c, currentAwardValue);
            }
        }

        Map<Id, Decimal> previousEmployeeAwardsMap = getPreviousAwardAmounts(employeeIds, awardIds);

        for (Award__c award : awards) {
            award.Requires_IOAA_Approval__c = false;
            Decimal previousAwardsValues = 0;

            if (previousEmployeeAwardsMap.containsKey(award.Emp_Name__c)) {
                previousAwardsValues = previousEmployeeAwardsMap.get(award.Emp_Name__c);
            }

            Decimal totalValue = previousAwardsValues + currentAwardValuesMap.get(award.Emp_Name__c);
            if (totalValue > 0) {
                award.Total_Award_Amount_on_Submit__c = totalValue;
            }

            if (totalValue >= 5000) {
                award.Requires_IOAA_Approval__c = true;
                award.Requires_Supervisor_Approval__c = true;
            }
        }
    }

    /**
     * Get the monetary values of all in-process or paid awards per employee. Though, we want to exclude the current awards
     * that have triggered this check in case we get an errant value. (The context is beforeUpdate, so querying the database
     * might retrieve a previous value of the award in the trigger and provide an incorrect calculation.)
     *
     * @param employeeIds Salesforce Ids for employees on awards applications
     *
     * @return A map of employee Salesforce Id and total amount of awards in process
     */
    @TestVisible
    private static Map<Id, Decimal> getPreviousAwardAmounts(List<Id> employeeIds, List<Id> awardIds) {
        Map<Id, Decimal> employeeAwardMap = new Map<Id, Decimal>();

        AggregateResult[] awardTotals = [
                SELECT Emp_Name__c, SUM(Cash_Award_Amount__c) cashAmount, SUM(STAA_Award_Amount__c) staaAmount,
                        SUM(Title_42_SL_ST_Award_Amount__c) title42Amount, SUM(OTS_Amount__c) otsAmount
                FROM Award__c
                WHERE Status__c NOT IN ('Planned','Rejected')
                AND Emp_Name__c IN :employeeIds
                AND Id NOT IN :awardIds
                AND Submitted_Date__c = THIS_FISCAL_YEAR
                AND (Cash_Award_Amount__c <> null OR STAA_Award_Amount__c <> null OR Title_42_SL_ST_Award_Amount__c <> null OR OTS_Amount__c <> null)
                GROUP BY Emp_Name__c
        ];

        for (AggregateResult result : awardTotals) {
            Decimal totalAwardValue = (Decimal) result.get('cashAmount') + (Decimal) result.get('staaAmount') + (Decimal) result.get('title42Amount') + (Decimal) result.get('otsAmount');
            employeeAwardMap.put((Id) result.get('Emp_Name__c'), totalAwardValue);
        }

        return employeeAwardMap;
    }

    /**
     * Check the award amount versus the remaining budget to make sure the awards won't exceed the organization's budget. hasBeenCalculated boolean
     * is there to prevent double-calculations when a record is updated twice in a single transaction.
     *
     * @param awards List of new awards in trigger
     * @param oldAwardsByIds Map of old awards by Id in trigger
     */
    @TestVisible
    private static void checkBudgetBalances(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        System.debug('>>>> Current hasBeenCalculated value: ' + hasBeenCalculated);
        if (!hasBeenCalculated) {
            Map<Id, List<Award__c>> awardsByBudgetId = new Map<Id, List<Award__c>>();

            // Check to see if the award is associated with a budget
            // If no budget, then no check needs to be performed
            for (Award__c award : awards) {
                if (award.Budget__c != null && award.Cash_Award_Amount__c != 0 &&
                        // Here we want to make sure the run the calculation for awards that have previously not been accounted for in the budget
                        // So, we'll check to make sure the current status is one we want to use for calculations, but the previous status wasn't
                        AwardConstants.AWARD_STATUS_FOR_BUDGET_CALC.contains(award.Status__c) && !AwardConstants.AWARD_STATUS_FOR_BUDGET_CALC.contains(oldAwardsByIds.get(award.Id).Status__c)) {
                    if (awardsByBudgetId.containsKey(award.Budget__c)) {
                        List<Award__c> awardList = awardsByBudgetId.get(award.Budget__c);
                        awardList.add(award);
                        awardsByBudgetId.put(award.Budget__c, awardList);
                    } else {
                        List<Award__c> awardList = new List<Award__c>{award};
                        awardsByBudgetId.put(award.Budget__c, awardList);
                    }
                }
            }

            // Get the budget amounts from the budget Ids in awardsByBudgetId
            Map<Id, Document__c> budgetsById = getBudgetsById(awardsByBudgetId.keySet());

            // For each budget Id in awardsByBudgetId, sum the award amounts and compare to the budget amounts
            for (Id budgetId : awardsByBudgetId.keySet()) {
                System.debug('>>>>> Budget total amount allocated: ' + budgetsById.get(budgetId).Award_Allocated_Amount__c);
                System.debug('>>>>> Budget total amount remaining: ' + budgetsById.get(budgetId).Award_Remaining_Budget__c);
                Decimal awardTotals = 0;
                List<Award__c> awardList = awardsByBudgetId.get(budgetId);
                for (Award__c award : awardList) {
                    awardTotals = awardTotals + award.Cash_Award_Amount__c;
                    System.debug('>>>>> New award totals amount: ' + awardTotals);
                }

                if (budgetsById.containsKey(budgetId)) {
                    Document__c budget = budgetsById.get(budgetId);
                    if (awardTotals + budget.Award_Allocated_Amount__c > budget.Award_Total_Budget__c) {
                        Decimal totals = awardTotals + budget.Award_Allocated_Amount__c;
                        System.debug('>>>>> Award totals + allocated amount: ' + totals);
                        System.debug('>>>>> Total budget: ' + budget.Award_Total_Budget__c);
                        throw new AwardException('Award amounts exceed total Organization budget.');
                    }
                }
            }
        }

        System.debug('>>>>> Setting hasBeenCalculated to true.');
        hasBeenCalculated = true;
    }

    /**
     * Queries and returns a list of budgets during the current fiscal year when supplied a list of HR Org names.
     *
     * @param orgNames List of HR Org names for which you want budgets
     *
     * @return List of budget objects
     */
    public static List<Document__c> getBudgetsByOrganizationName(List<String> orgNames) {
        List<Document__c> budgets = [
                SELECT Id, Parent_Budget__c, Award_Allocated_Amount__c, Award_Total_Budget__c, Award_Remaining_Budget__c, Award_Budget_Org__r.Name
                FROM Document__c
                WHERE RecordType.Name = :AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME
                AND Award_Budget_Start_Date__c = THIS_FISCAL_YEAR
                AND Award_Budget_Org__r.Name IN :orgNames
        ];

        return budgets;
    }

    /**
     * Queries and returns fields for a budget when supplied the budget's Id.
     *
     * @param budgetIds Ids for the budgets needing queried
     *
     * @return List of budget objects
     */
    public static Map<Id, Document__c> getBudgetsById(Set<Id> budgetIds) {
        Map<Id, Document__c> budgetsById = new Map<Id, Document__c>([
                SELECT Id, Parent_Budget__c, Award_Allocated_Amount__c, Award_Total_Budget__c, Award_Remaining_Budget__c
                FROM Document__c
                WHERE Id IN :budgetIds
        ]);

        return budgetsById;
    }

    /**
     * Check to see if an employee will cross the 80 hour per year threshold. If so, prevent the award from being submitted.
     *
     * @param awards
     * @param oldAwardsByIds
     */
    @TestVisible
    private static void checkHoursRequirements(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        List<Award__c> awardsWithHours = new List<Award__c>();
        List<Id> employeeIds = new List<Id>();
        // Check if there are any hours allocated in the award.
        for (Award__c award : awards) {
            if (AwardConstants.AWARD_STATUS_SUBMITTED.equals(award.Status__c) && !AwardConstants.AWARD_STATUS_SUBMITTED.equals(oldAwardsByIds.get(award.Id).Status__c)
                    && award.Time_Off_Amount__c != null && !award.Outside_ORD__c) {
                awardsWithHours.add(award);
                employeeIds.add(award.Emp_Name__c);
            }
        }

        // Get the employee's hours awards for the calendar year.
        if (!awardsWithHours.isEmpty()) {
            List<Id> awardIds = new List<Id>();
            for (Award__c award : awardsWithHours) {
                awardIds.add(award.Id);
            }
            Map<Id, Decimal> employeeIdsWithTimeOff = getPreviousTimeOffAmounts(employeeIds, awardIds);

            // If the sum of hours is > 80, throw an error.
            for (Award__c award : awardsWithHours) {
                if (employeeIdsWithTimeOff.containsKey(award.Emp_Name__c)) {
                    Decimal totalTime = award.Time_Off_Amount__c + employeeIdsWithTimeOff.get(award.Emp_Name__c);
                    if (totalTime > 0) {
                        award.Total_Time_Off_on_Submit__c = totalTime;
                    }

                    if (totalTime > 80) {
                        award.addError('Employee will receive more than 80 hours of time off for this calendar year. ' +
                                'Please adjust the time off amount and submit again.');
                    }
                }
            }
        }
    }

    /**
     * Get all previous time off award amounts for a given employee during the calendar year.
     *
     * @param employeeIds Salesforce Ids of the employees you are checking
     * @param awardIds List of award Ids not needed as part of the check
     *
     * @return a Map of the employee Id and sum of hours in previous awards
     */
    @TestVisible
    private static Map<Id, Decimal> getPreviousTimeOffAmounts(List<Id> employeeIds, List<Id> awardIds) {
        Map<Id, Decimal> employeeHoursMap = new Map<Id, Decimal>();

        List<AggregateResult> results = [
                SELECT Emp_Name__c, SUM(Time_Off_Amount__c) timeOffSum
                FROM Award__c
                WHERE Submitted_Date__c = THIS_YEAR
                AND Status__c NOT IN ('Planned','Rejected')
                AND Emp_Name__c IN :employeeIds
                AND Id NOT IN :awardIds
                AND Time_Off_Amount__c != NULL
                GROUP BY Emp_Name__c
        ];

        if (!results.isEmpty()) {
            for (AggregateResult result : results) {
                employeeHoursMap.put((Id) result.get('Emp_Name__c'), (Decimal) result.get('timeOffSum'));
            }
        }

        return employeeHoursMap;
    }

    /**
     * Each user has an associated contact record that carries with it information that is needed for the application
     * to perform properly. This method gets those contacts and returns a map with User Id for easy retrieval.
     *
     * @param userIds List of user Ids for which you want contacts
     *
     * @return Map of User Id and Contact objects
     */
    public static Map<Id, Contact> getContactsByUserId(List<Id> userIds) {
        Map<Id, Contact> contactsByUserIds = new Map<Id, Contact>();

        List<Contact> contacts = [
                SELECT Id, User__c, Supervisor__c, AccountId, Detail_Org__c
                FROM Contact
                WHERE User__c IN :userIds
        ];

        for (Contact contact : contacts) {
            contactsByUserIds.put(contact.User__c, contact);
        }

        return contactsByUserIds;
    }
}