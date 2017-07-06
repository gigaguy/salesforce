public with sharing class TQBpoliciesAndProceduresController {
    
    @AuraEnabled
    public static List<TQB_Policies_and_Procedures__c>  getPoliciesAndProcedures() {
        
        List<TQB_Policies_and_Procedures__c>   policiesAndProcedures = Database.query(
            'SELECT Link__c,Link_Title__c ' +
            'FROM TQB_Policies_and_Procedures__c' 
    );
    return policiesAndProcedures ;    
    }

}