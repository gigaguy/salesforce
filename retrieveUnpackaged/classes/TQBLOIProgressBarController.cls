public with sharing class TQBLOIProgressBarController {
    
    @AuraEnabled
    public static List<TQB_Letter_of_Intent__c>  getLetters() {
        //List<TQB_Letter_of_Intent__c> letters = [Select Id, Name, Status__c, Status_Date__c FROM TQB_Letter_of_Intent__c where CandidateName__c = :UserInfo.getUserId()];
        List<TQB_Letter_of_Intent__c> letters = [Select Id, Name, Status__c, Status_Date__c FROM TQB_Letter_of_Intent__c];
        return letters ;    
    }
    
}