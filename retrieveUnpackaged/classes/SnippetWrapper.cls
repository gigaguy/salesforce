global class SnippetWrapper implements Comparable{
        
        //Topic Detials
        @AuraEnabled public String topicId {get;set;}
   		@AuraEnabled public String tName {get;set;}
        @AuraEnabled public String topicName {get;set;}
	    @AuraEnabled public String summaryOfComments {get;set;}  	 
	    @AuraEnabled public String agencyResponse {get;set;}
    
        //SnippetDetails
		@AuraEnabled public String snippetId {get;set;}
	    @AuraEnabled public String snippetName {get;set;}
	    @AuraEnabled public String pdfPage {get;set;}
	    @AuraEnabled public String snippetTName {get;set;}
        	
        @AuraEnabled public String agencyName {get;set;}
        @AuraEnabled public String extractedText {get;set;}
        @AuraEnabled public String notes {get;set;}
        @AuraEnabled public String snippetResponse {get;set;}
        @AuraEnabled public String references {get;set;}
    	//snippetStatus added - Quinton Hill 12/28/2017
    	@AuraEnabled public String snippetStatus {get;set;}
    
        //Submission Detials
        @AuraEnabled public String submissionId {get;set;}
		@AuraEnabled public String submissionNumber {get;set;}
	    @AuraEnabled public String commentorName {get;set;}
        //User export selection status
        @AuraEnabled public Boolean isSelected {get;set;}
        
    	//Added snippetStatus and snpStat - Quinton Hill 12/28/2017
    	global SnippetWrapper(String topcId,String topcName,String tNme,String summaryComments,String agncyResp,String snppetId,String snppetName,String pdfPageNu,String submssionId,String submssionNumbr,String commntorName,Boolean isSelcted, String agncName, String extrText, String nots, String snpResp, String reffrns, String snpStat){			
            
            topicId = topcId;
            snippetTName = '';
            topicName = topcName;
            tName = tNme;
            summaryOfComments = summaryComments;
            agencyResponse = agncyResp;
            snippetId = snppetId;
            snippetName = snppetName;
            pdfPage = pdfPageNu;            
            submissionId = submssionId;
            submissionNumber = (submssionNumbr!=null ? submssionNumbr : '');            
            commentorName = (commntorName !=null ? commntorName : '');
            isSelected = isSelcted;
            agencyName = (agncName!=null && agncName!='') ? agncName : commentorName;
            extractedText = extrText;
            notes = nots;
            snippetResponse = snpResp;
            references = reffrns;
            snippetStatus = snpStat;
        }
   		
        global Integer compareTo(Object compareTo) {
            SnippetWrapper compareToObj = (SnippetWrapper)compareTo;
            Integer returnValue = 0;
            try{
				Integer val1 = Integer.valueOf(submissionNumber);
	            Integer val2 = Integer.valueOf(compareToObj.submissionNumber);
    	        if(val1>val2){      
                    returnValue = 1;
                }else if(val1<val2){
                    returnValue = -1;
                }                
            }catch(Exception e){
                // Could not convert into integer
            }            
            return returnValue;
        }
    }