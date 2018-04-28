/**
 * Class and methods for instantiating the BudgetPlanner Visualforce page.
 */

public with sharing class BudgetPlannerController {
    public List<Document__c> budgetList {get; set;}

    public BudgetPlannerController() {
        if (budgetList == null) {
            budgetList = getBudgets();
        }
    } 
    
    public List<Document__c> getBudgets() {
        List<Document__c> budgets = [
                SELECT Id, Name, Award_Total_Budget__c, Award_Budget_Org__r.Name
                FROM Document__c
                WHERE RecordType.Name = 'Document - Award Budget'
                AND Award_Budget_Start_Date__c = THIS_FISCAL_YEAR
                ORDER BY Award_Budget_Org__r.Name ASC
        ];

        return budgets;
    }

    public PageReference save() {
        update budgetList;

        return null;
    }
}