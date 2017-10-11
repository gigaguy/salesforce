({
    getFandP_Forms : function(component){
    	var action = component.get("c.getFandP_FormRTs");
       
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS") {
                component.set("v.FandP_forms", response.getReturnValue());
            }
        });
     $A.enqueueAction(action);
	},
    upload: function(component, file, base64Data, callback) {
        var formID;
            if (component.get("v.modalName") == 'viewForm') {
                formID = component.get("v.viewFormID");
            }
            else {
                formID = component.get("v.newForm.Id");
            }
        console.log('formID: ' + formID);
        console.log('file name: ' + file.name);
        console.log('contentType: ' + file.type);
        var action = component.get("c.uploadFile");
        console.log('type: ' + file.type);
        action.setParams({
            FormID: formID,
            fileName: file.name,
            base64Data: base64Data,
            contentType: file.type
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state: ' + state);
            if (state === "SUCCESS") {
                callback(a.getReturnValue());
                this.getAttachList(component, formID);
            }
        });
        $A.enqueueAction(action);
    },
    show: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hide:function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    getAttachList : function(component, formID){
 /*       var formID;
        if (component.get("v.modalName") == 'viewForm') {
            formID = component.get("v.viewFormID");
        }
        else {
            formID = component.get("v.newForm.Id");
        }
   */ console.log('formID: ' + formID);     
        var action = component.get("c.getListOfAttachments");
       		action.setParams({
			"formID" : formID
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            console.log('getting attachment list');
            console.log('name' + name);
            console.log('return value: ' + response.getReturnValue().length);
            if (name === "SUCCESS" && response.getReturnValue().length > 0) {
                console.log('in here');
                component.set("v.attachList", response.getReturnValue());
                component.set("v.hasAttachments", true);
            }
        });
     $A.enqueueAction(action);
	}
})