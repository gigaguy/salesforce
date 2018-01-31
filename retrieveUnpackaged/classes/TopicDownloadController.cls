/***
 * This is class has various methods to deal with topic and related objects like snippets. 
 ***/
public class TopicDownloadController {

    public static Integer NUMBER_OF_RECORDS_TO_RETURN = 8;
    // List of snippet wrappers. Visualforce page will read them.
    //public List<SnippetWrapper> snippets {get; set;}
	public Map<String,TopicsWrapper> mapTopics {get;set;}
    
    public Topic__c mainTopic {get; set;}
    public String mainTopicDisplayName {get; set;}
    // Export field options
    public Boolean expSummOfComm {get; set;}
    public Boolean expAgencyResp {get; set;}
    public Boolean expSpecComm {get; set;}
    public Boolean expComm {get; set;}
    public Boolean expNotes {get; set;}
    public Boolean expResp {get; set;}
    
    public TopicDownloadController(){
        // Here it downloads all the content which are requried to export in the doucment.
        // It is epxected that all the topic ids which are in the request are the subtopic Id's of a single main topic.
		String requIds = ApexPages.currentPage().getParameters().get('snpIds');
        String expOptions = ApexPages.currentPage().getParameters().get('expOptions');
        System.debug('requIds = '+requIds);
        System.debug('expOptions = '+expOptions);
        this.handleVisualPageRequest(requIds,expOptions);
    }
    public void handleVisualPageRequest(String requIds, String expOptions){
        this.updateExportFieldOtions(expOptions);
        if(requIds != null){
           List<String> snpIds = requIds.split(',');
           System.debug('snpIds= '+snpIds);
           
           String mainTopicId = null;
           //Snippet Status added to query - Quinton Hill 12/28/2017
            List<Snippet__c> allSnips = [SELECT Snippet_Status__c,Submission__r.Submission_Number__c,Submission__r.Agency_Name__c,Response__c,Submission__c,Submission__r.Commenter_Name__c,Notes__c,Related_Reference__c,Document_Number__c,Name,PDF_Page__c,Topic__c,Topic__r.Name,Topic__r.Topic_Name__c,Extracted_Text__c,Topic__r.Topic_Number__c,Topic__r.Comment_Summary__c,Topic__r.Agency_Comment_Response__c,Topic__r.Summary_of_Comments_on_this_Topic__c,Submission_Number__c FROM Snippet__c where id in :snpIds ORDER BY Topic__r.Topic_Number__c ASC];
           if(mapTopics==null){
                mapTopics = new Map<String,TopicsWrapper>();
           }
            if(allSnips.size() > 0){
                Integer counter = 0;
				for(Snippet__c snp : allSnips){
                    try{
					   List<String> snpNumbers = snp.Topic__r.Name.split('\\.');
                        if(snpNumbers.size()==0){
                            mainTopicId = snp.Topic__r.Name;
                        }
                        // Alter general topic's snippets number
                        String snpPrefix = null;						
                        List<String> snptNameSnips = snp.Topic__r.Topic_Name__c.split('\\.0');                            
                        if(snptNameSnips.size()>1){                            
                            snpPrefix = snptNameSnips[0];                            
                        }                        
                        //check if topicName is already in Map
                        SnippetWrapper snpWrapr = TopicDownloadController.createSnippetWrappers(snp,true,null,snpPrefix);
                        TopicsWrapper topicMapper = null;
                        Boolean updateTopicName = false;
                        if(mapTopics.containsKey(snpWrapr.topicName)){
                            topicMapper = mapTopics.get(snpWrapr.topicName);
                        }else{
                            topicMapper = new TopicsWrapper();
                            updateTopicName = true;
                            topicMapper.snippets = new List<SnippetWrapper>();
                        }
                        // Handle General Topic Title
                        if(counter==0){                            
                            List<String> topicNameSnips = snpWrapr.topicName.split('\\.0');                            
                            if(topicNameSnips.size()>1){                            
								topicMapper.topicName = topicNameSnips[0]+ '.0 General';                                
                            }                            
                        }
                        if(topicMapper.topicName==null){
							topicMapper.topicName = snpWrapr.topicName;                            
                        }
                        
                        topicMapper.snippets.add(snpWrapr);                        
						topicMapper.agencyResponse = snpWrapr.agencyResponse;
    	                topicMapper.summComments = snpWrapr.summaryOfComments;	                        					
        				counter+=1;                
                        mapTopics.put(snpWrapr.topicName, topicMapper);
                    }catch(Exception e){
                        System.debug(e.getMessage());
                    }                   
    	        }
                if(mainTopicId == null){
                    //System.debug('Need to fetch topic ');
                    Snippet__c snp = allSnips[0];
                    List<String> snpNumbers = snp.Topic__r.Name.split('\\.');
                    mainTopicId = (snpNumbers.size()>0)?snpNumbers[0]:'';
				}
                mainTopicId = mainTopicId+'.0';
                //System.debug('mainTopicId - ' + mainTopicId);
                for(Topic__c tempTopic : [select Name,Topic_Name__c,Topic_Number__c from Topic__c where Name = :mainTopicId]){
					mainTopic = tempTopic;
                    if(mainTopic.Topic_Number__c == null || mainTopic.Topic_Number__c.length() == 0){
                        List<String> stringComp = mainTopic.Name.split('\\.');
                        if(stringComp.size() > 0){
                            mainTopic.Topic_Number__c = stringComp[0];
                        }
                    }
                    break;
                }                
            }
            
            if(mainTopic.Topic_Name__c != null){
                List<String> stringComp = mainTopic.Topic_Name__c.split('\\.0');
                if(stringComp.size()>1){
                    mainTopicDisplayName = stringComp[0] + '.' + stringComp[1];
                }else{
                    mainTopicDisplayName = mainTopic.Topic_Name__c;
                }
            }
            // Sort snippets based on submission number
            for(TopicsWrapper tw : mapTopics.values()){
                if(tw.snippets!=null && tw.snippets.size()>1){
                    tw.snippets.sort();
                }
            }
        }
    }
    public void updateExportFieldOtions(String expOptions){
        
        expSummOfComm = true;
        expAgencyResp = true;
        expSpecComm = true;
        expComm = true;
        expNotes = true;
        expResp = true;
        
        //System.debug('expOptions= '+expOptions);           
        if(expOptions!=null){
            List<String> expOptns = expOptions.split(',');
            if(expOptns.size()>0){
				Set<String> setExpOptions = new Set<String>(expOptns);                
                expSummOfComm = setExpOptions.contains('1');
                expAgencyResp = setExpOptions.contains('2');
                expSpecComm = setExpOptions.contains('3');
                expResp = setExpOptions.contains('6');
                if(!expSpecComm){
                    expComm = expSpecComm;
                    expNotes = expSpecComm;
                }
                else{
					expComm = setExpOptions.contains('4');
	                expNotes = setExpOptions.contains('5');                    
                }                                                
            }
        }
    }
    public TopicDownloadController(ApexPages.StandardController standardController)
    {                        
       System.debug('TopicDownloadController -- >> >> '+ApexPages.currentPage().getParameters().get('snpIds'));       
    }
    
