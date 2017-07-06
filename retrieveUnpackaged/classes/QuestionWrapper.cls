global class QuestionWrapper {
    
    @AuraEnabled
    public TQB_Candidate_Questionnaire__c question { get;set; }
    
    @AuraEnabled 
    public boolean hasNext { get;set; }
    
    @AuraEnabled 
    public boolean hasPrev { get;set; }
    
    @AuraEnabled 
    public Integer total { get;set; }

    @AuraEnabled 
    public Decimal questionNumber { get;set; }

    @AuraEnabled 
    public TQB_Candidate_Package__c candpackage { get;set; }

    @AuraEnabled 
    public Id packageId { get;set; }

    @AuraEnabled 
    public String firstLineComment { get;set; }

    @AuraEnabled 
    public String secondLineComment { get;set; }

}