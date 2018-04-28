/**
 * Controller for getting, updating Award records for award planning visualforce page.
 */

public class MyAwardPlannerController {
    public List<AwardWrapper> awardsList {get; set;}
    public Decimal budgetCashAmount {get; set;}
    public Decimal totalBudgetAmount {get; set;}
    public Decimal totalAllocatedAmount {get; set;}
    public Decimal totalBudgetRemaining {get; set;}
    public Boolean isSelected {get; set;}
    private final Id userId = UserInfo.getUserId();

    public class AwardWrapper {
        public Award__c award {get; set;}
        public Boolean selected {get; set;}

        public AwardWrapper(Award__c a) {
            award = a;
            selected = false;
        }
    }

    public MyAwardPlannerController() {
        if (awardsList == null) {
            awardsList = getPlannedAwards(userId);
        }

        Map<String, Decimal> budgetAmounts = getBudgetAmounts();
        budgetCashAmount = calculateCashAmount();
        totalBudgetAmount = budgetAmounts.get('totalBudget');
        totalAllocatedAmount = budgetAmounts.get('allocatedAmount');
        totalBudgetRemaining = 0.00;
        // Set all checkboxes to false when initially loading page
        isSelected = false;
    }

    /**
     * Builds and returns a list of AwardWrapper objects to populate the awards planner page.
     *
     * @param userId User accessing the page
     *
     * @return List of AwardWrapper objects for which that user has access
     */
    public List<AwardWrapper> getPlannedAwards(Id userId) {
        List<AwardWrapper> awardsList = new List<AwardWrapper>();

        List<Award__c> awards = [
                SELECT Id, Name, Emp_Name__r.Name, LCO__c, Division__c, Branch__c, Outside_LCO__c, Outside_ORD__c,
                        Cash_Award_Amount__c, Time_Off_Amount__c, Group_Award_Amount__c, Group_Award_Name__c,
                        Type_of_Benefit__c, Value_of_Benefit__c, Extent_of_Contribution__c, Supervisor_Justification__c,
                        Status__c, Pay_Period__c, OTS_Amount__c, Budget__c
                FROM Award__c
                WHERE OwnerId = :userId
                AND Status__c = :AwardConstants.AWARD_STATUS_PLANNED
                ORDER BY Emp_Name__r.LastName ASC
        ];

        for (Award__c award : awards) {
            AwardWrapper aw = new AwardWrapper(award);
            awardsList.add(aw);
        }

        return awardsList;
    }

    /**
     * Saves all awards on the page and refreshes the page.
     *
     * @return Nothing - refreshes the page
     */
    public PageReference save() {
        List<Award__c> awards = new List<Award__c>();

        for (AwardWrapper aw : awardsList) {
            awards.add(aw.award);
        }

        upsert awards;
        return null;
    }

    /**
     * Calculates upon page instantiation the amounts of the awards on the page.
     *
     * @return Total amount of all awards on the page
     */
    private Decimal calculateCashAmount() {
        Decimal amount = 0.00;

        for (AwardWrapper aw : awardsList) {
            amount = amount + aw.award.Cash_Award_Amount__c;
        }

        return amount;
    }

    /**
     * Gets the budget information based on the user accessing the planner. If that user's department (found in the
     * User.Department field) has an associated budget, that budget information will be returned in a map. More than
     * one budget shouldn't be returned.
     *
     * @param userId User accessing the planner page
     *
     * @return Map of total and allocated budget amounts
     */
    private Map<String, Decimal> getBudgetAmounts() {
        Map<String, Decimal> budgetAmountsMap = new Map<String, Decimal>();
        Map<Id, Document__c> budgets = new Map<Id, Document__c>();
        Set<Id> budgetIds = new Set<Id>();

        // Loop through the awards list and put the budget Ids in a set.
        if (!awardsList.isEmpty()) {
            for (AwardWrapper aw : awardsList) {
                if (aw.award.Budget__c != null) {
                    budgetIds.add(aw.award.Budget__c);
                }
            }
        }

        if (!budgetIds.isEmpty()) {
            budgets = AwardProcessSupporter.getBudgetsById(budgetIds);
        }

        if (budgets.size() == 1) {
            List<Document__c> budgetList = new List<Document__c>(budgets.values());
            budgetAmountsMap.put('totalBudget', budgets.get(budgetList[0].Id).Award_Total_Budget__c);
            budgetAmountsMap.put('allocatedAmount', budgets.get(budgetList[0].Id).Award_Allocated_Amount__c);
        } else {
            Decimal totalBudgetAmounts = 0;
            Decimal totalAllocatedAmounts = 0;

            for (Id budgetId : budgetIds) {
                totalBudgetAmounts = totalBudgetAmounts + budgets.get(budgetId).Award_Total_Budget__c;
                totalAllocatedAmounts = totalAllocatedAmounts + budgets.get(budgetId).Award_Allocated_Amount__c;
            }

            budgetAmountsMap.put('totalBudget', totalBudgetAmounts);
            budgetAmountsMap.put('allocatedAmount', totalAllocatedAmounts);
        }

        return budgetAmountsMap;
    }

    /**
     * Before submitting awards for approval, checks to make sure that the amounts of the awards do not exceed the
     * budget and then submits the awards for approval.
     *
     * @return Refreshes the page.
     */
    public PageReference submitAwardsForApproval() {
        List<Award__c> awards = new List<Award__c>();
        List<Award__c> outsideOrdAwards = new List<Award__c>();
        Boolean withinBudget = true;

        for (AwardWrapper aw : awardsList) {
            if (aw.selected) {
                awards.add(aw.award);
            }
        }

        if (!awards.isEmpty()) {
            // Check to make sure the sum of award values don't exceed budget
            Decimal awardsTotal = 0;
            for (Award__c award : awards) {
                awardsTotal = awardsTotal + award.Cash_Award_Amount__c;
            }

            Decimal budgetRemaining = totalBudgetAmount - totalAllocatedAmount;

            if (budgetRemaining < awardsTotal) {
                withinBudget = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The award amounts exceed the amount remaining ' +
                        'on the budget. Please update the amounts before submitting again.'));

                return null;
            }

            // If not budgetExceeded, then submit each award for approval
            if (withinBudget) {
                for (Award__c award : awards) {
                    if (!award.Outside_ORD__c) {
                        Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
                        approvalReq.setSubmitterId(userId);
                        approvalReq.setProcessDefinitionNameOrId('ORD_Awards_Approval_Process');
                        approvalReq.setObjectId(award.Id);
                        approvalReq.setComments('Please review this award for approval.');

                        try {
                            Approval.ProcessResult result = Approval.process(approvalReq);
                            System.assert(result.isSuccess());
                        } catch (Exception e) {
                            System.debug('Error message: ' + e.getMessage());
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, 'An error occurred with the ' +
                                    'following message: ' + e.getMessage()));
                        }
                    } else {
                        // If award is outside ORD, set status and update awards
                        award.Status__c = AwardConstants.AWARD_STATUS_AWAITING_FUNDING;
                        outsideOrdAwards.add(award);
                    }
                }

                if (!outsideOrdAwards.isEmpty()) {
                    update awards;
                }
            }
        }

        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Awards submitted successfully.'));
        PageReference currentPage = new PageReference(ApexPages.currentPage().getUrl());
        currentPage.setRedirect(true);
        return currentPage;
    }
}