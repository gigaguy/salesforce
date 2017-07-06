({
	populateAdHocDetail : function(component, event, helper) {
		var selected = event.getParam("candpkg");
		component.set("v.candPackage",selected);
		selected = event.getParam("adhocView");
		component.set("v.adHocEntry",selected);
	},
	editAdHoc : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var adhocentry = component.get("v.adHocEntry");				
		var evt = $A.get("e.c:TQBCPEditAdHoc");
		evt.setParams({ "candpkg": pkg, "adhocEdit": adhocentry });
		evt.fire();
	},
	backToAdHocList : function(component, event, helper) {
		/*var toggleText = component.find("adHocListView");
		$A.util.removeClass(toggleText,'toggle');
		var toggleText = component.find("adHocDetailView");
		$A.util.addClass(toggleText,'toggle');
		var toggleText = component.find("adHocEditView");
		$A.util.addClass(toggleText,'toggle');*/

		var pkg = component.get("v.candPackage");
		var evt = $A.get("e.c:TQBCPAdHocNavigator");
		evt.setParams({ "candpkg": pkg });
		evt.fire();

		//var pkg = component.get("v.candPackage");
		//var evt = $A.get("e.c:TQBCPBackToAdHocList");
		//evt.fire();

	}
})