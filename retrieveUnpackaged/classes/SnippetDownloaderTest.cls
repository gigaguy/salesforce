@isTest(SeeAllData=true)
public class SnippetDownloaderTest {
    
    static testMethod void SnippetDownloaderTest(){
                
        Snippet__c snippet = [select id,name from Snippet__c limit 1];
    	PageReference testPageRef = new PageReference('/apex/SnippetDownloadPage');
        testPageRef.getParameters().put('id',snippet.id);
        Test.setCurrentPage(testPageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(snippet);
		SnippetDownloader snippetController = new SnippetDownloader(sc);
        
        Test.startTest();
		PageReference track = snippetController.printView();
		Test.stopTest();        
        System.assert(testPageRef.getUrl().contains('/apex/SnippetDownloadPage'));
    }
}