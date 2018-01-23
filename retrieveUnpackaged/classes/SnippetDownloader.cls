public class SnippetDownloader {
    
    public Map<String,String> requests { get; set; }
    public List<Snippet__c> snippets {get; set;}
    
	public Id Id { get; set; }
    public Snippet__c snippet { get; set; }
    public String userText = '';
    
    public SnippetDownloader(ApexPages.StandardController standardController)
    {                        
        snippet = (Snippet__c) standardController.getRecord();
        Id = snippet.Id;       
        requests = new Map<String,String>();
    }
  
    public SnippetDownloader()
    {
        requests = new Map<String,String>();         
		snippets = [SELECT Submission_Number__c,Response__c,Submission__c,	Notes__c,Related_Reference__c,Document_Number__c,Name,Topic__c,Topic__r.Name,Extracted_Text__c,Topic__r.Topic_Number__c,Topic__r.Comment_Summary__c,Topic__r.Agency_Comment_Response__c FROM Snippet__c ORDER BY Topic__r.Topic_Number__c ASC];
    }
         
	public PageReference printView() {        
     requests.put('userText', userText);
   	 PageReference oPageRef = Page.TopicDownloadPage;
     oPageRef.setRedirect(false);
     return oPageRef;
	}
}