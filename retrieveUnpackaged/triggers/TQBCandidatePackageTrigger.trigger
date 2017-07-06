trigger TQBCandidatePackageTrigger on TQB_Candidate_Package__c (before insert) {
    
    String UserId = UserInfo.getUserId();
    List<TQB_Letter_of_Intent__c> LOI = new List<TQB_Letter_of_Intent__c>([select Status__c from TQB_Letter_of_Intent__c where CreatedById = :UserId]);
    
    List<TQB_Candidate_Package__c> candidatePackageList = new List<TQB_Candidate_Package__c>([select Name from TQB_Candidate_Package__c where CreatedById = :UserId]);
    
    
    for(TQB_Candidate_Package__c candidatePackage : Trigger.new)
    {         
        System.debug(LOI.size());
         System.debug(candidatePackage.Name);
         if(LOI.size() == 0) {
            candidatePackage.addError('Please create Letter of intent first before creating candidate package ');
        }
        if(candidatePackageList.size() > 0) {
            candidatePackage.addError('You cannot add more than one Candidate package');
        } 
        if(LOI.size() !=0) {
             if(LOI[0].Status__c == 'In Progress') {
                 candidatePackage.addError('You cannot create new Candidate Package before LOI is submitted');
             }
        }
        if(LOI.size() !=0 && LOI[0].Status__c != 'Approved') {
            if(candidatePackage.Status__c == 'Submitted') {
                candidatePackage.Status__c.addError('You cannot submit new Candidate Package before LOI is Approved');
            }
        }

    }
}