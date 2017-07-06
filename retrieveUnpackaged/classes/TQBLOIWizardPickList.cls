//Get LOI Record picklist values
public with sharing class TQBLOIWizardPickList {
    
  @AuraEnabled
    public static List<String> getLOIStatusListData() {
     List<String> options = new List<String>();
     Schema.DescribeFieldResult fieldResult = TQB_Letter_of_Intent__c.Status__c.getDescribe();
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     System.debug(ple);
		for (Schema.PicklistEntry f: ple) {
		    options.add(f.getLabel());
		}
       return options;
    }       

  @AuraEnabled
    public static List<User> getLOI1stlineSupervisorListData() {
    	return[Select LastName,Title from User where UserROleId='00Er0000000SMlSEAW'];
    }      

   @AuraEnabled
    public static List<User> getLOI2ndlineSupervisorListData() {
    	return[Select LastName,Title from User where UserROleId='00Er0000000SMlXEAW'];
    } 

   @AuraEnabled
    public static List<String> getLOICurrentLabWorkListData() {
     List<String> options = new List<String>();
     Schema.DescribeFieldResult fieldResult = TQB_Letter_of_Intent__c.Current_Lab_Work_Location_Assignment__c.getDescribe();
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     System.debug(ple);
		for (Schema.PicklistEntry f: ple) {
		    options.add(f.getLabel());
		}
       return options;
    }

    @AuraEnabled
    public static List<String> getLOICurrentGSListData() {
     List<String> options = new List<String>();
     Schema.DescribeFieldResult fieldResult = TQB_Letter_of_Intent__c.Current_GS_Level__c.getDescribe();
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     System.debug(ple);
		for (Schema.PicklistEntry f: ple) {
		    options.add(f.getLabel());
		}
       return options;
    }

    @AuraEnabled
    public static List<String> getLOICurrentRegionListData() {
     List<String> options = new List<String>();
     Schema.DescribeFieldResult fieldResult = TQB_Letter_of_Intent__c.CurrentRegion__c.getDescribe();
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     System.debug(ple);
		for (Schema.PicklistEntry f: ple) {
		    options.add(f.getLabel());
		}
       return options;
    }

    @AuraEnabled
    public static List<String> getLOIIntendedTrackListData() {
     List<String> options = new List<String>();
     Schema.DescribeFieldResult fieldResult = TQB_Letter_of_Intent__c.IntendedTrack__c.getDescribe();
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     System.debug(ple);
		for (Schema.PicklistEntry f: ple) {
		    options.add(f.getLabel());
		}
       return options;
    }

    @AuraEnabled
    public static String createLOIRecord(TQB_Letter_of_Intent__c LOIForm) {
        String errorMessage;
        try{
            System.debug('createLOIRecord'+LOIForm);
            
            if(LOIForm != null){
                insert LOIForm;
            }
            
        } catch (DMLException ex){
            errorMessage = ex.getDmlMessage(0);
            System.debug(ex.getDmlMessage(0));
        }
        return errorMessage;
    }


}