public with sharing class TQBHomeProgressBarController {

    @AuraEnabled
    public static List<TQB_Letter_of_Intent__c>  getLetters() {        
        List<TQB_Letter_of_Intent__c> letters = [Select Id, Name, Status__c, Status_Date__c FROM TQB_Letter_of_Intent__c where CreatedById = :UserInfo.getUserId() order by Name];                
        return letters ;
    }

    @AuraEnabled
    public static List<TQB_Candidate_Package__c>  getPackages() {
        List<TQB_Candidate_Package__c> packages = [Select Id, Name, Status__c, Status_Date__c FROM TQB_Candidate_Package__c where CreatedById = :UserInfo.getUserId() order by Name];
        return packages ;
    }

}