({
	doInit  : function(component, event) {
		var action = component.get("c.getBulletinPosts");
        action.setCallback(this, function(a) {
             component.set("v.TQBBulletinBoards", a.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})