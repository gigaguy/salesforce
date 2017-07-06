public class FormsPageController {

    public id selectedRTID {get;set;}
    public string selectedRTName {get;set;}
    public Forms__c form {get;set;}
    
    public boolean authenticated {get;set;}
    private map<string, string> params;
    public List<RecordType> getFormRTs(){
        return [select id, Name from RecordType where sObjectType = 'Forms__c']; 
    }
    
    public FormsPageController(){
        params = ApexPages.currentPage().getParameters();

    }
    
    public void onLoad(){
        
		checkAuthenticated();        
    }
    
    public void checkAuthenticated(){
        authenticated = true;
        
        authenticated = params.get('authenticated') == '1' ? true : false;
    }
    
    public pageReference saveForm(){
        upsert form;
        return null;
    }
    public pageReference pickRT(){
        form = new Forms__c(RecordTypeID = selectedRTID,
                           	Name__c = 'Test Form',
                           	Quantity__c = 1);
        insert form;
        return null;
        //return new ApexPages.StandardController(form).edit();
    }
}