({
	getProgressBarItems : function(component) {        
		var action = component.get("c.getLetters");
        var self = this;        
        action.setCallback(this, function(a) {
            component.set("v.LettersOfIntent", a.getReturnValue());
            self.getPackages(component);                            
        });
        $A.enqueueAction(action);
	},    
    getPackages : function(component) {        
		var action = component.get("c.getPackages");        
        action.setCallback(this, function(a) {            
            component.set("v.CandidatePackages", a.getReturnValue());                
        });
        $A.enqueueAction(action);
	}        
})