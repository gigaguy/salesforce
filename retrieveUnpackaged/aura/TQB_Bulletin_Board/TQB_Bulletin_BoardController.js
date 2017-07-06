({
	doInit  : function(component, event) {
		var action = component.get("c.bulletinPosts");
        action.setCallback(this, function(a) {
             component.set("v.TQBBulletinBoards", a.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})