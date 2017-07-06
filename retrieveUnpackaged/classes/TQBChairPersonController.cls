public with sharing class TQBChairPersonController {

    @AuraEnabled
    public static List<TQB_Candidate_Package__c>  getCPs() {
     String UserId = UserInfo.getUserId();
    //return [select Name, Candidate_Name__c, Status__c, Status_Date__c from TQB_Candidate_Package__c where Candidates_2nd_Line_Supervisor_Name__c = :UserId and Status__c='Approved'] ;
        return [select Name, Candidate_Name__c, Status__c, Status_Date__c from TQB_Candidate_Package__c where  Status__c='Approved By 2nd Line Supervisor'] ;
    }

}