    /***
     * This method returns all topic and related snippet details for a given topic id.
     * Input - a topic id.
     * OutPut - Map contains a topic object and list of snipeets.
     ***/
	@AuraEnabled
    public static Map<String,Object> getAllSnippets(String topicId) {
        Map<String,Object> result = new Map<String,Object>();
        // get topic number for the selected topic
        List<Topic__c> topics = [select Name,Topic_Number__c from Topic__c where id = :topicId];
        if(topics.size() > 0){
			Topic__c topic = topics[0];
            List<Topic__c> relatedTopicIds = TopicDownloadController.getAllRelatedTopics(topic.Topic_Number__c);
       	 	result.put('topic', topic);
            result.put('snippets', [select Name,Topic__r.Name,Submission__r.Commenter_Name__c,Submission__r.Letter_Type__c,Submission__r.Submission_Number__c,Submission__r.Agency_Name__c,Snippet_Status__c from Snippet__c where Topic__c in :relatedTopicIds]);          
        }
        return result;
    }
    
    /***
     * This method returns TopicsWrapper for a given topic Id and page details. 
     * It Also, select if they are already selected by a user on the UI before.
     * Input - topicid, pagenumber, list of selected reocrd id's and a flag to indidate select all records.
     * Output - A TopicsWrapper which contains topic object, selected snippets, already selected recordId's and indicator for last page.
     ***/
    @AuraEnabled
    public static TopicsWrapper getSnippets(String topicId, Decimal pageNumber,List<String> selectedRecords,Boolean isAllSelected, Boolean isSearchFlow, String searchString) {
              
        TopicsWrapper topicsResult = new TopicsWrapper();
        try{
            Integer rightPageNumber = Integer.valueOf(pageNumber-1);
            Set<String> setSelectedIds = new Set<String>(selectedRecords);
        	Integer offSet = (rightPageNumber * NUMBER_OF_RECORDS_TO_RETURN);
			List<Topic__c> topics = [select Name,Topic_Number__c from Topic__c where id = :topicId];
            List<Topic__c> currentTopic = [select Name,Topic_Number__c, RecordTypeId from Topic__c where id = :topicId LIMIT 1];
            String currentTopicsRecordTypeID = '';
            for(Topic__c t : currentTopic){
            	currentTopicsRecordTypeID = t.RecordTypeId;
                system.debug('Record Type Name is: ' + currentTopicsRecordTypeID);
            }
        	//System.debug(offSet + ' AND >> ' + NUMBER_OF_RECORDS_TO_RETURN);
	        if(topics.size() > 0){
    	        Topic__c topic = topics[0];
        	    List<Topic__c> relatedTopicIds = TopicDownloadController.getAllRelatedTopics(topic.Name);                       
            	List<SnippetWrapper> snippetsWrapper = new List<SnippetWrapper>();
	            // Filter for search flow
    	        List<Snippet__c> allSnips = null;
                List<Id> allMatchedRecordIds = null;
        	    if(isSearchFlow){
            	    String likePattern = searchString+'%';
					System.debug(pageNumber + ' AND with agency Name ' + offSet + ' isSearchFlow '+ likePattern);
	                //Snippet Status added to query - Quinton Hill 12/28/2017
                    allSnips = [select Name,Snippet_Status__c,Submission_Number__c,PDF_Page__c,Extracted_Text__c,Notes__c,Response__c,Related_Reference__c,Topic__r.Name,Topic__r.Topic_Name__c,Topic__r.Summary_of_Comments_on_this_Topic__c,Topic__r.Agency_Comment_Response__c,Submission__r.Commenter_Name__c,Submission__r.Letter_Type__c,Submission__r.Submission_Number__c,Submission__r.Agency_Name__c 
                            from Snippet__c where Topic__c in :relatedTopicIds AND Topic__r.RecordTypeId = :currentTopicsRecordTypeID AND 
                            (NAME LIKE :likePattern OR Topic__r.Name LIKE :likePattern OR Submission__r.Submission_Number__c LIKE :likePattern OR Submission__r.Commenter_Name__c LIKE :likePattern  OR Submission__r.Agency_Name__c LIKE :likePattern OR Snippet_Status__c LIKE :likePattern)
                            ORDER BY Topic__c LIMIT :NUMBER_OF_RECORDS_TO_RETURN OFFSET :offSet];
                    //Get max records with this search
                    //Snippet Status added to query - Quinton Hill 12/28/2017
                    allMatchedRecordIds = new List<Id>(new Map<Id,Snippet__c>([select Id from Snippet__c where Topic__c in :relatedTopicIds AND Topic__r.RecordTypeId = :currentTopicsRecordTypeID AND 
                            (NAME LIKE :likePattern OR Topic__r.Name LIKE :likePattern OR Submission__r.Submission_Number__c LIKE :likePattern OR Submission__r.Commenter_Name__c LIKE :likePattern OR Submission__r.Agency_Name__c LIKE :likePattern OR Snippet_Status__c LIKE :likePattern)]).keySet());
            	}else{
                	//Snippet Status added to query - Quinton Hill 12/28/2017
                    allSnips = [select Name,Snippet_Status__c,Submission_Number__c,PDF_Page__c,Extracted_Text__c,Notes__c,Response__c,Related_Reference__c,Topic__r.Name,Topic__r.Topic_Name__c,Topic__r.Summary_of_Comments_on_this_Topic__c,Topic__r.Agency_Comment_Response__c,Submission__r.Commenter_Name__c,Submission__r.Letter_Type__c,Submission__r.Submission_Number__c,Submission__r.Agency_Name__c 
                            from Snippet__c where Topic__c in :relatedTopicIds AND Topic__r.RecordTypeId = :currentTopicsRecordTypeID ORDER BY Topic__c 
                            LIMIT :NUMBER_OF_RECORDS_TO_RETURN OFFSET :offSet];
                    //Get max records with this search
                    allMatchedRecordIds = new List<Id>(new Map<Id,Snippet__c>([select Id from Snippet__c where Topic__c in :relatedTopicIds AND Topic__r.RecordTypeId = :currentTopicsRecordTypeID]).keySet());
	            }
    	        for(Snippet__c snp : allSnips){
        	    	snippetsWrapper.add(TopicDownloadController.createSnippetWrappers(snp,isAllSelected,setSelectedIds,null));
            	}
	            topicsResult.selectedIds = new List<String>(setSelectedIds);
    	        topicsResult.topic = topic;
        	    topicsResult.snippets = snippetsWrapper;
            	topicsResult.isLastPage = (snippetsWrapper.size() < NUMBER_OF_RECORDS_TO_RETURN);
                topicsResult.allMatchedRecordIds = allMatchedRecordIds;
        }
          }catch(Exception e){
                    
         }                
        return topicsResult;
    }
    
