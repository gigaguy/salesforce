({
	getTopicsDetails : function(component, page, isNextClick, isSearching, searchString) {
	

      var recordId = component.get('v.recordId');
      var action = component.get("c.getSnippets");      
      action.setParams({
         "topicId": recordId,
         "selectedRecords" : component.get('v.selectedTopicIds'),
         "pageNumber": page,
         "isAllSelected" : component.get('v.isAllSelected'),
         "isSearchFlow" : isSearching,
         "searchString" : searchString
      });
        action.setCallback(this, function(response) {         
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
                    var result = response.getReturnValue();
                    var isLastPage = result.isLastPage;
                	var selectedIds = result.selectedIds;
                	var allMatchedRecordIds = result.allMatchedRecordIds;
                	component.set("v.selectedTopicIds", selectedIds);
	                component.set("v.allMatchedRecordIds", allMatchedRecordIds);
                    component.set("v.isLastPage", isLastPage);
	                var allChildRecords = result.snippets;
                    //if(allChildRecords.length > 0)
                    {                        
                    	var topic = {};
	                    var tempTopic = result.topic;//mapResult["topic"];
    	                if(tempTopic!= null && tempTopic != undefined){
        	                topic = tempTopic;
            	        }
                	    else{
                    	   topic["Name"] = recordId;
                    	}
                    	component.set('v.topic',topic);
	                   // console.log('result=='+JSON.stringify(result));
	                   // console.log('allMatchedRecordIds ='+allMatchedRecordIds.length);
    	                component.set('v.allSnippets',allChildRecords);
        	            var allRecords = component.get('v.allRecords');
            	        if(allRecords == undefined || allRecords.length == 0){
                	        allRecords = [];
                    	}
                        Array.prototype.push.apply(allRecords,allChildRecords);
    	                component.set('v.allRecords',allRecords);
                   		 //Update actions
                        if(isNextClick){               
                            isSearching?component.set("v.searchPage", (page)):component.set("v.page", (page));
                        }
                        else{
                            isSearching?component.set("v.searchPage", (page)):component.set("v.page", (page));
                        }
                        component.set("v.isFirstPage", (page==1));                        
                	}                
            }
        });
        
      $A.enqueueAction(action);
	},
    updateExportOptions:function(component,optionNumber){
      	var exportOptions = component.get('v.exportOptions');  
        if(exportOptions.indexOf(optionNumber) == -1){
             exportOptions.push(optionNumber);                    
        }else{
            var index = exportOptions.indexOf(optionNumber);
			exportOptions.splice(index, 1);
        }
        component.set('v.exportOptions',exportOptions);  
    },
    saveSelectedRecords: function(component) {        
        var selectedTopicIds = component.get('v.selectedTopicIds');
        var allSnippets = component.get('v.allSnippets');
        for(var co=0;co<allSnippets.length;co++){
            var topic = allSnippets[co];
            var topicItem = document.getElementById('contItem'+co);
            if(topicItem.checked){
                if(selectedTopicIds.indexOf(topic.snippetId) == -1){
                    selectedTopicIds.push(topic.snippetId);                    
                }
            }else{
                var indx = selectedTopicIds.indexOf(topic.snippetId);
                if(indx > -1){
                    selectedTopicIds.splice(indx,1);
                }
            }
            //console.log(topic.Name + ' is Selected ' + topicItem.checked);            
        }
        component.set('v.selectedTopicIds',selectedTopicIds);
        component.set('v.numberOfSelectedRecords ',selectedTopicIds.length);
        //console.log('selectedTopicIds = '+JSON.stringify(selectedTopicIds));
    },
    filterRecords : function(component) {
        
        
    }
    
})