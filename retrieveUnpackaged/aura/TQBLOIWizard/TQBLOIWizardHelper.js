({
	getLOIStatusList : function(component) {
        var action = component.get("c.getLOIStatusListData");
        action.setCallback(this, function(a) {
             component.set("v.LOIStatus", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getLOICurrentLabWorkList : function(component) {
        var action = component.get("c.getLOICurrentLabWorkListData");
        action.setCallback(this, function(a) {
             component.set("v.currentLabAssignment", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getLOICurrentGSList : function(component) {
        var action = component.get("c.getLOICurrentGSListData");
        action.setCallback(this, function(a) {
             component.set("v.currentGSLevel", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getLOICurrentRegionList : function(component) {
        var action = component.get("c.getLOICurrentRegionListData");
        action.setCallback(this, function(a) {
             component.set("v.currentRegion", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getLOIIntendedTrackList : function(component) {
        var action = component.get("c.getLOIIntendedTrackListData");
        action.setCallback(this, function(a) {
             component.set("v.LOIIntendedTrack", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getLOI1stLineSupervisorList: function(component){

    	var action = component.get("c.getLOI1stlineSupervisorListData");
        action.setCallback(this, function(a) {
             component.set("v.LOI1stlineSupervisor", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getLOI2ndLineSupervisorList: function(component){

        var action = component.get("c.getLOI2ndlineSupervisorListData");
        action.setCallback(this, function(a) {
             component.set("v.LOI2ndlineSupervisor", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    validateLOIFormData : function(component) {

        Console.log('Validating the LOI record');
        
        //getting the LOI information
        var LOIinfo = component.get("v.newLOIPackage");
        
        //validation
        if($A.util.isEmpty(LOIinfo.Current_Lab_Work_Location_Assignment__c) || $A.util.isUndefined(LOIinfo.Current_Lab_Work_Location_Assignment__c)){
            alert('Current Lab work location is required');
            return;
        }
        if($A.util.isEmpty(LOIinfo.Current_GS_Level__c) || $A.util.isUndefined(LOIinfo.Current_GS_Level__c)){
            alert('Current GS level is required');
            return;
        }
        if($A.util.isEmpty(LOIinfo.CurrentRegion__c) || $A.util.isUndefined(LOIinfo.CurrentRegion__c)){
            alert('Current Region is required');
            return;
        }
        if($A.util.isEmpty(LOIinfo.IntendedTrack__c) || $A.util.isUndefined(LOIinfo.IntendedTrack__c)){
            alert('Intended Track is required');
            return;
        }
        if($A.util.isEmpty(LOIinfo.Status__c) || $A.util.isUndefined(LOIinfo.Status__c)){
            alert('Status is required');
            return;
        }
    }
})