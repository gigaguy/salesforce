public with sharing class formPrintable {
    public Id recordId {get; set;}
    public Forms__c record {get;set;}
       
    public formPrintable(ApexPages.StandardController stdController) {
        this.recordId = stdController.getId();
        this.record = (Forms__c)stdController.getRecord();                    
    }
}