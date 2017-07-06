({
	selectQuestion : function(component, event, helper) {
		var pkg = component.get("v.candPackage");
		var quest = component.get("v.question");
		console.log('pkg value');
		console.log(pkg);
		console.log('quest value');
		console.log(quest);
		var evt = $A.get("e.c:TQBCPEditQA");
		evt.setParams({ "candpkg": pkg, "question": quest });
		evt.fire();
	}
})