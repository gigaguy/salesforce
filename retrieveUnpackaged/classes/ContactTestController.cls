global class ContactTestController {

    @auraEnabled
    public static List<RecordType> getFormRTs(){
        return [select id, Name from RecordType where sObjectType = 'Forms__c' and IsActive = true];
    }
    @AuraEnabled
    public static String insertNewForms(sObject nf){
        system.debug('Starting insertNewForms');
        try{
            insert nf;
            System.debug('newForms'+nf);
            return nf.Id;
        }
        catch(DMLException ex){
           AuraHandledException e = new AuraHandledException(ex.getMessage());
            system.debug(ex.getMessage());
           throw e;
        }
        return '';        
    }
    
}