    public static SnippetWrapper createSnippetWrappers(Snippet__c snp, Boolean isAllSelected, Set<String> setSelectedIds, String snpPrefix){

        SnippetWrapper snippetWrapper = null;
		String snpName = snp.Name;
        String snpId = snp.Id;
        String pdfPage = snp.PDF_Page__c;
        String summarComments = '';
        String topicAgencyResponse = '';
        
        String extrText = snp.Extracted_Text__c;
        String notes = snp.Notes__c;
        String snpResp = snp.Response__c;
        String reffernces = snp.Related_Reference__c;
        String agencyName = '';
        String topcName = '';
        String tName = '';
        String topcId = '';
        String subNumber = '';
        String subId = '';
        String submitorName = '';
        // snpStat added by Quinton Hill 12/28/17
        String snpStat = snp.Snippet_Status__c;
        if(snp.Submission_Number__c != null){
            subNumber = snp.Submission_Number__c;
        }
        
        Boolean isSelected = (isAllSelected)?true:(setSelectedIds != null && setSelectedIds.contains(snpId));
            try{
                if(isSelected && setSelectedIds != null){
                    setSelectedIds.add(snpId);
                }
                if(snp.Topic__r != null){
                    
                    tName = snp.Topic__r.Name;
                    if(snpPrefix!=null){
                       tName = snpPrefix;
                       System.debug('snpPrefix - '+tName);
                    }
                    topcName = snp.Topic__r.Topic_Name__c;
                    topcId = snp.Topic__r.Id;
                    summarComments = snp.Topic__r.Summary_of_Comments_on_this_Topic__c; 
                    topicAgencyResponse = snp.Topic__r.Agency_Comment_Response__c; 
                }
                if(snp.Submission__r != null){
                    //subNumber = snp.Submission__r.Submission_Number__c;
                    subId = snp.Submission__r.Id;
                    submitorName = snp.Submission__r.Commenter_Name__c;
                    agencyName = snp.Submission__r.Agency_Name__c;
                                        
                    //System.debug('submitorName ' + subNumber + ' = ' + agencyName + ' =' + submitorName);
                }
            }catch(Exception e){
                System.debug('createSnippetWrappers -' + e.getMessage());                        
            }                          	
        // added snpStat to query - Quinton Hill 12/28/2017
        snippetWrapper = (new SnippetWrapper(topcId,topcName,(tName!=null?tName:''),(summarComments!=null?summarComments:''),(topicAgencyResponse!=null?topicAgencyResponse:''),snpId,snpName,pdfPage,subId,subNumber,submitorName,isSelected,(agencyName!=null?agencyName:''),(extrText!=null?extrText:''),(notes!=null?notes:''),(snpResp!=null?snpResp:''),(reffernces!=null?reffernces:''),snpStat));
        return snippetWrapper;        
    }
    /***
     * This method gets all topic and subtopic detils for a give topic number
     *  Input - 
     *  topicNumber
     *  Output - 
     * 	returns List of Topic's
     ***/
    public static List<Topic__c> getAllRelatedTopics(String topicNumber){
        
        String topicPattern = ''; 
        List<String> stringComponents = topicNumber.split('\\.');
        if(stringComponents.size()>1){
            String strComp2 = stringComponents[1];
            Integer intVal = Integer.valueOf(strComp2);            
            List<Topic__c> allTopics = null;
            if(intVal==0){
                topicPattern = stringComponents[0] + '.%';				
                try{
             		allTopics = [select Id from Topic__c where Name like :topicPattern];   
                }catch(Exception e){
                    System.debug(e);
                    allTopics = new List<Topic__c>();
                }
            }else{                
                topicPattern = topicNumber;
				String subTopicPattern = topicNumber + '.%';                                
                try{
             		allTopics = [select Id from Topic__c where Name like :topicPattern OR Name like :subTopicPattern];   
                }catch(Exception e){
                    System.debug(e);
                    allTopics = new List<Topic__c>();
                }
            }			                                                         
            return allTopics;            
        }else{
			
            if(stringComponents.size() > 0){
                String parentNumber = stringComponents[0];
                topicPattern =  parentNumber + '.%';
                String pattern2 = parentNumber + ' %';
                System.debug(topicPattern + ' &&& ' + pattern2);
                return [select Id from Topic__c where Name like : topicPattern OR Name like : pattern2];
            }
            else{
                topicPattern = topicNumber+' %';
                System.debug('topicPattern ='+topicPattern);
                return [select Id from Topic__c where Name like : topicPattern];
            }            
        }		               
    }
    /***
     * This class is a data model to bind differnet data sets.
     ***/
    public class TopicsWrapper{
        
        @AuraEnabled public Integer pageSize {get;set;}
    	@AuraEnabled public Integer page {get;set;}
	    @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public Boolean isLastPage {get;set;}
        @AuraEnabled public Topic__c topic {get;set;}
        
		@AuraEnabled public List<Id> allMatchedRecordIds {get;set;}
                    
        @AuraEnabled public String topicName {get;set;}
        @AuraEnabled public String summComments {get;set;}
        @AuraEnabled public String agencyResponse {get;set;}
        
        @AuraEnabled public List<String> selectedIds {get;set;}        
	    @AuraEnabled public List<SnippetWrapper> snippets {get;set;}
    }
}