public with sharing class TQB1stLineSupervisorLPController {
    
    @AuraEnabled
    public static List<TQB_Letter_of_Intent__c>  getLOIs() {
     String UserId = UserInfo.getUserId();
    return[select Name, Candidate_Name__c, Status__c, Status_Date__c from TQB_Letter_of_Intent__c where Candidates_1st_Line_Supervisor_Name__c = :UserId];
    }
    
    @AuraEnabled
    public static List<TQB_Candidate_Package__c>  getCPs() {
     String UserId = UserInfo.getUserId();
    return [select Name, Candidate_Name__c, Status__c, Status_Date__c from TQB_Candidate_Package__c where Candidates_1st_Line_Supervisor_Name__c = :UserId] ;    
    }

}