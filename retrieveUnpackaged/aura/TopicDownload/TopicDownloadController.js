({
	doInit : function(component, event, helper) {
                
        var isSearching = component.get('v.isSearching');                
        var curPage = component.get("v.page");
        if(isSearching){
            curPage = component.get("v.searchPage");
        }
        helper.saveSelectedRecords(component);
        helper.getTopicsDetails(component,curPage,true,isSearching,'');
        /*
	   //component.set('v.recordId','001r0000007vIWEAA2');
       var recordId = component.get('v.recordId'); 
       var action = component.get("c.getAllSnippets");
       action.setParams({
            "topicId": recordId
       });
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
				var mapResult = response.getReturnValue();
                var allChildRecords = mapResult["snippets"];
                var topic = {};
                var tempTopic = mapResult["topic"];
                if(tempTopic!= null && tempTopic != undefined){
                    topic = tempTopic;
                }
                else{
                   topic["Name"] = recordId;
                }
                component.set('v.topic',topic);
                //console.log('mapResult=='+JSON.stringify(mapResult));
                component.set('v.allSnippets',allChildRecords);
                component.set('v.allRecords',allChildRecords);
            }
        });
   		$A.enqueueAction(action);
        */
	},
    closeModal : function(component, event, helper) { 
        /*
        var allSnippets = component.get('v.allSnippets');
        for(var co=0;co<allSnippets.length;co++){
            var cont = allSnippets[co];
            var contItem = document.getElementById('contItem'+co);
            console.log(cont.Name + ' is Selected ' + contItem.checked);
            console.log('--');
        }
        */
        $A.get("e.force:closeQuickAction").fire();
    },
    changeInSearch : function(component, event, helper) {
        
        var action = component.get("c.getSnippets");
        
        var searchText = component.get('v.filterText');

        
        var allSnippets = component.get('v.allRecords'); 
        var filterList = [];
        if(searchText.length==0){
                        
            component.set('v.searchPage',"1");
            component.set('v.isSearching',false);
            
            helper.saveSelectedRecords(component);
    	    var curPage = component.get("v.page");
	        helper.getTopicsDetails(component,curPage,false,'');
			
			var page = component.get('v.page');
            var currentPageRecords = allSnippets.slice((page-1)*2,(page-1)+3);
            console.log(JSON.stringify(allSnippets) + '\n\n' + JSON.stringify(currentPageRecords));
            component.set('v.allSnippets',[]);            
            component.set('v.allSnippets',currentPageRecords);
			           
        }
        else{
            var isSearching = true;
            var curPage = 1;
            component.set('v.isSearching',isSearching);                  	
            component.set('v.searchPage',curPage);
    	    helper.saveSelectedRecords(component);        
	        helper.getTopicsDetails(component,curPage,true,isSearching,searchText);                        
        }
        //console.log('\n' + JSON.stringify(filterList)+'\n');
        $A.enqueueAction(action);
    },
    snippetSelect : function(component, event, helper) {        
        //console.log('snippetSelect - ');
    },
    itemCheckAction: function(component, event, helper) { 
        helper.saveSelectedRecords(component);
    },
    selectAll: function(component, event, helper) { 
        
        var allSnippets = component.get('v.allSnippets');
        var checkBoxAll = document.getElementById('selectAll');        
        var isSelected = false;
        if(checkBoxAll.checked){
            isSelected = true;
        }               
        component.set('v.isAllSelected',isSelected);
        var selectedTopicIds = component.get('v.selectedTopicIds');
        selectedTopicIds = [];
        for(var co=0;co<allSnippets.length;co++){
            var contItem = document.getElementById('contItem'+co);
            if(contItem!=null){
				contItem.checked = isSelected;
                var topic = allSnippets[co];
                selectedTopicIds.push(topic.snippetId);         
            }
        }
        component.set('v.selectedTopicIds',selectedTopicIds);
        var numberOfSelected = 0;
        if(isSelected){
           var allMatchedRecordIds = component.get('v.allMatchedRecordIds');
           numberOfSelected = allMatchedRecordIds.length;
        }
        component.set('v.numberOfSelectedRecords ',numberOfSelected);
    },
    previousPage: function(component, event, helper) {
        
        var isSearching = component.get('v.isSearching');                
        var curPage = component.get("v.page");
        var searchText = '';                
        if(isSearching){
            curPage = component.get("v.searchPage");
            searchText = component.get('v.filterText');
            //console.log('searchText='+searchText);
        }
        helper.saveSelectedRecords(component);
        helper.getTopicsDetails(component,(curPage-1),false,isSearching,searchText);
    },
    nextPage: function(component, event, helper) { 
        
        var isSearching = component.get('v.isSearching');                
        var curPage = component.get("v.page");        
        var searchText = '';                
        if(isSearching){
            curPage = component.get("v.searchPage");
            searchText = component.get('v.filterText');
            console.log('searchText='+searchText);
        }
        helper.saveSelectedRecords(component);        
        helper.getTopicsDetails(component,(curPage+1),true,isSearching,searchText);        
    },
    exportCheckBoxAction1: function(component, event, helper) {
        helper.updateExportOptions(component,"1");
    },
    exportCheckBoxAction2: function(component, event, helper) {
		helper.updateExportOptions(component,"2");
    },
    exportCheckBoxAction3: function(component, event, helper) {
		var isChecked = document.getElementById("checkbox-3").checked;
        var item4 = document.getElementById("checkbox-4");
        var item5 = document.getElementById("checkbox-5");
        var item6 = document.getElementById("checkbox-6");
        
        item4.checked = isChecked; 
        item5.checked = isChecked;
        item6.checked = isChecked;
        
        item4.disabled  = !isChecked; 
        item5.disabled  = !isChecked; 
        item6.disabled  = !isChecked; 
        
        helper.updateExportOptions(component,"3");
        helper.updateExportOptions(component,"4");
        helper.updateExportOptions(component,"5");
        helper.updateExportOptions(component,"6");
    },
    exportCheckBoxAction4: function(component, event, helper) {
        helper.updateExportOptions(component,"4");
    },
    exportCheckBoxAction5: function(component, event, helper) {
        helper.updateExportOptions(component,"5");
    },
    exportCheckBoxAction6: function(component, event, helper) {
        helper.updateExportOptions(component,"6");
    },
    downloadAction: function(component, event, helper) {
        
      var exportOptions = component.get('v.exportOptions');
      var strExpOpt = exportOptions.toString();
      var checkBoxAll = document.getElementById('selectAll');
	  var selectedRecords = component.get('v.selectedTopicIds');
      if(checkBoxAll.checked){
            selectedRecords = component.get("v.allMatchedRecordIds");
        }
       var urlEvent = $A.get("e.force:navigateToURL");
       var url = "/apex/TopicDownloadPage?snpIds=";
       var reqData = selectedRecords.toString();
        
        url = url + reqData;
        url = url + "&expOptions="+strExpOpt;
        //console.log('url='+url);        
        urlEvent.setParams({
            "url": url,                  
        });
        urlEvent.fire();               
        $A.get("e.force:closeQuickAction").fire();
        
       /*
       var action = component.get("c.downloadContnet");
       action.setParams({
            "selectedRecords": selectedRecords
       });
       action.setCallback(this, function(response) {
            var state = response.getState();
            alert(state);
            if (component.isValid() && state === "SUCCESS") {
                console.log('downloadContnet '+state);
                
                var urlEvent = $A.get("e.force:navigateToURL");
                var url = "/apex/DemoWordGeneration?snpIds=";
                var reqData = selectedRecords.toString();
                alert(reqData);
                url = url + reqData;                
                urlEvent.setParams({
                  "url": url,                  
                });
                urlEvent.fire();
				 
                //window.open("/apex/DemoWordGeneration");
                
                $A.get("e.force:closeQuickAction").fire(); 
            }});
        $A.enqueueAction(action);
        */
    }
})