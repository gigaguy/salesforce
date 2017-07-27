public class LOIRejectReasonMultiSelectApexController {
     
    @AuraEnabled
    public static List<String> getPicklistvalues() {
     List<String> options = new List<String>();
     Schema.DescribeFieldResult fieldResult = TQB_Letter_of_Intent__c.LOI_Reject_Reason__c.getDescribe();
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     System.debug(ple);
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
       return options; 
    }

}