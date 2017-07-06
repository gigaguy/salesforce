({
	createLOIRecord : function (component, event, helper) {
    var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.setParams({
        "entityApiName": "TQB_Letter_of_Intent__c"
    });
    createRecordEvent.fire();
},
	createCandidateRecord : function (component, event, helper) {
    var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.setParams({
        "entityApiName": "TQB_Candidate_Package__c"
    });
    createRecordEvent.fire();
}
})