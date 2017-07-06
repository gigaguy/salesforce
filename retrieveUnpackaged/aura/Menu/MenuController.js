({
	gotoFormsPage : function (component) {
		var urlEvent = $A.get("e.force:navigateToURL");
		var url = "/FormPage?sID=" + component.get("v.sessionID");
		urlEvent.setParams({
		  "url": "/006"
		});
		urlEvent.fire();
	}
})